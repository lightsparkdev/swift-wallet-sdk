//
//  Operation.swift
//  
//
//  Created by Zhen Lu on 6/26/23.
//  Copyright © 2023 Lightspark Group, Inc. All rights reserved.
//


import Foundation

struct Operation {
    var operation: String
    var variables: [AnyHashable: Any?]
    var signingKey: SecKey?
}

extension Operation {
    func payloadDictionary() -> [String: Any]? {
        let pattern = #"\s*(?:query|mutation|subscription)\s+(\w+)"#
        guard let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else {
            return nil
        }
        var operationName: String? = nil
        if let match = regex.firstMatch(
            in: operation,
            options: [],
            range: NSRange(location: 0, length: operation.count)
        ) {
            operationName = String(operation[Range(match.range(at: 1), in: operation)!])
        }

        guard let operationName = operationName else {
            return nil
        }

        let payloadDictionary: [String: Any] = [
            "operationName": operationName,
            "query": operation,
            "variables": variables,
        ]
        return payloadDictionary
    }
}
