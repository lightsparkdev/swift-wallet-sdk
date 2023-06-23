//
//  GraphqlWebsocketProtocol.swift
//  
//
//  Created by Zhen Lu on 6/21/23.
//  Copyright © 2023 Lightspark Group, Inc. All rights reserved.
//


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
        self.websocketTask.resume()
    }

    func connectionInit(payload: String? = nil) {
        let message = WebsocketMessage.connectionInitMessage(payload: payload)
        self.send(message: message)
    }

    func subscribe() -> String {
        let uuid = UUID().uuidString
        // TODO: send the query
        return uuid
    }

    func ping(payload: String? = nil) {
        let message = WebsocketMessage.pingMessage(payload: payload)
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
    }

    private func send(message: WebsocketMessage) {
        
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
    weak var delegate: GraphQLWebsocketProtocolDelegate?
}
