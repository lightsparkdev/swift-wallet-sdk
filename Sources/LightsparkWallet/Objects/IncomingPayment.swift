// @generated
// This file was automatically generated and should not be edited.
// Copyright ©, 2023-present, Lightspark Group, Inc. - All Rights Reserved
import Foundation

/// This object represents any payment sent to a Lightspark node on the Lightning Network. You can retrieve this object to receive payment related information about a specific payment received by a Lightspark node.
public struct IncomingPayment: LightningTransaction, Transaction, Entity, Decodable {
    enum CodingKeys: String, CodingKey {

        case id = "incoming_payment_id"

        case createdAt = "incoming_payment_created_at"

        case updatedAt = "incoming_payment_updated_at"

        case status = "incoming_payment_status"

        case resolvedAt = "incoming_payment_resolved_at"

        case amount = "incoming_payment_amount"

        case transactionHash = "incoming_payment_transaction_hash"

        case paymentRequest = "incoming_payment_payment_request"

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

    /// The optional payment request for this incoming payment, which will be null if the payment is sent through keysend.
    public var paymentRequest: EntityWrapper?

}

extension IncomingPayment {
    public static let fragment = """

        fragment IncomingPaymentFragment on IncomingPayment {
            __typename
            incoming_payment_id: id
            incoming_payment_created_at: created_at
            incoming_payment_updated_at: updated_at
            incoming_payment_status: status
            incoming_payment_resolved_at: resolved_at
            incoming_payment_amount: amount {
                __typename
                currency_amount_original_value: original_value
                currency_amount_original_unit: original_unit
                currency_amount_preferred_currency_unit: preferred_currency_unit
                currency_amount_preferred_currency_value_rounded: preferred_currency_value_rounded
                currency_amount_preferred_currency_value_approx: preferred_currency_value_approx
            }
            incoming_payment_transaction_hash: transaction_hash
            incoming_payment_payment_request: payment_request {
                id
            }
        }
        """
}
