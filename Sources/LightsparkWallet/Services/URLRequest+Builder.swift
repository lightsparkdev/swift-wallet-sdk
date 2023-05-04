//
//  URLRequest+Builder.swift
//  LightsparkWallet
//
//  Created by Zhen Lu on 4/24/23.
//  Copyright © 2023 Lightspark Group, Inc. All rights reserved.
//

import Foundation

// TODO: Replace this to prod url.
let defaultBaseURLString = "https://api.dev.dev.sparkinfra.net/graphql/wallet/rc"

public enum URLRequestBuilderError: Error {
    case baseURLStringError
}

extension URLRequest {

    /// Builds a URLRequest for a Lightspark GraphQL operation.
    ///
    /// - Parameter baseURLString: The base URL string for the GraphQL server.
    /// - Parameter operation: The GraphQL operation.
    /// - Parameter variables: The variables for the GraphQL operation.
    /// - Parameter signingKey: The signing key for the GraphQL operation.
    ///
    /// - Returns: A URLRequest for the GraphQL operation.
    static public func buildURLRequest(
        baseURLString: String?,
        operation: String,
        variables: [AnyHashable: Any?],
        signingKey: SecKey?
    ) throws -> URLRequest {
        guard let baseURL = URL(string: baseURLString ?? defaultBaseURLString) else {
            throw URLRequestBuilderError.baseURLStringError
        }
        var urlRequest = URLRequest(url: baseURL)
        urlRequest.httpMethod = "POST"

        let pattern = #"\s*(?:query|mutation)\s+(\w+)"#
        let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        var operationName: String? = nil
        if let match = regex.firstMatch(
            in: operation,
            options: [],
            range: NSRange(location: 0, length: operation.count)
        ) {
            operationName = String(operation[Range(match.range(at: 1), in: operation)!])
        }

        var payloadDictionary: [String: Any?] = [
            "operationName": operationName,
            "query": operation,
            "variables": variables,
        ]

        if signingKey != nil {
            payloadDictionary["nonce"] = UInt32.random(in: UInt32.min...UInt32.max)
            payloadDictionary["expires_at"] = ISO8601DateFormatter().string(from: (Date(timeIntervalSinceNow: 3600)))
        }

        let body = try JSONSerialization.data(withJSONObject: payloadDictionary)
        if let signingKey = signingKey {
            let signature = try Signing.signPayload(key: signingKey, payload: body)
            urlRequest.addValue(signature, forHTTPHeaderField: "X-Lightspark-Signing")
        }

        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if let operationName = operationName {
            urlRequest.addValue(operationName, forHTTPHeaderField: "X-GraphQL-Operation")
        }

        urlRequest.httpBody = body
        return urlRequest
    }
}
