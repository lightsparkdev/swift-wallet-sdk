//
//  KeychainStorage.swift
//  LightsparkWallet
//
//  Created by Zhen Lu on 10/18/23.
//  Copyright © 2023 Lightspark Group, Inc. All rights reserved.
//


import Foundation

public class KeychainStorage: AuthStateStorage {
    static let serviceName = "com.lightspark"
    static let key = "com.lightspark.auth.state.key"

    public init() {}

    public func storeAuthStateData(data: Data) -> Bool {
        let query =
        [
            kSecValueData: data,
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: Self.serviceName,
            kSecAttrAccount: Self.key,
        ] as [CFString: Any] as CFDictionary

        let status = SecItemAdd(query, nil)

        if status == errSecSuccess {
            return true
        } else if status == errSecDuplicateItem {
            return update(data, key: Self.key)
        } else {
            return false
        }
    }

    public func getAuthStateData() -> Data? {
        let query =
        [
            kSecAttrService: Self.serviceName,
            kSecAttrAccount: Self.key,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true,
        ] as [CFString: Any] as CFDictionary

        var result: AnyObject?
        SecItemCopyMatching(query, &result)

        return result as? Data
    }

    public func deleteAuthStateData() {
        let query =
        [
            kSecAttrService: Self.serviceName,
            kSecAttrAccount: Self.key,
            kSecClass: kSecClassGenericPassword,
        ] as [CFString: Any] as CFDictionary

        SecItemDelete(query)
    }

    func update(_ data: Data, key: String) -> Bool {
        let query =
        [
            kSecAttrService: Self.serviceName,
            kSecAttrAccount: key,
            kSecClass: kSecClassGenericPassword,
        ] as [CFString: Any] as CFDictionary

        let attributesToUpdate = [kSecValueData: data] as CFDictionary
        let status = SecItemUpdate(query, attributesToUpdate)
        return status == errSecSuccess
    }
}
