// @generated
// This file was automatically generated and should not be edited.
// Copyright ©, 2023-present, Lightspark Group, Inc. - All Rights Reserved

/// Represents the value and unit for an amount of currency.
public struct CurrencyAmount: Decodable {
    enum CodingKeys: String, CodingKey {

        case originalValue = "currency_amount_original_value"

        case originalUnit = "currency_amount_original_unit"

        case preferredCurrencyUnit = "currency_amount_preferred_currency_unit"

        case preferredCurrencyValueRounded = "currency_amount_preferred_currency_value_rounded"

        case preferredCurrencyValueApprox = "currency_amount_preferred_currency_value_approx"

    }

    /// The original numeric value for this CurrencyAmount.
    public var originalValue: Int64

    /// The original unit of currency for this CurrencyAmount.
    public var originalUnit: CurrencyUnit

    /// The unit of user's preferred currency.
    public var preferredCurrencyUnit: CurrencyUnit

    /// The rounded numeric value for this CurrencyAmount in the very base level of user's preferred currency. For example, for USD, the value will be in cents.
    public var preferredCurrencyValueRounded: Int64

    /// The approximate float value for this CurrencyAmount in the very base level of user's preferred currency. For example, for USD, the value will be in cents.
    public var preferredCurrencyValueApprox: Double

}

extension CurrencyAmount {
    public static let fragment = """

        fragment CurrencyAmountFragment on CurrencyAmount {
            __typename
            currency_amount_original_value: original_value
            currency_amount_original_unit: original_unit
            currency_amount_preferred_currency_unit: preferred_currency_unit
            currency_amount_preferred_currency_value_rounded: preferred_currency_value_rounded
            currency_amount_preferred_currency_value_approx: preferred_currency_value_approx
        }
        """
}
