//
//  SubscriptionManager.swift
//  
//
//  Created by Zhen Lu on 6/22/23.
//  Copyright © 2023 Lightspark Group, Inc. All rights reserved.
//


import Combine
import Foundation

public enum SubscriptionError: Error {
    case protocolCreationError
}

class SubscriptionManager {
    init(requester: Requester) {
        self.requester = requester
    }

    func closeProtocol() {
        if let websocketProtocol = self.websocketProtocol {
            websocketProtocol.close()
            self.websocketProtocol = nil
        }
    }

    func executeGraphqlOperationPublisher(operation: Operation) -> AnyPublisher<Data, Error> {
        let subject = PassthroughSubject<Data, Error>()
        self.createWebsocketProtocolIfNeeded()
        guard let websocketProtocol = self.websocketProtocol else {
            return Fail(error: SubscriptionError.protocolCreationError).eraseToAnyPublisher()
        }
        let id = websocketProtocol.subscribe()
        self.subscriptions[id] = (operation, subject)
        return subject.eraseToAnyPublisher()
    }

    private func createWebsocketProtocolIfNeeded() {
        guard self.websocketProtocol == nil else {
            return
        }

        guard let requester = self.requester else {
            return
        }

        let websocketProtocol = GraphQLWebsocketProtocol(websocketTask: requester.createWebsocketTask())
        websocketProtocol.delegate = self
        websocketProtocol.connectionInit()
        self.websocketProtocol = websocketProtocol
    }

    fileprivate var subscriptions = [String : (Operation, PassthroughSubject<Data, Error>)]()
    fileprivate weak var requester: Requester?
    fileprivate var websocketProtocol: GraphQLWebsocketProtocol? = nil
}

extension SubscriptionManager: GraphQLWebsocketProtocolDelegate {
    func graphQLWebsocketProtocol(protocol: GraphQLWebsocketProtocol, didReceiveMessage message: WebsocketMessage) {
        guard let id = message.id, message.type == .Next, let payload = message.payload else {
            print("Wrong message type routed to the subscription manager or message is not complete.")
            return
        }

        guard let (_, subject) = subscriptions[id] else {
            // This should never happen, but in case this happens, try send a close message to the server.
            return
        }

        guard let data = payload.data(using: .utf8) else {
            print("parsing error")
            return
        }

        subject.send(data)
    }

    func graphQLWebsocketProtocol(protocol: GraphQLWebsocketProtocol, operationError: String) {
        // An operation error, emit the error to the user.
    }

    func graphQLWebsocketProtocol(protocol: GraphQLWebsocketProtocol, error: Error) {
        // An error occurs, close the protocol
        // TODO: try to reconnect.
        self.closeProtocol()
    }

    func graphQLWebsocketProtocol(protocol: GraphQLWebsocketProtocol, operationComplete id: String) {
        guard let (_, subject) = subscriptions[id] else {
            return
        }

        subject.send(completion: .finished)
        subscriptions.removeValue(forKey: id)
    }
}
