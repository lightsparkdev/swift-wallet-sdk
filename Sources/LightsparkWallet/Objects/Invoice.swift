// @generated
// This file was automatically generated and should not be edited.
// Copyright ©, 2023-present, Lightspark Group, Inc. - All Rights Reserved
import Foundation

/// This object represents a BOLT #11 invoice (https://github.com/lightning/bolts/blob/master/11-payment-encoding.md) initiated by a Lightspark Node.
public struct Invoice: PaymentRequest, Entity, Decodable {
    enum CodingKeys: String, CodingKey {

        case id = "invoice_id"

        case createdAt = "invoice_created_at"

        case updatedAt = "invoice_updated_at"

        case data = "invoice_data"

        case status = "invoice_status"

        case amountPaid = "invoice_amount_paid"

    }

    /// The unique identifier of this entity across all Lightspark systems. Should be treated as an opaque string.
    public var id: String

    /// The date and time when the entity was first created.
    public var createdAt: Date

    /// The date and time when the entity was last updated.
    public var updatedAt: Date

    /// The details of the invoice.
    public var data: InvoiceData

    /// The status of the payment request.
    public var status: PaymentRequestStatus

    /// The total amount that has been paid to this invoice.
    public var amountPaid: CurrencyAmount?

}

extension Invoice {
    public static let fragment = """

        fragment InvoiceFragment on Invoice {
            __typename
            invoice_id: id
            invoice_created_at: created_at
            invoice_updated_at: updated_at
            invoice_data: data {
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
            invoice_status: status
            invoice_amount_paid: amount_paid {
                __typename
                currency_amount_original_value: original_value
                currency_amount_original_unit: original_unit
                currency_amount_preferred_currency_unit: preferred_currency_unit
                currency_amount_preferred_currency_value_rounded: preferred_currency_value_rounded
                currency_amount_preferred_currency_value_approx: preferred_currency_value_approx
            }
        }
        """
}
