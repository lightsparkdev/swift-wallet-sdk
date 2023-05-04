//
//  UserDefaultAuthStorage.swift
//  LightsparkWallet
//
//  Created by Zhen Lu on 4/21/23.
//  Copyright © 2023 Lightspark Group, Inc. All rights reserved.
//

import Foundation

public class UserDefaultAuthStorage: AuthStateStorage {
    static let userDefaultKey = "com.lightspark.auth.state.key"
    public init() {}

    public func getAuthStateData() -> Data? {
        UserDefaults.standard.data(forKey: Self.userDefaultKey)
    }

    public func deleteAuthStateData() {
        UserDefaults.standard.removeObject(forKey: Self.userDefaultKey)
    }

    public func storeAuthStateData(data: Data) {
        UserDefaults.standard.set(data, forKey: Self.userDefaultKey)
    }
}
