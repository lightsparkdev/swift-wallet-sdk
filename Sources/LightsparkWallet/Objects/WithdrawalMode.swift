// @generated
// This file was automatically generated and should not be edited.
// Copyright ©, 2023-present, Lightspark Group, Inc. - All Rights Reserved

/// This is an enum of the potential modes that your Bitcoin withdrawal can take.
public enum WithdrawalMode: String, Decodable {

    case walletOnly = "WALLET_ONLY"

    case walletThenChannels = "WALLET_THEN_CHANNELS"
}
