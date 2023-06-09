//
//  WalletViewModel.swift
//  LightsparkWalletDemo
//
//  Created by Zhen Lu on 5/2/23.
//  Copyright © 2023 Lightspark Group, Inc. All rights reserved.
//

import Combine
import Foundation
import LightsparkWallet
import SwiftUI

struct JWTPayload: Codable {
    var sub: String
    var test: Bool
}

enum WalletViewModelState {
    case notSetup
    case notLoggedIn
    case loading
    case ready
    case error(Error?)
}

class WalletViewModel: ObservableObject {
    @Published var viewModelState: WalletViewModelState = .notLoggedIn
    @Published var walletState: WalletStatus? = nil
    @Published var wallet: Wallet? = nil
    @Published var createdInvoice: String? = nil
    @Published var decodedInvoice: InvoiceData? = nil
    @Published var outgoingPayment: OutgoingPayment? = nil
    @Published var numberOfPaymentRequest: Int? = nil
    @Published var numberOfTransactions: Int? = nil
    @Published var feeEstimate: CurrencyAmount? = nil
    @Published var l1Address: String? = nil

    var accountID: String {
        didSet {
            self.setupDidChange()
        }
    }
    var walletToken: String {
        didSet {
            self.setupDidChange()
        }
    }

    var keyTag: String {
        var base64String = self.walletToken.components(separatedBy: ".")[1]
        let remainder = base64String.count % 4
        if remainder > 0 {
            base64String = base64String.padding(
                toLength: base64String.count + 4 - remainder,
                withPad: "=",
                startingAt: 0
            )
        }
        let data = Data(base64Encoded: base64String)
        let payload: JWTPayload = try! JSONDecoder().decode(JWTPayload.self, from: data!)
        return "\(payload.sub)+\(payload.test)"
    }

    init(accountID: String, walletToken: String) {
        self.accountID = accountID
        self.walletToken = walletToken
        self.setupDidChange()
    }

    func login() {
        let authManager = JWTAuthManager()
        self.viewModelState = .loading
        authManager.login(accountID: self.accountID, secret: self.walletToken) { access, error in
            guard let access = access else {
                DispatchQueue.main.async {
                    self.viewModelState = .error(error)
                }
                return
            }

            let walletClient = WalletClient(accessToken: access)
            self.walletClient = walletClient
            self.walletStatusListener = try! WalletStatusListener(client: walletClient)
            DispatchQueue.main.async {
                self.viewModelState = .ready
            }
            self.refreshWallet()
        }
    }

