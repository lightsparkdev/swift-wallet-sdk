// @generated
// This file was automatically generated and should not be edited.
// Copyright ©, 2023-present, Lightspark Group, Inc. - All Rights Reserved

public struct FundWalletOutput: Decodable {
    enum CodingKeys: String, CodingKey {

        case amount = "fund_wallet_output_amount"

    }

    public var amount: CurrencyAmount

}

extension FundWalletOutput {
    public static let fragment = """

        fragment FundWalletOutputFragment on FundWalletOutput {
            __typename
            fund_wallet_output_amount: amount {
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
