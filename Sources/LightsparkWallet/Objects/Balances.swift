// @generated
// This file was automatically generated and should not be edited.
// Copyright ©, 2023-present, Lightspark Group, Inc. - All Rights Reserved

public struct Balances: Decodable {
    enum CodingKeys: String, CodingKey {

        case accountingBalanceL1 = "balances_accounting_balance_l1"

        case accountingBalanceL2 = "balances_accounting_balance_l2"

        case availableBalanceL1 = "balances_available_balance_l1"

        case availableBalanceL2 = "balances_available_balance_l2"

        case settledBalanceL1 = "balances_settled_balance_l1"

        case settledBalanceL2 = "balances_settled_balance_l2"

    }

    /// TODO write a good description
    public var accountingBalanceL1: CurrencyAmount

    /// TODO write a good description
    public var accountingBalanceL2: CurrencyAmount

    /// TODO write a good description
    public var availableBalanceL1: CurrencyAmount

    /// TODO write a good description
    public var availableBalanceL2: CurrencyAmount

    /// TODO write a good description
    public var settledBalanceL1: CurrencyAmount

    /// TODO write a good description
    public var settledBalanceL2: CurrencyAmount

}

extension Balances {
    public static let fragment = """

        fragment BalancesFragment on Balances {
            __typename
            balances_accounting_balance_l1: accounting_balance_l1 {
                __typename
                currency_amount_original_value: original_value
                currency_amount_original_unit: original_unit
                currency_amount_preferred_currency_unit: preferred_currency_unit
                currency_amount_preferred_currency_value_rounded: preferred_currency_value_rounded
                currency_amount_preferred_currency_value_approx: preferred_currency_value_approx
            }
            balances_accounting_balance_l2: accounting_balance_l2 {
                __typename
                currency_amount_original_value: original_value
                currency_amount_original_unit: original_unit
                currency_amount_preferred_currency_unit: preferred_currency_unit
                currency_amount_preferred_currency_value_rounded: preferred_currency_value_rounded
                currency_amount_preferred_currency_value_approx: preferred_currency_value_approx
            }
            balances_available_balance_l1: available_balance_l1 {
                __typename
                currency_amount_original_value: original_value
                currency_amount_original_unit: original_unit
                currency_amount_preferred_currency_unit: preferred_currency_unit
                currency_amount_preferred_currency_value_rounded: preferred_currency_value_rounded
                currency_amount_preferred_currency_value_approx: preferred_currency_value_approx
            }
            balances_available_balance_l2: available_balance_l2 {
                __typename
                currency_amount_original_value: original_value
                currency_amount_original_unit: original_unit
                currency_amount_preferred_currency_unit: preferred_currency_unit
                currency_amount_preferred_currency_value_rounded: preferred_currency_value_rounded
                currency_amount_preferred_currency_value_approx: preferred_currency_value_approx
            }
            balances_settled_balance_l1: settled_balance_l1 {
                __typename
                currency_amount_original_value: original_value
                currency_amount_original_unit: original_unit
                currency_amount_preferred_currency_unit: preferred_currency_unit
                currency_amount_preferred_currency_value_rounded: preferred_currency_value_rounded
                currency_amount_preferred_currency_value_approx: preferred_currency_value_approx
            }
            balances_settled_balance_l2: settled_balance_l2 {
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
