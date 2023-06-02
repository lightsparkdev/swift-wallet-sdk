//
//  RemoteSigningTests.swift
//  LightsparkWalletTests
//
//  Created by Zhen Lu on 4/20/23.
//  Copyright © 2023 Lightspark Group, Inc. All rights reserved.
//

import LightsparkWallet
import BitcoinDevKit
import XCTest

final class RemoteSigningTests: XCTestCase {
    static let testVectors = [
        "000102030405060708090a0b0c0d0e0f": [
            "m": "xprv9s21ZrQH143K3QTDL4LXw2F7HEK3wJUD2nW2nRk4stbPy6cq3jPPqjiChkVvvNKmPGJxWUtg6LnF5kejMRNNU3TGtRBeJgk33yuGBxrMPHi",
            "m/0'": "xprv9uHRZZhk6KAJC1avXpDAp4MDc3sQKNxDiPvvkX8Br5ngLNv1TxvUxt4cV1rGL5hj6KCesnDYUhd7oWgT11eZG7XnxHrnYeSvkzY7d2bhkJ7",
            "m/0'/1":
                "xprv9wTYmMFdV23N2TdNG573QoEsfRrWKQgWeibmLntzniatZvR9BmLnvSxqu53Kw1UmYPxLgboyZQaXwTCg8MSY3H2EU4pWcQDnRnrVA1xe8fs",
            "m/0'/1/2'":
                "xprv9z4pot5VBttmtdRTWfWQmoH1taj2axGVzFqSb8C9xaxKymcFzXBDptWmT7FwuEzG3ryjH4ktypQSAewRiNMjANTtpgP4mLTj34bhnZX7UiM",
            "m/0'/1/2'/2":
                "xprvA2JDeKCSNNZky6uBCviVfJSKyQ1mDYahRjijr5idH2WwLsEd4Hsb2Tyh8RfQMuPh7f7RtyzTtdrbdqqsunu5Mm3wDvUAKRHSC34sJ7in334",
            "m/0'/1/2'/2/1000000000":
                "xprvA41z7zogVVwxVSgdKUHDy1SKmdb533PjDz7J6N6mV6uS3ze1ai8FHa8kmHScGpWmj4WggLyQjgPie1rFSruoUihUZREPSL39UNdE3BBDu76",
        ],
        "fffcf9f6f3f0edeae7e4e1dedbd8d5d2cfccc9c6c3c0bdbab7b4b1aeaba8a5a29f9c999693908d8a8784817e7b7875726f6c696663605d5a5754514e4b484542": [
            "m": "xprv9s21ZrQH143K31xYSDQpPDxsXRTUcvj2iNHm5NUtrGiGG5e2DtALGdso3pGz6ssrdK4PFmM8NSpSBHNqPqm55Qn3LqFtT2emdEXVYsCzC2U"
        ],
        "4b381541583be4423346c643850da4b320e46a87ae3d2a4e6da11eba819cd4acba45d239319ac14f863b8d5ab5a0d0c64d2e8a1e7d1457df2e5a3c51c73235be": [
            "m": "xprv9s21ZrQH143K25QhxbucbDDuQ4naNntJRi4KUfWT7xo4EKsHt2QJDu7KXp1A3u7Bi1j8ph3EGsZ9Xvz9dGuVrtHHs7pXeTzjuxBrCmmhgC6"
        ],
    ]


    func testKeyGeneration() throws {
        let signer = Signer()

        for (key, value) in Self.testVectors {
            let seed = key
            let masterPrivateKey = signer.generateMasterSecret(fromSeed: Data(seed.hexaBytes))
            XCTAssertEqual(masterPrivateKey.asString(), value["m"])
        }
    }

    func testKeyDerivation() throws {
        let signer = Signer()

        for (key, value) in Self.testVectors {
            let seed = key
            let masterPrivateKey = signer.generateMasterSecret(fromSeed: Data(seed.hexaBytes))
            for (derivationPath, result) in value {
                let keyToTest = try signer.deriveAndTweakKey(masterSecret: masterPrivateKey, derivationPath: derivationPath)

                let keyToVerify = try DescriptorSecretKey.fromString(secretKey: result)

                XCTAssertEqual(keyToTest.dataRepresentation.bytes, keyToVerify.secretBytes())
            }
        }
    }
}
