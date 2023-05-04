//
//  Keys.swift
//  LightsparkWallet
//
//  Created by Zhen Lu on 4/20/23.
//  Copyright © 2023 Lightspark Group, Inc. All rights reserved.
//

import Foundation

public enum Keys {}

extension Keys {
    public enum KeysError: Error {
        case tagParsingError
        case generateKeyFailure
        case publicKeyNotCopiableError
        case keyNotFoundError
    }
}

extension Keys {
    public static func getRSAPrivateKey(tag: String) throws -> SecKey {
        let query: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: tag,
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
            kSecReturnRef as String: true,
        ]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess else { throw KeysError.keyNotFoundError }
        let key = item as! SecKey
        return key
    }

    public static func generateNewRSASigningKeyPair(
        tag: String,
        permanent: Bool = false
    ) throws -> (SecKey, SecKey) {
        guard let tag = tag.data(using: .utf8) else {
            throw KeysError.tagParsingError
        }
        let attributes: [String: Any] = [
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
            kSecAttrKeySizeInBits as String: 2048,
            kSecPrivateKeyAttrs as String: [
                kSecAttrIsPermanent as String: permanent,
                kSecAttrApplicationTag as String: tag,
            ] as [String: Any],
        ]

        var error: Unmanaged<CFError>?
        guard let privateKey = SecKeyCreateRandomKey(attributes as CFDictionary, &error) else {
            if let error = error {
                throw error.takeRetainedValue() as Error
            } else {
                throw KeysError.generateKeyFailure
            }
        }

        guard let publicKey = SecKeyCopyPublicKey(privateKey) else {
            throw KeysError.publicKeyNotCopiableError
        }
        return (privateKey, publicKey)
    }

    public static func base64StringRepresentationForPublicKey(publicKey: SecKey) throws -> String {
        var error: Unmanaged<CFError>?
        guard let keyData = SecKeyCopyExternalRepresentation(publicKey, &error) as? Data else {
            if let error = error {
                throw error.takeRetainedValue() as Error
            } else {
                throw KeysError.publicKeyNotCopiableError
            }
        }
        return keyData.base64EncodedString()
    }
}
