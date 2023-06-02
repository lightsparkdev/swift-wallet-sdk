//
//  RemoteSigning.swift
//  LightsparkWallet
//
//  Created by Zhen Lu on 6/1/23.
//  Copyright © 2023 Lightspark Group, Inc. All rights reserved.
//


import Foundation

import secp256k1
import BitcoinDevKit
import CommonCrypto
import Base58Swift

public extension StringProtocol {
    var hexaBytes: [UInt8] { .init(hexa) }
    private var hexa: UnfoldSequence<UInt8, Index> {
        sequence(state: startIndex) { startIndex in
            guard startIndex < self.endIndex else { return nil }
            let endIndex = self.index(startIndex, offsetBy: 2, limitedBy: self.endIndex) ?? self.endIndex
            defer { startIndex = endIndex }
            return UInt8(self[startIndex..<endIndex], radix: 16)
        }
    }
}

public extension DataProtocol {
    func hexEncodedString() -> String {
        return self.map { String(format: "%02hhx", $0) }.joined()
    }
}

public struct MasterSecret {
    var secretBytes: [UInt8]
    var chaincode: [UInt8]

    public func asString() -> String {
        let versionBytes: [UInt8] = [0x04, 0x88, 0xAD, 0xE4]
        let depth: UInt8 = 0x00
        let parentFingerprint: [UInt8] = [0x00, 0x00, 0x00, 0x00]
        let childNumber: [UInt8] = [0x00, 0x00, 0x00, 0x00]
        let privateKeyPrefix: UInt8 = 0x00

        var data = Data()
        data.append(contentsOf: versionBytes)
        data.append(depth)
        data.append(contentsOf: parentFingerprint)
        data.append(contentsOf: childNumber)
        data.append(contentsOf: chaincode)
        data.append(privateKeyPrefix)
        data.append(contentsOf: secretBytes)
        return Base58.base58CheckEncode(data.bytes)
    }
}

public class Signer {
    public init() {}

    public func generateMasterSecret(fromSeed seed: Data) -> MasterSecret {
        let key = "Bitcoin seed".data(using: .utf8)!
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA512_DIGEST_LENGTH))
        seed.withUnsafeBytes { seedBytes in
            key.withUnsafeBytes { keyBytes in
                CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA512), keyBytes.baseAddress, key.count, seedBytes.baseAddress, seed.count, &digest)
            }
        }
        return MasterSecret(secretBytes: Array(digest.prefix(32)), chaincode: Array(digest.suffix(32)))
    }

    public func ecdh(privateKey: ContiguousBytes, otherPublicKey: ContiguousBytes) throws -> ContiguousBytes {
        let privateKey = try secp256k1.KeyAgreement.PrivateKey(dataRepresentation: privateKey)
        // TODO: handle public key compressed vs uncompressed
        let publicKey = try secp256k1.KeyAgreement.PublicKey(dataRepresentation: otherPublicKey)
        return try privateKey.sharedSecretFromKeyAgreement(with: publicKey)
    }

    public func sign(
        message: Data,
        masterSecret: MasterSecret,
        derivationPath: String? = nil,
        multiTweak: [UInt8]? = nil,
        addTweak: [UInt8]? = nil
    ) throws -> ContiguousBytes {
        let privateKey = try deriveAndTweakKey(
            masterSecret: masterSecret,
            derivationPath: derivationPath,
            multiTweak: multiTweak,
            addTweak: addTweak
        )
        return try privateKey.signature(for: message)
    }

    public func deriveAndTweakKey(
        masterSecret: MasterSecret,
        derivationPath: String? = nil,
        multiTweak: [UInt8]? = nil,
        addTweak: [UInt8]? = nil
    ) throws -> secp256k1.Signing.PrivateKey {
        let privateKeyString = masterSecret.asString()
        let privateKey = try DescriptorSecretKey.fromString(secretKey: privateKeyString)
        let derivedPrivateKey: DescriptorSecretKey
        if let derivationPath = derivationPath {
            derivedPrivateKey = try privateKey.derive(path: DerivationPath(path: derivationPath))
        } else {
            derivedPrivateKey = privateKey
        }

        let privateKeyBytes = derivedPrivateKey.secretBytes() as ContiguousBytes

        var tweakedKey = try secp256k1.Signing.PrivateKey(dataRepresentation: privateKeyBytes)
        if let multiTweak = multiTweak,
           let addTweak = addTweak {
            tweakedKey = try tweakedKey.multiply(multiTweak)
            tweakedKey = try tweakedKey.add(addTweak)
        }
        return tweakedKey
    }
}
