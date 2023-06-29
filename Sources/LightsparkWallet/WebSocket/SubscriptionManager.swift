//
//  SubscriptionManager.swift
//  LightsparkWallet
//
//  Created by Zhen Lu on 6/22/23.
//  Copyright © 2023 Lightspark Group, Inc. All rights reserved.
//


import Combine
import Foundation

public enum SubscriptionError: Error {
    case protocolCreationError
    case operationError
}

protocol SubscriptionManagerDelegate: AnyObject {
    func subscriptionManagerRequestWebSocketTask(subscrptionManager: SubscriptionManager) throws -> URLSessionWebSocketTask
}

class SubscriptionManager {
    func closeProtocol() {
        if let webSocketProtocol = self.webSocketProtocol {
            webSocketProtocol.close()
            self.webSocketProtocol = nil
            self.idleTimer?.invalidate()
            self.idleTimer = nil
        }
    }

    func executeGraphqlOperationPublisher(operation: Operation) -> AnyPublisher<Data, Error> {
        let subject = PassthroughSubject<Data, Error>()
        do {
            try self.createWebSocketProtocolIfNeeded()
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
        guard let webSocketProtocol = self.webSocketProtocol else {
            return Fail(error: SubscriptionError.protocolCreationError).eraseToAnyPublisher()
        }
        let id = webSocketProtocol.subscribe(operation: operation)
        self.subscriptions[id] = (operation, subject)
        return subject.eraseToAnyPublisher()
    }

    private func createWebSocketProtocolIfNeeded() throws {
        guard self.webSocketProtocol == nil else {
            return
        }

        guard let delegate = self.delegate else {
            return
        }

        let webSocketProtocol = GraphQLWebSocketProtocol(webSocketTask: try delegate.subscriptionManagerRequestWebSocketTask(subscrptionManager: self))
        webSocketProtocol.delegate = self
        webSocketProtocol.connectionInit()
        self.webSocketProtocol = webSocketProtocol
    }

    weak var delegate: SubscriptionManagerDelegate?
    private var subscriptions = [String : (Operation, PassthroughSubject<Data, Error>)]() {
        didSet {
            if subscriptions.isEmpty {
                idleTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: false, block: { _ in
                    self.closeProtocol()
                })
            } else {
                idleTimer?.invalidate()
                idleTimer = nil
            }
        }
    }
    private var webSocketProtocol: GraphQLWebSocketProtocol? = nil
    private var idleTimer: Timer?
}

extension SubscriptionManager: GraphQLWebSocketProtocolDelegate {
    func graphQLWebSocketProtocol(protocol: GraphQLWebSocketProtocol, didReceiveMessage message: WebSocketMessage) {
        guard let id = message.id,
                message.type == .Next || message.type == .Error,
                let payload = message.payload else {
            return
        }

        guard let (_, subject) = subscriptions[id] else {
            // This should never happen, but in case this happens, try send a close message to the server.
            return
        }

        guard let data = try? JSONSerialization.data(withJSONObject: payload) else {
            return
        }

        if message.type == .Error {
            if let graphqlError = try? JSONDecoder().decode(GraphQLError.self, from: data) {
                subject.send(completion: .failure(graphqlError))
            } else {
                subject.send(completion: .failure(SubscriptionError.operationError))
            }

            subscriptions.removeValue(forKey: id)
        } else {
            subject.send(data)
        }
    }

    func graphQLWebSocketProtocol(protocol: GraphQLWebSocketProtocol, error: Error) {
        // An error occurs, close the protocol
        // TODO: try to reconnect.
        self.closeProtocol()
    }

    func graphQLWebSocketProtocol(protocol: GraphQLWebSocketProtocol, operationComplete id: String) {
        guard let (_, subject) = subscriptions[id] else {
            return
        }

        subject.send(completion: .finished)
        subscriptions.removeValue(forKey: id)
    }
}
