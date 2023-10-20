// @generated
// This file was automatically generated and should not be edited.
// Copyright ©, 2023-present, Lightspark Group, Inc. - All Rights Reserved
import Foundation

/// This object represents the data associated with a BOLT #11 invoice. You can retrieve this object to receive the relevant data associated with a specific invoice.
public struct InvoiceData: PaymentRequestData, Decodable {
    enum CodingKeys: String, CodingKey {

        case encodedPaymentRequest = "invoice_data_encoded_payment_request"

        case bitcoinNetwork = "invoice_data_bitcoin_network"

        case paymentHash = "invoice_data_payment_hash"

        case amount = "invoice_data_amount"

        case createdAt = "invoice_data_created_at"

        case expiresAt = "invoice_data_expires_at"

        case memo = "invoice_data_memo"

        case destination = "invoice_data_destination"

    }

    public var encodedPaymentRequest: String

    public var bitcoinNetwork: BitcoinNetwork

    /// The payment hash of this invoice.
    public var paymentHash: String

    /// The requested amount in this invoice. If it is equal to 0, the sender should choose the amount to send.
    public var amount: CurrencyAmount

    /// The date and time when this invoice was created.
    public var createdAt: Date

    /// The date and time when this invoice will expire.
    public var expiresAt: Date

    /// A short, UTF-8 encoded, description of the purpose of this invoice.
    public var memo: String?

    /// The lightning node that will be paid when fulfilling this invoice.
    public var destination: GraphNode

}

extension InvoiceData {
    public static let fragment = """

        fragment InvoiceDataFragment on InvoiceData {
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
        """
}
