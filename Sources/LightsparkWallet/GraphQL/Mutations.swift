//
//  Mutations.swift
//  LightsparkWallet
//
//  Created by Zhen Lu on 4/21/23.
//  Copyright © 2023 Lightspark Group, Inc. All rights reserved.
//

import Foundation

/// A set of pre-defined graphql mutation.
enum Mutations {
    static let createBitcoinFundingAddress = """
        mutation CreateBitcoinFundingAddress {
            create_bitcoin_funding_address {
                ...CreateBitcoinFundingAddressOutputFragment
            }
        }

        \(CreateBitcoinFundingAddressOutput.fragment)
        """

    static let createInvoice = """
        mutation CreateInvoice(
            $amount_msats: Long!
            $memo: String
            $invoice_type: InvoiceType
        ) {
            create_invoice(input: {
                amount_msats: $amount_msats
                memo: $memo
                invoice_type: $invoice_type
            }) {
                ...CreateInvoiceOutputFragment
            }
        }

        \(CreateInvoiceOutput.fragment)
        """

    static let deployWallet = """
        mutation DeployWallet {
            deploy_wallet {
                ...DeployWalletOutputFragment
            }
        }

        \(DeployWalletOutput.fragment)
        """

    static let initlizeWallet = """
        mutation InitializeWallet(
            $signing_public_key: String!
        ) {
            initialize_wallet(
                input: {
                    signing_public_key: {
                        type: RSA_OAEP
                        public_key: $signing_public_key
                    }
                }
            ) {
                ...InitializeWalletOutputFragment
            }
        }

        \(InitializeWalletOutput.fragment)
        """

    static let payInvoice = """
        mutation PayInvoice(
            $encoded_invoice: String!
            $timeout_secs: Int!
            $maximum_fees_msats: Long!
            $amount_msats: Long
        ) {
            pay_invoice(input: {
                encoded_invoice: $encoded_invoice
                timeout_secs: $timeout_secs
                maximum_fees_msats: $maximum_fees_msats
                amount_msats: $amount_msats
            }) {
                ...PayInvoiceOutputFragment
            }
        }

        \(PayInvoiceOutput.fragment)
        """

    static let requestWithdrawal = """
        mutation RequestWithdrawal(
            $amount_sats: Long!
            $bitcoin_address: String!
        ) {
            request_withdrawal(input: {
                amount_sats: $amount_sats
                bitcoin_address: $bitcoin_address
            }) {
                ...RequestWithdrawalOutputFragment
            }
        }

        \(RequestWithdrawalOutput.fragment)
        """

    static let sendPayment = """
        mutation SendPayment(
            $destination_public_key: String!
            $amount_msats: Long!
            $timeout_secs: Int!
            $maximum_fees_msats: Long!
        ) {
            send_payment(input: {
                destination_public_key: $destination_public_key
                amount_msats: $amount_msats
                timeout_secs: $timeout_secs
                maximum_fees_msats: $maximum_fees_msats
            }) {
                ...SendPaymentOutputFragment
            }
        }

        \(SendPaymentOutput.fragment)
        """

    static let terminateWallet = """
        mutation TerminateWallet {
            terminate_wallet {
                ...TerminateWalletOutputFragment
            }
        }

        \(TerminateWalletOutput.fragment)
        """

    static let createTestModeInvoice = """
        mutation CreateTestModeInvoice(
            $amount_msats: Long!
            $memo: String
            $invoice_type: InvoiceType
        ) {
            create_test_mode_invoice(input: {
                amount_msats: $amount_msats
                memo: $memo
                invoice_type: $invoice_type
            }) {
                encoded_payment_request
            }
        }
        """

    static let createTestModePayment = """
        mutation CreateTestModePayment(
            $encoded_invoice: String!
            $amount_msats: Long
        ) {
            create_test_mode_payment(input: {
                encoded_invoice: $encoded_invoice
                amount_msats: $amount_msats
            }) {
                payment {
                    ...OutgoingPaymentFragment
                }
            }
        }
        """
}
