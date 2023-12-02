// @generated
// This file was automatically generated and should not be edited.
// Copyright ©, 2023-present, Lightspark Group, Inc. - All Rights Reserved

public struct RequestWithdrawalOutput: Decodable {
    enum CodingKeys: String, CodingKey {

        case request = "request_withdrawal_output_request"

    }

    /// The request that is created for this withdrawal.
    public var request: WithdrawalRequest

}

extension RequestWithdrawalOutput {
    public static let fragment = """

        fragment RequestWithdrawalOutputFragment on RequestWithdrawalOutput {
            __typename
            request_withdrawal_output_request: request {
                __typename
                withdrawal_request_id: id
                withdrawal_request_created_at: created_at
                withdrawal_request_updated_at: updated_at
                withdrawal_request_requested_amount: requested_amount {
                    __typename
                    currency_amount_original_value: original_value
                    currency_amount_original_unit: original_unit
                    currency_amount_preferred_currency_unit: preferred_currency_unit
                    currency_amount_preferred_currency_value_rounded: preferred_currency_value_rounded
                    currency_amount_preferred_currency_value_approx: preferred_currency_value_approx
                }
                withdrawal_request_amount: amount {
                    __typename
                    currency_amount_original_value: original_value
                    currency_amount_original_unit: original_unit
                    currency_amount_preferred_currency_unit: preferred_currency_unit
                    currency_amount_preferred_currency_value_rounded: preferred_currency_value_rounded
                    currency_amount_preferred_currency_value_approx: preferred_currency_value_approx
                }
                withdrawal_request_estimated_amount: estimated_amount {
                    __typename
                    currency_amount_original_value: original_value
                    currency_amount_original_unit: original_unit
                    currency_amount_preferred_currency_unit: preferred_currency_unit
                    currency_amount_preferred_currency_value_rounded: preferred_currency_value_rounded
                    currency_amount_preferred_currency_value_approx: preferred_currency_value_approx
                }
                withdrawal_request_amount_withdrawn: amount_withdrawn {
                    __typename
                    currency_amount_original_value: original_value
                    currency_amount_original_unit: original_unit
                    currency_amount_preferred_currency_unit: preferred_currency_unit
                    currency_amount_preferred_currency_value_rounded: preferred_currency_value_rounded
                    currency_amount_preferred_currency_value_approx: preferred_currency_value_approx
                }
                withdrawal_request_bitcoin_address: bitcoin_address
                withdrawal_request_status: status
                withdrawal_request_completed_at: completed_at
                withdrawal_request_withdrawal: withdrawal {
                    id
                }
            }
        }
        """
}
