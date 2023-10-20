// @generated
// This file was automatically generated and should not be edited.
// Copyright ©, 2023-present, Lightspark Group, Inc. - All Rights Reserved

/// This is an enum of the potential types of transactions that can be associated with your Lightspark Node.
public enum TransactionType: String, Decodable {
    /// Transactions initiated from a Lightspark node on Lightning Network.
    case outgoingPayment = "OUTGOING_PAYMENT"
    /// Transactions received by a Lightspark node on Lightning Network.
    case incomingPayment = "INCOMING_PAYMENT"
    /// Transactions that forwarded payments through Lightspark nodes on Lightning Network.
    case routed = "ROUTED"
    /// Transactions on the Bitcoin blockchain to withdraw funds from a Lightspark node to a Bitcoin wallet.
    case l1Withdraw = "L1_WITHDRAW"
    /// Transactions on Bitcoin blockchain to fund a Lightspark node's wallet.
    case l1Deposit = "L1_DEPOSIT"
    /// Transactions on Bitcoin blockchain to open a channel on Lightning Network funded by the local Lightspark node.
    case channelOpen = "CHANNEL_OPEN"
    /// Transactions on Bitcoin blockchain to close a channel on Lightning Network where the balances are allocated back to local and remote nodes.
    case channelClose = "CHANNEL_CLOSE"
    /// Transactions initiated from a Lightspark node on Lightning Network.
    case payment = "PAYMENT"
    /// Payment requests from a Lightspark node on Lightning Network
    case paymentRequest = "PAYMENT_REQUEST"
    /// Transactions that forwarded payments through Lightspark nodes on Lightning Network.
    case route = "ROUTE"
}
