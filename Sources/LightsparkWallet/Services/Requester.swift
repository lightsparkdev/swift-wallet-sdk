//
//  Requester.swift
//  LightsparkWallet
//
//  Created by Zhen Lu on 4/20/23.
//  Copyright © 2023 Lightspark Group, Inc. All rights reserved.
//

import Combine
import Foundation

/// A class for making Lightspark GraphQL requests.
public final class Requester {
    public init(
        authorization: String,
        baseURLString: String? = nil,
        httpAdditionalHeaders: [AnyHashable: Any]? = nil
    ) {
        self.baseURLString = baseURLString

        let configuration = URLSessionConfiguration.default
        var additionalHeaders: [AnyHashable: Any] = [
            "Authorization": authorization,
            "User-Agent": Self.userAgentString,
            "X-Lightspark-SDK": Self.userAgentString
        ]
        if let httpAdditionalHeaders = httpAdditionalHeaders {
            for (k, v) in httpAdditionalHeaders {
                additionalHeaders[k] = v
            }
        }
        configuration.httpAdditionalHeaders = additionalHeaders
        self.urlSession = URLSession(configuration: configuration)
    }

    public func executeGraphQLOperation(
        operation: String,
        variables: [AnyHashable: Any?] = [:],
        signingKey: SecKey? = nil
    ) async throws -> Data {
        let urlRequest = try URLRequest.buildURLRequest(
            baseURLString: self.baseURLString,
            operation: operation,
            variables: variables,
            signingKey: signingKey
        )
        let (data, _) = try await self.urlSession.data(for: urlRequest)
        return data
    }

    public func executeGraphQLOperation(
        operation: String,
        variables: [AnyHashable: Any?] = [:],
        signingKey: SecKey? = nil,
        completion: @escaping (Data?, Error?) -> Void
    ) {
        let urlRequest: URLRequest
        do {
            urlRequest = try URLRequest.buildURLRequest(
                baseURLString: self.baseURLString,
                operation: operation,
                variables: variables,
                signingKey: signingKey
            )
            self.urlSession.dataTask(with: urlRequest) { data, _, error in
                completion(data, error)
            }.resume()
        } catch {
            completion(nil, error)
        }
    }

    public func executeGraphQLOperationPublisher(
        operation: String,
        variables: [AnyHashable: Any?] = [:],
        signingKey: SecKey? = nil
    ) -> AnyPublisher<Data, Error> {
        let urlRequest: URLRequest
        do {
            urlRequest = try URLRequest.buildURLRequest(
                baseURLString: self.baseURLString,
                operation: operation,
                variables: variables,
                signingKey: signingKey
            )
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }

        return self.urlSession.dataTaskPublisher(for: urlRequest)
            .map { data, response in
                data
            }
            .mapError({ error in
                error as Error
            })
            .eraseToAnyPublisher()
    }

    static var userAgentString: String {
        "lightspark-swift-wallet-sdk/\(version) \(systemName())/\(ProcessInfo.processInfo.operatingSystemVersionString)"
    }

    private let urlSession: URLSession
    private let baseURLString: String?
}
