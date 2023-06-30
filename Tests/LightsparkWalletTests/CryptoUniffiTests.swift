//
//  CryptoUniffiTests.swift
//  LightsparkWalletTests
//
//  Created by Zhen Lu on 6/30/23.
//  Copyright © 2023 Lightspark Group, Inc. All rights reserved.
//

import LightsparkWallet
import XCTest


final class CryptoUniffiTests: XCTestCase {
    func testBip39() throws {
        let mnemonic = Mnemonic()
        let words = mnemonic.asString().components(separatedBy: " ")
        XCTAssertEqual(words.count, 24)

        let newMnemonic = try Mnemonic.fromPhrase(phrase: mnemonic.asString())
        XCTAssertEqual(newMnemonic.asString(), mnemonic.asString())

        let seed = Seed.fromMnemonic(mnemonic: mnemonic)
        let newSeed = Seed.fromMnemonic(mnemonic: newMnemonic)

        XCTAssertEqual(seed.asBytes(), newSeed.asBytes())
    }
}
