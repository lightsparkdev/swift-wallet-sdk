// @generated
// This file was automatically generated and should not be edited.
// Copyright ©, 2023-present, Lightspark Group, Inc. - All Rights Reserved
import Foundation

/// This is an object representing a transaction which opens a channel on the Lightning Network. This object occurs only for channels funded by the local Lightspark node.
public struct ChannelOpeningTransaction: OnChainTransaction, Transaction, Entity, Decodable {
    enum CodingKeys: String, CodingKey {

        case id = "channel_opening_transaction_id"

        case createdAt = "channel_opening_transaction_created_at"

        case updatedAt = "channel_opening_transaction_updated_at"

        case status = "channel_opening_transaction_status"

        case resolvedAt = "channel_opening_transaction_resolved_at"

        case amount = "channel_opening_transaction_amount"

        case transactionHash = "channel_opening_transaction_transaction_hash"

        case fees = "channel_opening_transaction_fees"

        case blockHash = "channel_opening_transaction_block_hash"

        case blockHeight = "channel_opening_transaction_block_height"

        case destinationAddresses = "channel_opening_transaction_destination_addresses"

        case numConfirmations = "channel_opening_transaction_num_confirmations"

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

extension ChannelOpeningTransaction {
    public static let fragment = """

        fragment ChannelOpeningTransactionFragment on ChannelOpeningTransaction {
            __typename
            channel_opening_transaction_id: id
            channel_opening_transaction_created_at: created_at
            channel_opening_transaction_updated_at: updated_at
            channel_opening_transaction_status: status
            channel_opening_transaction_resolved_at: resolved_at
            channel_opening_transaction_amount: amount {
                __typename
                currency_amount_original_value: original_value
                currency_amount_original_unit: original_unit
                currency_amount_preferred_currency_unit: preferred_currency_unit
                currency_amount_preferred_currency_value_rounded: preferred_currency_value_rounded
                currency_amount_preferred_currency_value_approx: preferred_currency_value_approx
            }
            channel_opening_transaction_transaction_hash: transaction_hash
            channel_opening_transaction_fees: fees {
                __typename
                currency_amount_original_value: original_value
                currency_amount_original_unit: original_unit
                currency_amount_preferred_currency_unit: preferred_currency_unit
                currency_amount_preferred_currency_value_rounded: preferred_currency_value_rounded
                currency_amount_preferred_currency_value_approx: preferred_currency_value_approx
            }
            channel_opening_transaction_block_hash: block_hash
            channel_opening_transaction_block_height: block_height
            channel_opening_transaction_destination_addresses: destination_addresses
            channel_opening_transaction_num_confirmations: num_confirmations
        }
        """
}
