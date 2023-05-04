// @generated
// This file was automatically generated and should not be edited.
// Copyright ©, 2023-present, Lightspark Group, Inc. - All Rights Reserved

public protocol OnChainTransaction: Transaction, Entity, Decodable {

    /// The fees that were paid by the wallet sending the transaction to commit it to the Bitcoin blockchain.
    var fees: CurrencyAmount? { get }

    /// The hash of the block that included this transaction. This will be null for unconfirmed transactions.
    var blockHash: String? { get }

    /// The height of the block that included this transaction. This will be zero for unconfirmed transactions.
    var blockHeight: Int64 { get }

    /// The Bitcoin blockchain addresses this transaction was sent to.
    var destinationAddresses: [String] { get }

    /// The number of blockchain confirmations for this transaction in real time.
    var numConfirmations: Int64? { get }

}

public enum OnChainTransactionEnum {
    case deposit(Deposit)
    case withdrawal(Withdrawal)

}

extension OnChainTransactionEnum: Decodable {
    private enum CodingKeys: String, CodingKey {
        case __typename
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let typename = try container.decode(String.self, forKey: .__typename)
        switch typename {
        case "Deposit":
            let deposit = try Deposit(from: decoder)
            self = .deposit(deposit)
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
