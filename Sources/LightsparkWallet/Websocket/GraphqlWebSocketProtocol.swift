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
    func graphQLWebSocketProtocol(protocol: GraphQLWebSocketProtocol, id: String, operationError: String)
    func graphQLWebSocketProtocol(protocol: GraphQLWebSocketProtocol, error: Error)
    func graphQLWebSocketProtocol(protocol: GraphQLWebSocketProtocol, operationComplete: String)
    // TODO: Add on close
}

class GraphQLWebSocketProtocol {
    init(webSocketTask: URLSessionWebSocketTask) {
        self.webSocketTask = webSocketTask
        self.messageQueue = MessageQueuePublisher()
        self.webSocketTask.resume()
        self.receive()
    }

    func connectionInit(payload: String? = nil) {
        let message = WebSocketMessage.connectionInitMessage(payload: payload)
        self.reallySend(message: message)
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
                print("WebSocket: Receive \(result)")
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
            print("message contains unknown type")
            return
        }

        guard let jsonData = jsonData else {
            print("jsonData empty")
            return
        }

        let webSocketMessage: WebSocketMessage
        do {
            webSocketMessage = try WebSocketMessage.fromJSON(jsonData: jsonData)
        } catch {
            print(error)
            return
        }

        switch webSocketMessage.type {
        case .ConnectionAck:
            // Connection initiated
            self.connectionAckReceived()
            break

        case .Next:
            // Move the message to the delegate to handle.
            self.delegate?.graphQLWebSocketProtocol(protocol: self, didReceiveMessage: webSocketMessage)
            break

        case .Complete:
            guard let id = webSocketMessage.id else {
                print("ID is empty for Complete message.")
                break
            }
            self.delegate?.graphQLWebSocketProtocol(protocol: self, operationComplete: id)

        case .Error:
//            guard let id = webSocketMessage.id,
//                  let error = webSocketMessage.payload else {
//                print("Payload is empty for Error message.")
//                break
//            }
//            self.delegate?.graphQLWebSocketProtocol(protocol: self, id: id, operationError: error)
            break

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
    weak var delegate: GraphQLWebSocketProtocolDelegate?
}
