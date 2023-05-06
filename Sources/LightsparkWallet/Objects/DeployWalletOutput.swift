// @generated
// This file was automatically generated and should not be edited.
// Copyright ©, 2023-present, Lightspark Group, Inc. - All Rights Reserved

public struct DeployWalletOutput: Decodable {
    enum CodingKeys: String, CodingKey {

        case wallet = "deploy_wallet_output_wallet"

    }

    public var wallet: Wallet

}

extension DeployWalletOutput {
    public static let fragment = """

        fragment DeployWalletOutputFragment on DeployWalletOutput {
            __typename
            deploy_wallet_output_wallet: wallet {
                __typename
                wallet_id: id
                wallet_created_at: created_at
                wallet_updated_at: updated_at
                wallet_balances: balances {
                    __typename
                    balances_owned_balance: owned_balance {
                        __typename
                        currency_amount_original_value: original_value
                        currency_amount_original_unit: original_unit
                        currency_amount_preferred_currency_unit: preferred_currency_unit
                        currency_amount_preferred_currency_value_rounded: preferred_currency_value_rounded
                        currency_amount_preferred_currency_value_approx: preferred_currency_value_approx
                    }
                    balances_available_to_send_balance: available_to_send_balance {
                        __typename
                        currency_amount_original_value: original_value
                        currency_amount_original_unit: original_unit
                        currency_amount_preferred_currency_unit: preferred_currency_unit
                        currency_amount_preferred_currency_value_rounded: preferred_currency_value_rounded
                        currency_amount_preferred_currency_value_approx: preferred_currency_value_approx
                    }
                    balances_available_to_withdraw_balance: available_to_withdraw_balance {
                        __typename
                        currency_amount_original_value: original_value
                        currency_amount_original_unit: original_unit
                        currency_amount_preferred_currency_unit: preferred_currency_unit
                        currency_amount_preferred_currency_value_rounded: preferred_currency_value_rounded
                        currency_amount_preferred_currency_value_approx: preferred_currency_value_approx
                    }
                }
                wallet_status: status
            }
        }
        """
}
