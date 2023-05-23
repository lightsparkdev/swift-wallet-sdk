// @generated
// This file was automatically generated and should not be edited.
// Copyright ©, 2023-present, Lightspark Group, Inc. - All Rights Reserved
import Foundation

/// A transaction that was sent from a Lightspark node on the Lightning Network.
public struct OutgoingPayment: LightningTransaction, Transaction, Entity, Decodable {
    enum CodingKeys: String, CodingKey {

        case id = "outgoing_payment_id"

        case createdAt = "outgoing_payment_created_at"

        case updatedAt = "outgoing_payment_updated_at"

        case status = "outgoing_payment_status"

        case resolvedAt = "outgoing_payment_resolved_at"

        case amount = "outgoing_payment_amount"

        case transactionHash = "outgoing_payment_transaction_hash"

        case fees = "outgoing_payment_fees"

        case paymentRequestData = "outgoing_payment_payment_request_data"

        case failureReason = "outgoing_payment_failure_reason"

        case failureMessage = "outgoing_payment_failure_message"

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

    /// The fees paid by the sender node to send the payment.
    public var fees: CurrencyAmount?

    /// The data of the payment request that was paid by this transaction, if known.
    public var paymentRequestData: PaymentRequestDataEnum?

    /// If applicable, the reason why the payment failed.
    public var failureReason: PaymentFailureReason?

    /// If applicable, user-facing error message describing why the payment failed.
    public var failureMessage: RichText?

}

extension OutgoingPayment {
    public static let fragment = """

        fragment OutgoingPaymentFragment on OutgoingPayment {
            __typename
            outgoing_payment_id: id
            outgoing_payment_created_at: created_at
            outgoing_payment_updated_at: updated_at
            outgoing_payment_status: status
            outgoing_payment_resolved_at: resolved_at
            outgoing_payment_amount: amount {
                __typename
                currency_amount_original_value: original_value
                currency_amount_original_unit: original_unit
                currency_amount_preferred_currency_unit: preferred_currency_unit
                currency_amount_preferred_currency_value_rounded: preferred_currency_value_rounded
                currency_amount_preferred_currency_value_approx: preferred_currency_value_approx
            }
            outgoing_payment_transaction_hash: transaction_hash
            outgoing_payment_fees: fees {
                __typename
                currency_amount_original_value: original_value
                currency_amount_original_unit: original_unit
                currency_amount_preferred_currency_unit: preferred_currency_unit
                currency_amount_preferred_currency_value_rounded: preferred_currency_value_rounded
                currency_amount_preferred_currency_value_approx: preferred_currency_value_approx
            }
            outgoing_payment_payment_request_data: payment_request_data {
                __typename
                ... on InvoiceData {
                    __typename
                    invoice_data_encoded_payment_request: encoded_payment_request
                    invoice_data_bitcoin_network: bitcoin_network
                    invoice_data_payment_hash: payment_hash
                    invoice_data_amount: amount {
                        __typename
                        currency_amount_original_value: original_value
                        currency_amount_original_unit: original_unit
                        currency_amount_preferred_currency_unit: preferred_currency_unit
                        currency_amount_preferred_currency_value_rounded: preferred_currency_value_rounded
                        currency_amount_preferred_currency_value_approx: preferred_currency_value_approx
                    }
                    invoice_data_created_at: created_at
                    invoice_data_expires_at: expires_at
                    invoice_data_memo: memo
                    invoice_data_destination: destination {
                        __typename
                        graph_node_id: id
                        graph_node_created_at: created_at
                        graph_node_updated_at: updated_at
                        graph_node_alias: alias
                        graph_node_bitcoin_network: bitcoin_network
                        graph_node_color: color
                        graph_node_conductivity: conductivity
                        graph_node_display_name: display_name
                        graph_node_public_key: public_key
                    }
                }
            }
            outgoing_payment_failure_reason: failure_reason
            outgoing_payment_failure_message: failure_message {
                __typename
                rich_text_text: text
            }
        }
        """
}
