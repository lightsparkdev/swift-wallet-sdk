//
//  WalletStateListener.swift
//  LightsparkWallet
//
//  Created by Zhen Lu on 5/2/23.
//  Copyright © 2023 Lightspark Group, Inc. All rights reserved.
//

import Combine
import Foundation

/// A class for listening to wallet state.
@available(iOS 14.0, *)
public class WalletStatusListener: ObservableObject {
    @Published public var status: WalletStatusListenerResult? = nil

    public enum WalletStatusListenerResult {
        case success(WalletStatus)
        case fail(Error)
    }

    public init(client: WalletClient) throws {
        self.client = client
        self.subscription = try client.currentWalletSubscriptionPublisher()
    }

    public func start() {
        self.subscription.publisher
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.status = .fail(error)
                }
            } receiveValue: { [weak self] wallet in
                self?.status = .success(wallet.status)
            }
            .store(in: &self.cancellables)
    }

    public func cancel() {
        for item in self.cancellables {
            item.cancel()
        }
    }

    public func finish() {
        self.client.subscriptionComplete(id: self.subscription.id)
    }

    private var client: WalletClient
    private var cancellables = Set<AnyCancellable>()

    private var subscription: Subscription<Wallet>
}
