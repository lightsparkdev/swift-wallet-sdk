//
//  GraphqlWebsocketProtocol.swift
//  
//
//  Created by Zhen Lu on 6/21/23.
//  Copyright © 2023 Lightspark Group, Inc. All rights reserved.
//


import Combine
import Foundation

protocol GraphQLWebsocketProtocolDelegate: AnyObject {
    func graphQLWebsocketProtocol(protocol: GraphQLWebsocketProtocol, didReceiveMessage: WebsocketMessage)
    func graphQLWebsocketProtocol(protocol: GraphQLWebsocketProtocol, onError: Error)
    func graphQLWebsocketProtocol(protocol: GraphQLWebsocketProtocol, operationComplete: String)
    // TODO: Add on close
}

class GraphQLWebsocketProtocol {
    init(websocketTask: URLSessionWebSocketTask, delegate: GraphQLWebsocketProtocolDelegate?) {
        self.websocketTask = websocketTask
        self.delegate = delegate
        self.messageQueue = MessageQueuePublisher()
        self.websocketTask.resume()
    }

    func connectionInit(payload: String? = nil) {
        let message = WebsocketMessage.connectionInitMessage(payload: payload)
        self.reallySend(message: message)
    }

    func subscribe() -> String {
        let uuid = UUID().uuidString
        // TODO: send the query
        return uuid
    }

    func ping(payload: String? = nil) {
        let message = WebsocketMessage.pingMessage(payload: payload)
        // TODO: store this ping and wait for pong.
        self.send(message: message)
    }

    func close() {
        websocketTask.cancel()
    }

    func receive() {
        self.websocketTask.receive { [weak self] result in
            if let strongSelf = self {
                switch result {
                case .success(let message):
                    strongSelf.handleServerMessages(message: message)

                    // Resume receving the next message.
                    strongSelf.receive()
                case .failure(let error):
                    strongSelf.delegate?.graphQLWebsocketProtocol(protocol: strongSelf, onError: error)
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

        let jsonDecoder = JSONDecoder()
        let websocketMessage: WebsocketMessage
        do {
            websocketMessage = try jsonDecoder.decode(WebsocketMessage.self, from: jsonData)
        } catch {
            print("json decoder error")
            return
        }

        switch websocketMessage.type {
        case .ConnectionAck:
            // Connection initiated
            self.connectionAckReceived()
            break

        case .Next, .Complete, .Error:
            // Move the message to the delegate to handle.
            self.delegate?.graphQLWebsocketProtocol(protocol: self, didReceiveMessage: websocketMessage)
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
        let message = WebsocketMessage.pongMessage(payload: payload)
        self.send(message: message)
    }

    private func send(message: WebsocketMessage) {
        self.messageQueue.send(message)
    }

    private func connectionAckReceived() {
        self.messageQueue.sink { [weak self] message in
            self?.reallySend(message: message)
        }
        .store(in: &self.subscribers)
    }

    private func reallySend(message: WebsocketMessage) {
        do {
            let messageToSend = URLSessionWebSocketTask.Message.string(try message.toJSONString())
            websocketTask.send(messageToSend) { [weak self] error in
                if let error = error, let strongSelf = self {
                    strongSelf.delegate?.graphQLWebsocketProtocol(protocol: strongSelf, onError: error)
                }
            }
        } catch {
            self.delegate?.graphQLWebsocketProtocol(protocol: self, onError: error)
        }
    }

    private let websocketTask: URLSessionWebSocketTask
    private let messageQueue: MessageQueuePublisher<WebsocketMessage>
    private var subscribers = [AnyCancellable]()
    weak var delegate: GraphQLWebsocketProtocolDelegate?
}
