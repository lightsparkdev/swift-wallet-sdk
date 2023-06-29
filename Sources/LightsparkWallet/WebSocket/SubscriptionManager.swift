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
    case networkError
}

protocol SubscriptionManagerDelegate: AnyObject {
    func subscriptionManagerRequestWebSocketTask(subscrptionManager: SubscriptionManager) throws -> URLSessionWebSocketTask
}

class SubscriptionManager {
    func closeProtocol() {
        self.workQueue.async {
            if let webSocketProtocol = self.webSocketProtocol {
                webSocketProtocol.close()
                self.webSocketProtocol = nil
                self.idleTimer?.invalidate()
                self.idleTimer = nil
            }
            if !self.retryConnectionIfNeeded() {
                self.closeAllSubscriptions()
            }
        }
    }

    func executeGraphqlOperationPublisher(operation: Operation) -> AnyPublisher<Data, Error> {
        self.workQueue.sync {
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

    private func retryConnectionIfNeeded() -> Bool {
        return false
    }

    private func closeAllSubscriptions() {
        self.subscriptions.values.forEach { (operation, subject) in
            subject.send(completion: .failure(SubscriptionError.networkError))
        }
    }

    weak var delegate: SubscriptionManagerDelegate?
    private var subscriptions = [String : (Operation, PassthroughSubject<Data, Error>)]() {
        didSet {
            self.workQueue.async {
                if self.subscriptions.isEmpty {
                    self.idleTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: false, block: { _ in
                        self.closeProtocol()
                    })
                } else {
                    self.idleTimer?.invalidate()
                    self.idleTimer = nil
                }
            }
        }
    }
    private var webSocketProtocol: GraphQLWebSocketProtocol? = nil
    private var idleTimer: Timer?
    private let workQueue = DispatchQueue(label: "com.lightspark.subscriptionManagerQueue")
}

extension SubscriptionManager: GraphQLWebSocketProtocolDelegate {
    func graphQLWebSocketProtocol(protocol: GraphQLWebSocketProtocol, didReceiveMessage message: WebSocketMessage) {
        self.workQueue.async {
            guard let id = message.id,
                  message.type == .Next || message.type == .Error,
                  let payload = message.payload else {
                return
            }

            guard let (_, subject) = self.subscriptions[id] else {
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

                self.subscriptions.removeValue(forKey: id)
            } else {
                subject.send(data)
            }
        }
    }

    func graphQLWebSocketProtocol(protocol: GraphQLWebSocketProtocol, error: Error) {
        self.closeProtocol()
    }

    func graphQLWebSocketProtocol(protocol: GraphQLWebSocketProtocol, operationComplete id: String) {
        self.workQueue.async {
            guard let (_, subject) = self.subscriptions[id] else {
                return
            }

            subject.send(completion: .finished)
            self.subscriptions.removeValue(forKey: id)
        }
    }
}
