//
//  ContentView.swift
//  LightsparkWalletDemo
//
//  Created by Zhen Lu on 4/21/23.
//  Copyright © 2023 Lightspark Group, Inc. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var accountID: String = ProcessInfo.processInfo.environment["ACCOUNT_ID"] ?? ""
    @State var wallet1Token: String = ProcessInfo.processInfo.environment["WALLET_1_JWT"] ?? ""
    @State var wallet2Token: String = ProcessInfo.processInfo.environment["WALLET_2_JWT"] ?? ""

    @State var wallet1Invoice: String? = nil
    @State var wallet2Invoice: String? = nil

    var body: some View {
        TabView {
            WalletSetupView(accountID: $accountID, wallet1Token: $wallet1Token, wallet2Token: $wallet2Token)
                .tabItem {
                    Label("Setup", systemImage: "line.3.horizontal")
                }
            WalletView(
                accountID: $accountID,
                walletToken: $wallet1Token,
                invoice: $wallet1Invoice,
                incomingInvoice: $wallet2Invoice
            )
            .tabItem {
                Label("Wallet 1", systemImage: "case")
            }
            WalletView(
                accountID: $accountID,
                walletToken: $wallet2Token,
                invoice: $wallet2Invoice,
                incomingInvoice: $wallet1Invoice
            )
            .tabItem {
                Label("Wallet 2", systemImage: "case")
            }
        }
    }
}
