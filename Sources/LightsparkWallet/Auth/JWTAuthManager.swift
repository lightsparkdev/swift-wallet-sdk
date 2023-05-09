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
    public init(authStateStorage: AuthStateStorage = UserDefaultAuthStorage()) {
        self.authStateStorage = authStateStorage
    }

    public func login(
        accountID: String,
        secret: String,
        baseURLString: String? = nil,
        additionalHttpHeaders: [AnyHashable: Any] = [:],
        completion: @escaping (String?, Error?) -> Void
    ) {
        let variables = [
            "account_id": accountID,
            "jwt": secret,
        ]

        let request: URLRequest
        do {
            request = try URLRequest.buildURLRequest(
                baseURLString: baseURLString,
                operation: self.jwtMutation,
                variables: variables,
                signingKey: nil
            )
        } catch {
            completion(nil, error)
            return
        }

        var headers = additionalHttpHeaders
        headers["User-Agent"] = Requester.userAgentString
        headers["X-Lightspark-SDK"] = Requester.userAgentString

        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = headers
        let urlSession = URLSession(configuration: config)

        urlSession.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(nil, nil)
                return
            }
            do {
                let response = try JSONDecoder.lightsparkJSONDecoder().decode(
                    Response<LoginWithJWTOutput>.self,
                    from: data
                )
                if let data = response.data {
                    let output = data
                    let token = AccessToken(token: output.accessToken, expiration: output.validUntil)
                    let tokenData = try JSONEncoder().encode(token)
                    self.authStateStorage.storeAuthStateData(data: tokenData)
                    completion(token.token, nil)
                } else {
                    completion(nil, response.errors?.first)
                }
            } catch {
                completion(nil, error)
            }
        }
        .resume()
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

    private let authStateStorage: AuthStateStorage

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
