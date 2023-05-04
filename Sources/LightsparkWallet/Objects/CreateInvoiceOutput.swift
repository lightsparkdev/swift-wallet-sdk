// @generated
// This file was automatically generated and should not be edited.
// Copyright ©, 2023-present, Lightspark Group, Inc. - All Rights Reserved

public struct CreateInvoiceOutput: Decodable {
    enum CodingKeys: String, CodingKey {

        case invoice = "create_invoice_output_invoice"

    }

    public var invoice: Invoice

}

extension CreateInvoiceOutput {
    public static let fragment = """

        fragment CreateInvoiceOutputFragment on CreateInvoiceOutput {
            __typename
            create_invoice_output_invoice: invoice {
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
        }
        """
}
