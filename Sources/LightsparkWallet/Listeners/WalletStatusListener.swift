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

    public init(client: WalletClient) {
        self.client = client
    }

    public func start() {
        self.publisher
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

    private var client: WalletClient
    private var cancellables = Set<AnyCancellable>()

    lazy var publisher: AnyPublisher<Wallet, Error> = client.currentWalletSubscriptionPublisher()
}
