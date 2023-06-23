//
//  SubscriptionView.swift
//  LightsparkWalletDemo
//
//  Created by Zhen Lu on 6/23/23.
//  Copyright © 2023 Lightspark Group, Inc. All rights reserved.
//


import SwiftUI

struct SubscriptionView: View {
    @StateObject var viewModel: SubscriptionViewModel = SubscriptionViewModel()

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct SubscriptionView_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionView()
    }
}
