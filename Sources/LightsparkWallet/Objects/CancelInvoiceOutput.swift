// @generated
// This file was automatically generated and should not be edited.
// Copyright ©, 2023-present, Lightspark Group, Inc. - All Rights Reserved

public struct CancelInvoiceOutput: Decodable {
    enum CodingKeys: String, CodingKey {

        case invoice = "cancel_invoice_output_invoice"

    }

    public var invoice: Invoice

}

extension CancelInvoiceOutput {
    public static let fragment = """

        fragment CancelInvoiceOutputFragment on CancelInvoiceOutput {
            __typename
            cancel_invoice_output_invoice: invoice {
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
        }
        """
}
