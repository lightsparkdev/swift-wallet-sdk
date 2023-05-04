//
//  WalletSetupView.swift
//  LightsparkWalletDemo
//
//  Created by Zhen Lu on 5/2/23.
//  Copyright © 2023 Lightspark Group, Inc. All rights reserved.
//

import SwiftUI

struct WalletSetupView: View {
    @Binding var accountID: String
    @Binding var wallet1Token: String
    @Binding var wallet2Token: String

    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            Text("Account ID")
                .font(Font.system(size: 16, weight: .bold))
            TextField("Account ID", text: $accountID, axis: .vertical)
                .frame(maxHeight: 40)
                .lineLimit(2)

            Spacer()
            Text("Wallet 1 JWT")
                .font(Font.system(size: 16, weight: .bold))
            TextField("Account ID", text: $wallet1Token, axis: .vertical)
                .frame(height: 180)
                .lineLimit(8)

            Spacer()
            Text("Wallet 2 JWT")
                .font(Font.system(size: 16, weight: .bold))
            TextField("Account ID", text: $wallet2Token, axis: .vertical)
                .frame(height: 180)
                .lineLimit(8)
            Spacer()
        }
        .padding()
    }
}
