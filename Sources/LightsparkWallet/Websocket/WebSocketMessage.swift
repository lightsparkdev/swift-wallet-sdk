//
//  WebSocketMessage.swift
//  LightsparkWallet
//
//  Created by Zhen Lu on 6/20/23.
//  Copyright © 2023 Lightspark Group, Inc. All rights reserved.
//


import Foundation

enum WebSocketMessageType: String, Codable {
    // Client -> Server
    case ConnectionInit = "connection_init"
    case Subscribe = "subscribe"

    // Server -> Client
    case ConnectionAck = "connection_ack"
    case Next = "next"
    case Complete = "complete"
    case Error = "error"

    // Bidirectional
    case Ping = "ping"
    case Pong = "pong"
}

struct WebSocketMessage : Codable {
    enum WebSocketMessageError: Error {
        case stringConversionError
    }
    var type: WebSocketMessageType
    var id: String?
    var payload: String?

    func toJSONString() throws -> String {
        let jsonEncoder = JSONEncoder()
        let jsonData = try jsonEncoder.encode(self)
        guard let string = String(data: jsonData, encoding: .utf8) else {
            throw WebSocketMessageError.stringConversionError
        }
        return string
    }
}

extension WebSocketMessage {
    static func connectionInitMessage(payload: String?) -> WebSocketMessage {
        return WebSocketMessage(type: .ConnectionInit, payload: payload)
    }

    static func pingMessage(payload: String?) -> WebSocketMessage {
        return WebSocketMessage(type: .Ping, payload: payload)
    }

    static func pongMessage(payload: String?) -> WebSocketMessage {
        return WebSocketMessage(type: .Pong, payload: payload)
    }

    static func completeMessage(id: String) -> WebSocketMessage {
        return WebSocketMessage(type: .Complete, id: id)
    }
}