    func deployWallet() {
        guard let walletClient = walletClient else {
            return
        }
        self.walletState = nil
        walletClient.deployWalletPublisher()
            .receive(on: RunLoop.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error)
                }
            } receiveValue: { output in
                self.walletState = output.wallet.status
            }
            .store(in: &self.cancellables)
    }

    func createInvoice() {
        guard let walletClient = walletClient else {
            return
        }

        walletClient.createInvoicePublisher(amountMSats: 1_233_000, memo: "test memo")
            .receive(on: RunLoop.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error)
                }
            } receiveValue: { output in
                self.createdInvoice = output.invoice.data.encodedPaymentRequest
            }
            .store(in: &self.cancellables)
    }

    func loadTransactions() {
        guard let walletClient = walletClient else {
            return
        }

        walletClient.fetchTransactionsPublisher()
            .receive(on: RunLoop.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error)
                }
            } receiveValue: { output in
                self.numberOfTransactions = output.entities.count
                print(output.entities[0])
            }
            .store(in: &self.cancellables)
    }

    func loadPaymentRequests() {
        guard let walletClient = walletClient else {
            return
        }

        walletClient.fetchPaymentRequestPublisher()
            .receive(on: RunLoop.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error)
                }
            } receiveValue: { output in
                self.numberOfPaymentRequest = output.entities.count
            }
            .store(in: &self.cancellables)
    }

    func payInvoice(invoice: String) {
        guard let walletClient = walletClient else {
            return
        }

        guard let key = self.privateKey else {
            return
        }

        walletClient.payInvoicePublisher(
            encodedInvoice: invoice,
            amountMSats: nil,
            maximumFeeMSats: 10000,
            timeout: 10,
            signingKey: key
        )
        .receive(on: RunLoop.main)
        .sink { completion in
            if case .failure(let error) = completion {
                print(error)
            }
        } receiveValue: { output in
            self.outgoingPayment = output.payment
        }
        .store(in: &self.cancellables)
    }

    func initializeWallet() {
        guard let walletClient = walletClient else {
            return
        }
        self.walletState = nil
        let (privateKey, publicKey) = try! Keys.generateNewRSASigningKeyPair(tag: self.keyTag, permanent: true)
        self.privateKey = privateKey

        walletClient.initializeWalletPublisher(signingPublicKey: publicKey, privateSigningKey: privateKey)
            .receive(on: RunLoop.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error)
                }
            } receiveValue: { output in
                self.walletState = output.wallet.status
                self.wallet = output.wallet
            }
            .store(in: &self.cancellables)
    }

    func terminateWallet() {
        guard let walletClient = walletClient else {
            return
        }
        self.walletState = nil
        try! Keys.removeRSAPrivateKey(tag: self.keyTag)
        walletClient.terminateWalletPublisher()
            .receive(on: RunLoop.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error)
                }
            } receiveValue: { output in
                self.walletState = output.wallet.status
                self.wallet = output.wallet
            }
            .store(in: &self.cancellables)

    }

    func refreshWallet() {
        guard let walletClient = walletClient else {
            return
        }
        walletClient.getCurrentWalletPublisher()
            .receive(on: RunLoop.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error)
                }
            } receiveValue: { wallet in
                self.walletState = wallet.status
                self.wallet = wallet
            }
            .store(in: &self.cancellables)
    }

    func decodeInvoice(invoice: String) {
        guard let walletClient = walletClient else {
            return
        }
        walletClient.decodePaymentRequestPublisher(encodedPaymentRequest: invoice)
            .receive(on: RunLoop.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error)
                }
            } receiveValue: { output in
                self.decodedInvoice = output
            }
            .store(in: &self.cancellables)
    }

    func createL1Address() {
        guard let walletClient = walletClient else {
            return
        }
        walletClient.createBitcoinFundingAddressPublisher()
            .receive(on: RunLoop.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error)
                }
            } receiveValue: { output in
                self.l1Address = output.bitcoinAddress
            }
            .store(in: &self.cancellables)
    }

    func feeEstimate(invoice: String) {
        guard let walletClient = walletClient else {
            return
        }
        walletClient.lightningFeeEstimateForInvoicePublisher(encodedPaymentRequest: invoice, amountMSats: nil)
            .receive(on: RunLoop.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error)
                }
            } receiveValue: { output in
                self.feeEstimate = output.feeEstimate
            }
            .store(in: &self.cancellables)
    }

    private func setupDidChange() {
        let tokenSetup = self.accountID.count > 0 && self.walletToken.count > 0
        self.viewModelState = tokenSetup ? .notLoggedIn : .notSetup
        if tokenSetup {
            self.privateKey = Keys.getRSAPrivateKey(tag: self.keyTag)
        }
    }

    private var walletClient: WalletClient? = nil
    private var walletStatusListener: WalletStatusListener? = nil {
        didSet {
            guard let listener = self.walletStatusListener else {
                return
            }
            listener.start()
            listener.$status
                .receive(on: RunLoop.main)
                .sink { [weak self] status in
                    if case .success(let status) = status {
                        self?.walletState = status
                        if status == .ready {
                            listener.cancel()
                        }
                    }
                }
                .store(in: &self.cancellables)
        }
    }
    private var cancellables = [AnyCancellable]()
    private var privateKey: SecKey? = nil
}
