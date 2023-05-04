//
//  Queries.swift
//  LightsparkWallet
//
//  Created by Zhen Lu on 4/21/23.
//  Copyright © 2023 Lightspark Group, Inc. All rights reserved.
//

import Foundation

/// A set of pre-defined graphql queries.
enum Queries {
    static let bitcoinFeeEstimate = """
        query BitcoinFeeEstimate {
            bitcoin_fee_estimate {
                ...FeeEstimateFragment
            }
        }

        \(FeeEstimate.fragment)
        """

    static let decodePaymentRequest = """
        query DecodePaymentRequest($encoded_payment_request: String!) {
            decoded_payment_request(encoded_payment_request: $encoded_payment_request) {
                ...InvoiceDataFragment
            }
        }

        \(InvoiceData.fragment)
        """

    static let lightningFeeEstimateForNode = """
        query LightningFeeEstimateForNode(
            $destination_node_public_key: String!
            $amount_msats: Long!
        ) {
            lightning_fee_estimate_for_node(input: {
                destination_node_public_key: $destination_node_public_key,
                amount_msats: $amount_msats
            }) {
                ...LightningFeeEstimateOutputFragment
            }
        }

        \(LightningFeeEstimateOutput.fragment)
        """

    static let lightningFeeEstimateForInvoice = """
        query LightningFeeEstimateForInvoice(
            $encoded_payment_request: String!
            $amount_msats: Long
        ) {
            lightning_fee_estimate_for_node(input: {
                encoded_payment_request: $encoded_payment_request,
                amount_msats: $amount_msats
            }) {
                ...LightningFeeEstimateOutputFragment
            }
        }

        \(LightningFeeEstimateOutput.fragment)
        """

    static let getCurrentWallet = """
        query GetCurrentWallet {
            current_wallet {
                ...WalletFragment
            }
        }

        \(Wallet.fragment)
        """
}
