//
//  Subscriptions.swift
//  LightsparkWallet
//
//  Created by Zhen Lu on 6/27/23.
//  Copyright © 2023 Lightspark Group, Inc. All rights reserved.
//


import Foundation

/// A set of pre-defined graphql subscriptions
enum Subscriptions {
    static let currentWalletSubscription = """
        subscription CurrentWallet {
            current_wallet {
                ...WalletFragment
            }
        }

        \(Wallet.fragment)
        """
}
