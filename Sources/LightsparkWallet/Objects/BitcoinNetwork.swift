// @generated
// This file was automatically generated and should not be edited.
// Copyright ©, 2023-present, Lightspark Group, Inc. - All Rights Reserved

public enum BitcoinNetwork: String, Decodable {
    /// The production version of the Bitcoin Blockchain.
    case mainnet = "MAINNET"
    /// A test version of the Bitcoin Blockchain, maintained by Lightspark.
    case regtest = "REGTEST"
    /// A test version of the Bitcoin Blockchain, maintained by a centralized organization. Not in use at Lightspark.
    case signet = "SIGNET"
    /// A test version of the Bitcoin Blockchain, publically available.
    case testnet = "TESTNET"
}
