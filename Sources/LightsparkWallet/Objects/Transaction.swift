// @generated
// This file was automatically generated and should not be edited.
// Copyright ©, 2023-present, Lightspark Group, Inc. - All Rights Reserved
import Foundation

public protocol Transaction: Entity, Decodable {

    /// The current status of this transaction.
    var status: TransactionStatus { get }

    /// The date and time when this transaction was completed or failed.
    var resolvedAt: Date? { get }

    /// The amount of money involved in this transaction.
    var amount: CurrencyAmount { get }

    /// The hash of this transaction, so it can be uniquely identified on the Lightning Network.
    var transactionHash: String? { get }

}

public enum TransactionEnum {
    case channelClosingTransaction(ChannelClosingTransaction)
    case channelOpeningTransaction(ChannelOpeningTransaction)
    case deposit(Deposit)
    case incomingPayment(IncomingPayment)
    case outgoingPayment(OutgoingPayment)
    case withdrawal(Withdrawal)

}

extension TransactionEnum: Decodable {
    private enum CodingKeys: String, CodingKey {
        case __typename
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let typename = try container.decode(String.self, forKey: .__typename)
        switch typename {
        case "ChannelClosingTransaction":
            let channelClosingTransaction = try ChannelClosingTransaction(from: decoder)
            self = .channelClosingTransaction(channelClosingTransaction)
        case "ChannelOpeningTransaction":
            let channelOpeningTransaction = try ChannelOpeningTransaction(from: decoder)
            self = .channelOpeningTransaction(channelOpeningTransaction)
        case "Deposit":
            let deposit = try Deposit(from: decoder)
            self = .deposit(deposit)
        case "IncomingPayment":
            let incomingPayment = try IncomingPayment(from: decoder)
            self = .incomingPayment(incomingPayment)
        case "OutgoingPayment":
            let outgoingPayment = try OutgoingPayment(from: decoder)
            self = .outgoingPayment(outgoingPayment)
        case "Withdrawal":
            let withdrawal = try Withdrawal(from: decoder)
            self = .withdrawal(withdrawal)

        default:
            throw DecodingError.dataCorruptedError(
                forKey: .__typename,
                in: container,
                debugDescription: "Invalid typename"
            )
        }
    }
}
