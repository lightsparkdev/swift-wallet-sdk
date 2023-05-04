// @generated
// This file was automatically generated and should not be edited.
// Copyright ©, 2023-present, Lightspark Group, Inc. - All Rights Reserved

public enum CurrencyUnit: String, Decodable {
    /// Bitcoin is the cryptocurrency native to the Bitcoin network. It is used as the native medium for value transfer for the Lightning Network.
    case bitcoin = "BITCOIN"
    /// 0.00000001 (10e-8) Bitcoin or one hundred millionth of a Bitcoin. This is the unit most commonly used in Lightning transactions.
    case satoshi = "SATOSHI"
    /// 0.001 Satoshi, or 10e-11 Bitcoin. We recommend using the Satoshi unit instead when possible.
    case millisatoshi = "MILLISATOSHI"
    /// United States Dollar.
    case usd = "USD"
    /// 0.000000001 (10e-9) Bitcoin or a billionth of a Bitcoin. We recommend using the Satoshi unit instead when possible.
    case nanobitcoin = "NANOBITCOIN"
    /// 0.000001 (10e-6) Bitcoin or a millionth of a Bitcoin. We recommend using the Satoshi unit instead when possible.
    case microbitcoin = "MICROBITCOIN"
    /// 0.001 (10e-3) Bitcoin or a thousandth of a Bitcoin. We recommend using the Satoshi unit instead when possible.
    case millibitcoin = "MILLIBITCOIN"
}
