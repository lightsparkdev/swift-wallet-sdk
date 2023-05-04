// @generated
// This file was automatically generated and should not be edited.
// Copyright ©, 2023-present, Lightspark Group, Inc. - All Rights Reserved
import Foundation

/// The transaction on the Bitcoin blockchain to withdraw funds from the Lightspark node to a Bitcoin wallet.
public struct Withdrawal: OnChainTransaction, Transaction, Entity, Decodable {
    enum CodingKeys: String, CodingKey {

        case id = "withdrawal_id"

        case createdAt = "withdrawal_created_at"

        case updatedAt = "withdrawal_updated_at"

        case status = "withdrawal_status"

        case resolvedAt = "withdrawal_resolved_at"

        case amount = "withdrawal_amount"

        case transactionHash = "withdrawal_transaction_hash"

        case fees = "withdrawal_fees"

        case blockHash = "withdrawal_block_hash"

        case blockHeight = "withdrawal_block_height"

        case destinationAddresses = "withdrawal_destination_addresses"

        case numConfirmations = "withdrawal_num_confirmations"

    }

    /// The unique identifier of this entity across all Lightspark systems. Should be treated as an opaque string.
    public var id: String

    /// The date and time when this transaction was initiated.
    public var createdAt: Date

    /// The date and time when the entity was last updated.
    public var updatedAt: Date

    /// The current status of this transaction.
    public var status: TransactionStatus

    /// The date and time when this transaction was completed or failed.
    public var resolvedAt: Date?

    /// The amount of money involved in this transaction.
    public var amount: CurrencyAmount

    /// The hash of this transaction, so it can be uniquely identified on the Lightning Network.
    public var transactionHash: String?

    /// The fees that were paid by the wallet sending the transaction to commit it to the Bitcoin blockchain.
    public var fees: CurrencyAmount?

    /// The hash of the block that included this transaction. This will be null for unconfirmed transactions.
    public var blockHash: String?

    /// The height of the block that included this transaction. This will be zero for unconfirmed transactions.
    public var blockHeight: Int64

    /// The Bitcoin blockchain addresses this transaction was sent to.
    public var destinationAddresses: [String]

    /// The number of blockchain confirmations for this transaction in real time.
    public var numConfirmations: Int64?

}

extension Withdrawal {
    public static let fragment = """

        fragment WithdrawalFragment on Withdrawal {
            __typename
            withdrawal_id: id
            withdrawal_created_at: created_at
            withdrawal_updated_at: updated_at
            withdrawal_status: status
            withdrawal_resolved_at: resolved_at
            withdrawal_amount: amount {
                __typename
                currency_amount_original_value: original_value
                currency_amount_original_unit: original_unit
                currency_amount_preferred_currency_unit: preferred_currency_unit
                currency_amount_preferred_currency_value_rounded: preferred_currency_value_rounded
                currency_amount_preferred_currency_value_approx: preferred_currency_value_approx
            }
            withdrawal_transaction_hash: transaction_hash
            withdrawal_fees: fees {
                __typename
                currency_amount_original_value: original_value
                currency_amount_original_unit: original_unit
                currency_amount_preferred_currency_unit: preferred_currency_unit
                currency_amount_preferred_currency_value_rounded: preferred_currency_value_rounded
                currency_amount_preferred_currency_value_approx: preferred_currency_value_approx
            }
            withdrawal_block_hash: block_hash
            withdrawal_block_height: block_height
            withdrawal_destination_addresses: destination_addresses
            withdrawal_num_confirmations: num_confirmations
        }
        """
}
