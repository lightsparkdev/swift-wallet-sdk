//
//  GraphqlWebSocketProtocol.swift
//  
//
//  Created by Zhen Lu on 6/21/23.
//  Copyright © 2023 Lightspark Group, Inc. All rights reserved.
//


import Combine
import Foundation

protocol GraphQLWebSocketProtocolDelegate: AnyObject {
    func graphQLWebSocketProtocol(protocol: GraphQLWebSocketProtocol, didReceiveMessage: WebSocketMessage)
    func graphQLWebSocketProtocol(protocol: GraphQLWebSocketProtocol, error: Error)
    func graphQLWebSocketProtocol(protocol: GraphQLWebSocketProtocol, operationComplete: String)
    // TODO: Add on close
}

public enum GraphQLWebSocketProtocolError: Error {
    case timeout
}

class GraphQLWebSocketProtocol {
    static let ackTimeOut = 60.0

    init(webSocketTask: URLSessionWebSocketTask) {
        self.webSocketTask = webSocketTask
        self.messageQueue = MessageQueuePublisher()
        self.webSocketTask.resume()
        self.receive()
    }

    func connectionInit(payload: String? = nil) {
        let message = WebSocketMessage.connectionInitMessage(payload: payload)
        self.reallySend(message: message)
        self.ackTimer = Timer.scheduledTimer(withTimeInterval: Self.ackTimeOut, repeats: false, block: { _ in
            self.delegate?.graphQLWebSocketProtocol(protocol: self, error: GraphQLWebSocketProtocolError.timeout)
        })
    }

    func subscribe(operation: Operation) -> String {
        let uuid = UUID().uuidString
        let message = WebSocketMessage.subscribeMessage(id: uuid, operation: operation)
        self.send(message: message)
        return uuid
    }

    func complete(id: String) {
        let message = WebSocketMessage.completeMessage(id: id)
        self.send(message: message)
    }

    func ping(payload: String? = nil) {
        let message = WebSocketMessage.pingMessage(payload: payload)
        // TODO: store this ping and wait for pong.
        self.send(message: message)
    }

    func close() {
        webSocketTask.cancel()
    }

    func receive() {
        self.webSocketTask.receive { [weak self] result in
            if let strongSelf = self {
#if DEBUG
                print("WebSocket: Receive \(result)")
#endif
                switch result {
                case .success(let message):
                    strongSelf.handleServerMessages(message: message)

                    // Resume receving the next message.
                    strongSelf.receive()
                case .failure(let error):
                    strongSelf.delegate?.graphQLWebSocketProtocol(protocol: strongSelf, error: error)
                }
            }
        }
    }

    func handleServerMessages(message: URLSessionWebSocketTask.Message) {
        let jsonData: Data?
        switch message {
        case .string(let stringValue):
            jsonData = stringValue.data(using: .utf8)
        case .data(let dataValue):
            jsonData = dataValue
        @unknown default:
            return
        }

        guard let jsonData = jsonData else {
            return
        }

        guard let webSocketMessage: WebSocketMessage = try? WebSocketMessage.fromJSON(jsonData: jsonData) else {
            return
        }

        switch webSocketMessage.type {
        case .ConnectionAck:
            // Connection initiated
            self.connectionAckReceived()
            break

        case .Next, .Error:
            // Move the message to the delegate to handle.
            self.delegate?.graphQLWebSocketProtocol(protocol: self, didReceiveMessage: webSocketMessage)
            break

        case .Complete:
            guard let id = webSocketMessage.id else {
                break
            }
            self.delegate?.graphQLWebSocketProtocol(protocol: self, operationComplete: id)

        case .Ping:
            self.pong()
            break

        case .Pong:
            // TODO: clear current on flying ping.
            break

        case .ConnectionInit, .Subscribe:
            // Client -> Server only messages
            break
        }
    }

    private func pong(payload: String? = nil) {
        let message = WebSocketMessage.pongMessage(payload: payload)
        self.send(message: message)
    }

    private func send(message: WebSocketMessage) {
        self.messageQueue.send(message)
    }

    private func connectionAckReceived() {
        self.messageQueue.sink { [weak self] message in
            self?.reallySend(message: message)
        }
        .store(in: &self.subscribers)
        self.ackTimer?.invalidate()
        self.ackTimer = nil
    }

    private func reallySend(message: WebSocketMessage) {
        do {
            let jsonString = try message.toJSONString()
            let messageToSend = URLSessionWebSocketTask.Message.string(jsonString)
#if DEBUG
            print("WebSocket: Send \(jsonString)")
#endif
            webSocketTask.send(messageToSend) { [weak self] error in
                if let error = error, let strongSelf = self {
                    strongSelf.delegate?.graphQLWebSocketProtocol(protocol: strongSelf, error: error)
                }
            }
        } catch {
            self.delegate?.graphQLWebSocketProtocol(protocol: self, error: error)
        }
    }

    private let webSocketTask: URLSessionWebSocketTask
    private let messageQueue: MessageQueuePublisher<WebSocketMessage>
    private var subscribers = [AnyCancellable]()
    private var ackTimer: Timer?
    weak var delegate: GraphQLWebSocketProtocolDelegate?
}
