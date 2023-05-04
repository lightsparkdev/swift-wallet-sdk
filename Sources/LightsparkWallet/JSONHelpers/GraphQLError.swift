//
//  GraphQLError.swift
//  LightsparkWallet
//
//  Created by Zhen Lu on 4/25/23.
//  Copyright © 2023 Lightspark Group, Inc. All rights reserved.
//

import Foundation

public struct GraphqlErrorExtension: Decodable {
    private enum CodingKeys: String, CodingKey {
        case errorName = "error_name"
    }

    public var errorName: String?
}

public struct GraphQLError: Error, Decodable {
    public var message: String?
    public var extensions: GraphqlErrorExtension?
    public var path: [String]?
}
