// @generated
// This file was automatically generated and should not be edited.
// Copyright ©, 2023-present, Lightspark Group, Inc. - All Rights Reserved

public struct SendPaymentOutput: Decodable {
    enum CodingKeys: String, CodingKey {

        case payment = "send_payment_output_payment"

    }

    /// The payment that has been sent.
    public var payment: OutgoingPayment

}

extension SendPaymentOutput {
    public static let fragment = """

        fragment SendPaymentOutputFragment on SendPaymentOutput {
            __typename
            send_payment_output_payment: payment {
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
                outgoing_payment_payment_preimage: payment_preimage
            }
        }
        """
}
