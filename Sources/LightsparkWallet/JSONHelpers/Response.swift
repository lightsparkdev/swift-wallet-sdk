//
//  Response.swift
//  LightsparkWallet
//
//  Created by Zhen Lu on 4/21/23.
//  Copyright © 2023 Lightspark Group, Inc. All rights reserved.
//

import Foundation

struct Response<T: Decodable>: Decodable {
    let data: T?
    let errors: [GraphQLError]?

    private enum CodingKeys: String, CodingKey {
        case data
        case errors
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let dataContainer = try? container.nestedContainer(keyedBy: DynamicKey.self, forKey: .data)
        if let key = dataContainer?.allKeys.first {
            do {
                self.data = try dataContainer?.decode(T.self, forKey: key)
            } catch {
                // Go into one level deeper
                let innerContainer = try? dataContainer?.nestedContainer(keyedBy: DynamicKey.self, forKey: key)
                if let key = innerContainer?.allKeys.first {
                    self.data = try innerContainer?.decode(T.self, forKey: key)
                } else {
                    self.data = nil
                }
            }
        } else {
            self.data = nil
        }

        self.errors = try? container.decode([GraphQLError].self, forKey: .errors)
    }
}
