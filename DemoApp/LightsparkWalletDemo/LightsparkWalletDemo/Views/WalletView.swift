//
//  WalletView.swift
//  LightsparkWalletDemo
//
//  Created by Zhen Lu on 5/2/23.
//  Copyright © 2023 Lightspark Group, Inc. All rights reserved.
//

import Combine
import LightsparkWallet
import SwiftUI

struct WalletView: View {
    @Binding var accountID: String
    @Binding var walletToken: String
    @Binding var invoice: String?
    @Binding var incomingInvoice: String?

    @StateObject var viewModel: WalletViewModel

    private var cancallables = [AnyCancellable]()

    init(
        accountID: Binding<String>,
        walletToken: Binding<String>,
        invoice: Binding<String?>,
        incomingInvoice: Binding<String?>
    ) {
        _accountID = accountID
        _walletToken = walletToken
        _invoice = invoice
        _incomingInvoice = incomingInvoice
        _viewModel = StateObject(
            wrappedValue: WalletViewModel(
                accountID: accountID.wrappedValue,
                walletToken: walletToken.wrappedValue
            )
        )
    }

    var body: some View {
        VStack {
            switch self.viewModel.viewModelState {
            case .notSetup:
                Text("Please Setup Account ID and JWT token.")
            case .notLoggedIn:
                Button("Log in") {
                    self.viewModel.login()
                }
            case .error(let error):
                Text("\(error?.localizedDescription ?? "Error")")
            case .loading:
                Text("Loading...")
            case .ready:
                VStack {
                    HStack {
                        Text("Wallet Status: \(self.viewModel.walletState?.rawValue ?? "Loading...")")
                    }

                    Text(
                        "Wallet Available Balance: \(self.viewModel.wallet?.balances?.ownedBalance.originalValue ?? 0) \(self.viewModel.wallet?.balances?.ownedBalance.originalUnit.rawValue ?? "Sats")"
                    )

                    if self.invoice != nil {
                        Text("Invoice Created: \(self.invoice ?? "")")
                            .textSelection(.enabled)
                    }

                    if self.incomingInvoice != nil {
                        Text("Incoming Invoice to pay")
                    }

                    if let decodedInvoice = self.viewModel.decodedInvoice {
                        Text(
                            "Invoice Amount: \(decodedInvoice.amount.originalValue) \(decodedInvoice.amount.originalUnit.rawValue)"
                        )
                        Text("Invoice Memo: \(decodedInvoice.memo ?? "")")
                    }

                    if let outgoingPayment = self.viewModel.outgoingPayment {
                        Text("Payment Sent: \(outgoingPayment.id) \(outgoingPayment.status.rawValue)")
                            .textSelection(.enabled)
                    }

                    if let transactionCount = self.viewModel.numberOfTransactions {
                        Text("There are: \(transactionCount) transactions.")
                    }

                    if let paymentRequestCount = self.viewModel.numberOfPaymentRequest {
                        Text("There are: \(paymentRequestCount) payment requests.")
                    }

                    if let feeEstimate = self.viewModel.feeEstimate {
                        Text("Fees: \(feeEstimate.originalValue) \(feeEstimate.originalUnit.rawValue)")
                    }

                }
                Spacer()
                HStack {
                    Button("Fetch Transactions") {
                        self.viewModel.loadTransactions()
                    }
                    .disabled(self.viewModel.walletState != .ready)

                    Button("Fetch Payment Requests") {
                        self.viewModel.loadPaymentRequests()
                    }
                    .disabled(self.viewModel.walletState != .ready)
                }
                HStack {
                    Button("Decode Invoice") {
                        if let invoice = self.incomingInvoice {
                            self.viewModel.decodeInvoice(invoice: invoice)
                        }
                    }
                    .disabled(self.viewModel.walletState != .ready || self.incomingInvoice == nil)

                    Button("Fees") {
                        if let invoice = self.incomingInvoice {
                            self.viewModel.feeEstimate(invoice: invoice)
                        }
                    }
                    .disabled(self.viewModel.walletState != .ready || self.incomingInvoice == nil)

                    Button("Pay Invoice") {
                        if let invoice = self.incomingInvoice {
                            self.viewModel.payInvoice(invoice: invoice)
                        }
                    }
                    .disabled(self.viewModel.walletState != .ready || self.incomingInvoice == nil)
                }
                HStack {
                    Button("Refresh wallet") {
                        self.viewModel.refreshWallet()
                    }

                    Button("Create Invoice") {
                        self.viewModel.createInvoice()
                    }
                    .disabled(self.viewModel.walletState != .ready)
                }
                HStack {
                    Button("Deploy wallet") {
                        self.viewModel.deployWallet()
                    }
                    .disabled(
                        self.viewModel.walletState != .notSetup && self.viewModel.walletState != .terminated
                            && self.viewModel.walletState != .terminating
                    )

                    Button("Initialize wallet") {
                        self.viewModel.initializeWallet()
                    }
                    .disabled(self.viewModel.walletState != .deployed)

                    Button("Terminate wallet") {
                        self.viewModel.terminateWallet()
                    }
                    .disabled(self.viewModel.walletState != .ready)
                }
            }
        }
        .padding()
        .onChange(of: accountID) { newValue in
            self.viewModel.accountID = newValue
        }
        .onChange(of: walletToken) { newValue in
            self.viewModel.walletToken = newValue
        }
        .onChange(of: self.viewModel.createdInvoice) { newValue in
            self.setInvoice(newValue)
        }
    }

    func setInvoice(_ invoice: String?) {
        self.invoice = invoice
    }
}
