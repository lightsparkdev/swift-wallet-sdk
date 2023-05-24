//
//  JWTAuthManager.swift
//  LightsparkWallet
//
//  Created by Zhen Lu on 4/24/23.
//  Copyright © 2023 Lightspark Group, Inc. All rights reserved.
//

import Combine
import Foundation

struct AccessToken: Codable {
    var token: String
    var expiration: Date
}

public class JWTAuthManager {
    public enum JWTAuthManagerError: Error {
        case parseError
    }
    public init(
        authStateStorage: AuthStateStorage = UserDefaultAuthStorage(),
        baseURLString: String? = nil,
        additionalHttpHeaders: [AnyHashable: Any] = [:]
    ) {
        self.authStateStorage = authStateStorage

        var headers = additionalHttpHeaders
        headers["User-Agent"] = Requester.userAgentString
        headers["X-Lightspark-SDK"] = Requester.userAgentString
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = headers
        self.urlSession = URLSession(configuration: config)
        self.baseURLString = baseURLString
    }

    public func loginPublisher(
        accountID: String,
        secret: String
    ) -> AnyPublisher<String, Error> {
        let variables = [
            "account_id": accountID,
            "jwt": secret,
        ]

        let request: URLRequest
        do {
            request = try URLRequest.buildURLRequest(
                baseURLString: self.baseURLString,
                operation: self.jwtMutation,
                variables: variables,
                signingKey: nil
            )
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }

        return self.urlSession.dataTaskPublisher(for: request)
            .tryMap { data, _ in
                try self.parseResultDataToAccessToken(data: data)
            }
            .eraseToAnyPublisher()
    }

    public func login(
        accountID: String,
        secret: String,
        completion: @escaping (String?, Error?) -> Void
    ) {
        let variables = [
            "account_id": accountID,
            "jwt": secret,
        ]

        let request: URLRequest
        do {
            request = try URLRequest.buildURLRequest(
                baseURLString: self.baseURLString,
                operation: self.jwtMutation,
                variables: variables,
                signingKey: nil
            )
        } catch {
            completion(nil, error)
            return
        }

        self.urlSession.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(nil, nil)
                return
            }
            do {
                completion(try self.parseResultDataToAccessToken(data: data), nil)
            } catch {
                completion(nil, error)
            }
        }
        .resume()
    }

    public func login(accountID: String, secret: String) async throws -> String {
        let variables = [
            "account_id": accountID,
            "jwt": secret,
        ]

        let request = try URLRequest.buildURLRequest(
            baseURLString: self.baseURLString,
            operation: self.jwtMutation,
            variables: variables,
            signingKey: nil
        )

        let (data, _) = try await self.urlSession.data(for: request)
        return try self.parseResultDataToAccessToken(data: data)
    }

    public func loadAuthToken() -> String? {
        guard let authTokenData = self.authStateStorage.getAuthStateData() else {
            return nil
        }
        guard let token = try? JSONDecoder().decode(AccessToken.self, from: authTokenData) else {
            return nil
        }
        guard token.expiration.timeIntervalSince(Date()) > 0 else {
            return nil
        }

        return token.token
    }

    private func parseResultDataToAccessToken(data: Data) throws -> String {
        let response = try JSONDecoder.lightsparkJSONDecoder().decode(
            Response<LoginWithJWTOutput>.self,
            from: data
        )
        guard let data = response.data else {
            throw JWTAuthManagerError.parseError
        }

        let token = AccessToken(token: data.accessToken, expiration: data.validUntil)
        let tokenData = try JSONEncoder().encode(token)
        self.authStateStorage.storeAuthStateData(data: tokenData)
        return token.token
    }

    private let authStateStorage: AuthStateStorage
    private let urlSession: URLSession
    private let baseURLString: String?

    private let jwtMutation = """
        mutation LogingWithJWT(
            $account_id: ID!,
            $jwt: String!,
        ) {
            login_with_jwt(input: {
                account_id: $account_id,
                jwt: $jwt,
            }) {
                ...LoginWithJWTOutputFragment
            }
        }

        \(LoginWithJWTOutput.fragment)
        """
}
