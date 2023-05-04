// @generated
// This file was automatically generated and should not be edited.
// Copyright ©, 2023-present, Lightspark Group, Inc. - All Rights Reserved
import Foundation

public struct Wallet: Entity, Decodable {
    enum CodingKeys: String, CodingKey {

        case id = "wallet_id"

        case createdAt = "wallet_created_at"

        case updatedAt = "wallet_updated_at"

        case balances = "wallet_balances"

        case status = "wallet_status"

    }

    /// The unique identifier of this entity across all Lightspark systems. Should be treated as an opaque string.
    public var id: String

    /// The date and time when the entity was first created.
    public var createdAt: Date

    /// The date and time when the entity was last updated.
    public var updatedAt: Date

    /// The balances that describe the funds in this wallet.
    public var balances: Balances?

    /// The status of this wallet.
    public var status: WalletStatus

}

extension Wallet {
    public static let fragment = """

        fragment WalletFragment on Wallet {
            __typename
            wallet_id: id
            wallet_created_at: created_at
            wallet_updated_at: updated_at
            wallet_balances: balances {
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
            wallet_status: status
        }
        """
}

extension Wallet {

    public static let transactionsQuery = """
        query FetchWalletToTransactionsConnection($first: Int, $after: ID, $created_after_date: DateTime, $created_before_date: DateTime, $statuses: [TransactionStatus!], $types: [TransactionType!]) {
            current_wallet {
                ... on Wallet {
                    transactions(, first: $first, after: $after, created_after_date: $created_after_date, created_before_date: $created_before_date, statuses: $statuses, types: $types) {
                    __typename
                    wallet_to_transactions_connection_page_info: page_info {
                        __typename
                        page_info_has_next_page: has_next_page
                        page_info_has_previous_page: has_previous_page
                        page_info_start_cursor: start_cursor
                        page_info_end_cursor: end_cursor
                    }
                    wallet_to_transactions_connection_count: count
                    wallet_to_transactions_connection_entities: entities {
                        __typename
                        ... on Deposit {
                            __typename
                            deposit_id: id
                            deposit_created_at: created_at
                            deposit_updated_at: updated_at
                            deposit_status: status
                            deposit_resolved_at: resolved_at
                            deposit_amount: amount {
                                __typename
                                currency_amount_original_value: original_value
                                currency_amount_original_unit: original_unit
                                currency_amount_preferred_currency_unit: preferred_currency_unit
                                currency_amount_preferred_currency_value_rounded: preferred_currency_value_rounded
                                currency_amount_preferred_currency_value_approx: preferred_currency_value_approx
                            }
                            deposit_transaction_hash: transaction_hash
                            deposit_fees: fees {
                                __typename
                                currency_amount_original_value: original_value
                                currency_amount_original_unit: original_unit
                                currency_amount_preferred_currency_unit: preferred_currency_unit
                                currency_amount_preferred_currency_value_rounded: preferred_currency_value_rounded
                                currency_amount_preferred_currency_value_approx: preferred_currency_value_approx
                            }
                            deposit_block_hash: block_hash
                            deposit_block_height: block_height
                            deposit_destination_addresses: destination_addresses
                            deposit_num_confirmations: num_confirmations
                        }
                        ... on IncomingPayment {
                            __typename
                            incoming_payment_id: id
                            incoming_payment_created_at: created_at
                            incoming_payment_updated_at: updated_at
                            incoming_payment_status: status
                            incoming_payment_resolved_at: resolved_at
                            incoming_payment_amount: amount {
                                __typename
                                currency_amount_original_value: original_value
                                currency_amount_original_unit: original_unit
                                currency_amount_preferred_currency_unit: preferred_currency_unit
                                currency_amount_preferred_currency_value_rounded: preferred_currency_value_rounded
                                currency_amount_preferred_currency_value_approx: preferred_currency_value_approx
                            }
                            incoming_payment_transaction_hash: transaction_hash
                            incoming_payment_payment_request: payment_request {
                                id
                            }
                        }
                        ... on OutgoingPayment {
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
                                }
                            }
                            outgoing_payment_failure_reason: failure_reason
                            outgoing_payment_failure_message: failure_message {
                                __typename
                                rich_text_text: text
                            }
                        }
                        ... on Withdrawal {
                            __typename
                            withdrawal_id: id
                            withdrawal_created_at: created_at
                            withdrawal_updated_at: updated_at
                            withdrawal_status: status
                            withdrawal_resolved_at: resolved_at
                            withdrawal_amount: amount {
                                __typename
                                currency_amount_original_value: original_value
                                currency_amount_original_unit: original_unit
                                currency_amount_preferred_currency_unit: preferred_currency_unit
                                currency_amount_preferred_currency_value_rounded: preferred_currency_value_rounded
                                currency_amount_preferred_currency_value_approx: preferred_currency_value_approx
                            }
                            withdrawal_transaction_hash: transaction_hash
                            withdrawal_fees: fees {
                                __typename
                                currency_amount_original_value: original_value
                                currency_amount_original_unit: original_unit
                                currency_amount_preferred_currency_unit: preferred_currency_unit
                                currency_amount_preferred_currency_value_rounded: preferred_currency_value_rounded
                                currency_amount_preferred_currency_value_approx: preferred_currency_value_approx
                            }
                            withdrawal_block_hash: block_hash
                            withdrawal_block_height: block_height
                            withdrawal_destination_addresses: destination_addresses
                            withdrawal_num_confirmations: num_confirmations
                        }
                    }
                }
                }
            }
        }
        """

    public static let paymentRequestsQuery = """
        query FetchWalletToPaymentRequestsConnection($first: Int, $after: ID, $created_after_date: DateTime, $created_before_date: DateTime) {
            current_wallet {
                ... on Wallet {
                    payment_requests(, first: $first, after: $after, created_after_date: $created_after_date, created_before_date: $created_before_date) {
                    __typename
                    wallet_to_payment_requests_connection_page_info: page_info {
                        __typename
                        page_info_has_next_page: has_next_page
                        page_info_has_previous_page: has_previous_page
                        page_info_start_cursor: start_cursor
                        page_info_end_cursor: end_cursor
                    }
                    wallet_to_payment_requests_connection_count: count
                    wallet_to_payment_requests_connection_entities: entities {
                        __typename
                        ... on Invoice {
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
                }
                }
            }
        }
        """

}
