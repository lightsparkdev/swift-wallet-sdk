//
//  WebsocketMessage.swift
//  
//
//  Created by Zhen Lu on 6/20/23.
//  Copyright © 2023 Lightspark Group, Inc. All rights reserved.
//


import Foundation

enum WebsocketMessageType: String, Codable {
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

struct WebsocketMessage : Codable {
    enum WebSocketMessageError: Error {
        case stringConversionError
    }
    var type: WebsocketMessageType
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

extension WebsocketMessage {
    static func connectionInitMessage(payload: String?) -> WebsocketMessage {
        return WebsocketMessage(type: .ConnectionInit, payload: payload)
    }

    static func pingMessage(payload: String?) -> WebsocketMessage {
        return WebsocketMessage(type: .Ping, payload: payload)
    }

    static func pongMessage(payload: String?) -> WebsocketMessage {
        return WebsocketMessage(type: .Pong, payload: payload)
    }

    static func completeMessage(id: String) -> WebsocketMessage {
        return WebsocketMessage(type: .Complete, id: id)
    }
}
