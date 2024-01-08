// @generated
// This file was automatically generated and should not be edited.
// Copyright ©, 2023-present, Lightspark Group, Inc. - All Rights Reserved

public struct WithdrawalFeeEstimateOutput: Decodable {
    enum CodingKeys: String, CodingKey {

        case feeEstimate = "withdrawal_fee_estimate_output_fee_estimate"

    }

    /// The estimated fee for the withdrawal.
    public var feeEstimate: CurrencyAmount

}

extension WithdrawalFeeEstimateOutput {
    public static let fragment = """

        fragment WithdrawalFeeEstimateOutputFragment on WithdrawalFeeEstimateOutput {
            __typename
            withdrawal_fee_estimate_output_fee_estimate: fee_estimate {
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
