//
//  CryptoTests.swift
//  LightsparkWalletTests
//
//  Created by Zhen Lu on 4/20/23.
//  Copyright © 2023 Lightspark Group, Inc. All rights reserved.
//

import LightsparkWallet
import XCTest

final class CryptoTests: XCTestCase {
    func testGenerateKeys() throws {
        let algorithm: SecKeyAlgorithm = .rsaSignatureMessagePSSSHA256
        let (privateKey, publicKey) = try Keys.generateNewRSASigningKeyPair(tag: "signing key")

        XCTAssertTrue(SecKeyIsAlgorithmSupported(privateKey, .sign, algorithm))
        let document = "document to sign".data(using: .utf8)!
        var error: Unmanaged<CFError>?
        let signature = SecKeyCreateSignature(privateKey, algorithm, document as CFData, &error) as? Data
        XCTAssertNotNil(signature)

        let result = SecKeyVerifySignature(publicKey, algorithm, document as CFData, signature! as CFData, &error)
        XCTAssertTrue(result)
    }

    func testSigningPayload() throws {
        let (privateKey, publicKey) = try Keys.generateNewRSASigningKeyPair(tag: "signing key")
        let document = "document to sign".data(using: .utf8)!

        let signatureJSONString = try Signing.signPayload(key: privateKey, payload: document)
        let jsonData = signatureJSONString.data(using: .utf8)!
        let decodedDictionary: [String: Any] = try JSONSerialization.jsonObject(with: jsonData) as! [String: Any]

        XCTAssertEqual(decodedDictionary["v"] as! Int, 1)

        let signatureBase64 = decodedDictionary["signature"] as! String
        let signature = Data(base64Encoded: signatureBase64)

        var error: Unmanaged<CFError>?
        let result = SecKeyVerifySignature(
            publicKey,
            .rsaSignatureMessagePSSSHA256,
            document as CFData,
            signature! as CFData,
            &error
        )
        XCTAssertTrue(result)
    }
}
