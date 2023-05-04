//
//  JSONDecoder+Lightspark.swift
//  LightsparkWallet
//
//  Created by Zhen Lu on 4/21/23.
//  Copyright © 2023 Lightspark Group, Inc. All rights reserved.
//

import Foundation

extension JSONDecoder {
    static func lightsparkJSONDecoder() -> JSONDecoder {
        let jsonDecoder = JSONDecoder()
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        let formatterWithoutOptions = ISO8601DateFormatter()

        jsonDecoder.dateDecodingStrategy = .custom({ decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            if let date = formatter.date(from: dateString) {
                return date
            } else if let date = formatterWithoutOptions.date(from: dateString) {
                return date
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date format")
            }
        })
        return jsonDecoder
    }
}
