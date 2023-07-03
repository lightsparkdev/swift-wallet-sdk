//
//  TransactionStatusListener.swift
//  LightsparkWallet
//
//  Created by Zhen Lu on 5/12/23.
//  Copyright © 2023 Lightspark Group, Inc. All rights reserved.
//

import Combine
import Foundation

/// A class for listening to transaction state.
@available(iOS 14.0, *)
public class TransactionStatusListener: ObservableObject {
    @Published public var status: TransactionStatusListenerResult? = nil

    public enum TransactionStatusListenerResult {
        case success(TransactionStatus)
        case fail(Error)
    }

    public enum TransactionStatusListenerError: Error{
        case typeNotSupported
    }

    public init(client: WalletClient, id: String) throws {
        self.client = client
        self.id = id

        self.subscription = try {
            let type = id.components(separatedBy: ":").first
            switch type {
            case "Deposit":
                let subscription: Subscription<Deposit> = try client.entitySubscriptionPublisher(id: id)
                return Subscription(id: subscription.id, publisher: subscription.publisher.map { $0.status }.eraseToAnyPublisher())
            case "IncomingPayment":
                let subscription: Subscription<IncomingPayment> = try client.entitySubscriptionPublisher(id: id)
                return Subscription(id: subscription.id, publisher: subscription.publisher.map { $0.status }.eraseToAnyPublisher())
            case "OutgoingPayment":
                let subscription: Subscription<OutgoingPayment> = try client.entitySubscriptionPublisher(id: id)
                return Subscription(id: subscription.id, publisher: subscription.publisher.map { $0.status }.eraseToAnyPublisher())
            case "Withdrawal":
                let subscription: Subscription<Withdrawal> = try client.entitySubscriptionPublisher(id: id)
                return Subscription(id: subscription.id, publisher: subscription.publisher.map { $0.status }.eraseToAnyPublisher())
            case "ChannelOpeningTransaction":
                let subscription: Subscription<ChannelOpeningTransaction> = try client.entitySubscriptionPublisher(id: id)
                return Subscription(id: subscription.id, publisher: subscription.publisher.map { $0.status }.eraseToAnyPublisher())
            case "ChannelClosingTransaction":
                let subscription: Subscription<ChannelClosingTransaction> = try client.entitySubscriptionPublisher(id: id)
                return Subscription(id: subscription.id, publisher: subscription.publisher.map { $0.status }.eraseToAnyPublisher())
            default:
                throw TransactionStatusListener.TransactionStatusListenerError.typeNotSupported
            }
        }()
    }

    public func start() {
        self.subscription.publisher
            .sink { completion in
                if case .failure(let error) = completion {
                    self.status = .fail(error)
                }
            } receiveValue: { status in
                self.status = .success(status)
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
    private var id: String
    private var cancellables = Set<AnyCancellable>()

    private var subscription: Subscription<TransactionStatus>
}
