// @generated
// This file was automatically generated and should not be edited.
// Copyright ©, 2023-present, Lightspark Group, Inc. - All Rights Reserved
import Foundation

/// This object represents the BOLT #11 invoice protocol for Lightning Payments. See https://github.com/lightning/bolts/blob/master/11-payment-encoding.md.
public struct InvoiceData: PaymentRequestData, Decodable {
    enum CodingKeys: String, CodingKey {

        case encodedPaymentRequest = "invoice_data_encoded_payment_request"

        case bitcoinNetwork = "invoice_data_bitcoin_network"

        case paymentHash = "invoice_data_payment_hash"

        case amount = "invoice_data_amount"

        case createdAt = "invoice_data_created_at"

        case expiresAt = "invoice_data_expires_at"

        case memo = "invoice_data_memo"

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
        }
        """
}
