// @generated
// This file was automatically generated and should not be edited.
// Copyright ©, 2023-present, Lightspark Group, Inc. - All Rights Reserved

public struct FeeEstimate: Decodable {
    enum CodingKeys: String, CodingKey {

        case feeFast = "fee_estimate_fee_fast"

        case feeMin = "fee_estimate_fee_min"

    }

    public var feeFast: CurrencyAmount

    public var feeMin: CurrencyAmount

}

extension FeeEstimate {
    public static let fragment = """

        fragment FeeEstimateFragment on FeeEstimate {
            __typename
            fee_estimate_fee_fast: fee_fast {
                __typename
                currency_amount_original_value: original_value
                currency_amount_original_unit: original_unit
                currency_amount_preferred_currency_unit: preferred_currency_unit
                currency_amount_preferred_currency_value_rounded: preferred_currency_value_rounded
                currency_amount_preferred_currency_value_approx: preferred_currency_value_approx
            }
            fee_estimate_fee_min: fee_min {
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
