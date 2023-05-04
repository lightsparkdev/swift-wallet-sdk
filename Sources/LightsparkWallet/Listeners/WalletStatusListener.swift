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
    @Published public var status: WalletStatus? = nil

    public init(client: WalletClient) {
        self.client = client
    }

    public func start() {
        let timerPublisher = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
        self.publisher
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error)
                }
            } receiveValue: { wallet in
                self.status = wallet.status
            }
            .store(in: &self.cancellables)

        timerPublisher
            .flatMap { _ in self.publisher }
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error)
                }
            } receiveValue: { wallet in
                self.status = wallet.status
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

    lazy var publisher: AnyPublisher<Wallet, Error> = client.getCurrentWalletPublisher()
}
