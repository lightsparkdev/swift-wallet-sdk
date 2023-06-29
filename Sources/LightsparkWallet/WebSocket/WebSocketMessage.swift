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

public enum WebSocketMessageError: Error {
    case stringParsingError
    case jsonDataParsingError
    case missingMessageTypeError
}

struct WebSocketMessage {
    var type: WebSocketMessageType
    var id: String?
    var payload: Any?
}

extension WebSocketMessage {
    func toJSONString() throws -> String {
        var jsonDictionary : [String: Any] = [
            "type": type.rawValue
        ]

        if let id = id {
            jsonDictionary["id"] = id
        }

        if let payload = payload {
            jsonDictionary["payload"] = payload
        }

        let jsonData = try JSONSerialization.data(withJSONObject: jsonDictionary)
        guard let jsonString = String(data: jsonData, encoding: .utf8) else {
            throw WebSocketMessageError.stringParsingError
        }
        return jsonString
    }

    static func fromJSON(jsonData: Data) throws -> Self {
        guard let json = try JSONSerialization.jsonObject(with: jsonData) as? [String: Any] else {
            throw WebSocketMessageError.jsonDataParsingError
        }

        guard let typeString = json["type"] as? String,
              let type = WebSocketMessageType(rawValue: typeString) else {
            throw WebSocketMessageError.missingMessageTypeError
        }

        return WebSocketMessage(type: type, id: json["id"] as? String, payload: json["payload"])
    }
}

// Factory methods
extension WebSocketMessage {
    static func connectionInitMessage(payload: Any?) -> WebSocketMessage {
        return WebSocketMessage(type: .ConnectionInit, payload: payload)
    }

    static func pingMessage(payload: Any?) -> WebSocketMessage {
        return WebSocketMessage(type: .Ping, payload: payload)
    }

    static func pongMessage(payload: Any?) -> WebSocketMessage {
        return WebSocketMessage(type: .Pong, payload: payload)
    }

    static func completeMessage(id: String) -> WebSocketMessage {
        return WebSocketMessage(type: .Complete, id: id)
    }

    static func subscribeMessage(id: String, operation: Operation) -> WebSocketMessage {
        return WebSocketMessage(type: .Subscribe, id: id, payload: operation.payloadDictionary())
    }
}
