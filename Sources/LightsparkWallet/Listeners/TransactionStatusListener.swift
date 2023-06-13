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

        self.publisher = try {
            let type = id.components(separatedBy: ":").first
            switch type {
            case "Deposit":
                let publisher: AnyPublisher<Deposit, Error> = client.getEntityPublisher(id: id)
                return publisher.map { $0.status }.eraseToAnyPublisher()
            case "IncomingPayment":
                let publisher: AnyPublisher<IncomingPayment, Error> = client.getEntityPublisher(id: id)
                return publisher.map { $0.status }.eraseToAnyPublisher()
            case "OutgoingPayment":
                let publisher: AnyPublisher<OutgoingPayment, Error> = client.getEntityPublisher(id: id)
                return publisher.map { $0.status }.eraseToAnyPublisher()
            case "Withdrawal":
                let publisher: AnyPublisher<Withdrawal, Error> = client.getEntityPublisher(id: id)
                return publisher.map { $0.status }.eraseToAnyPublisher()
            case "ChannelOpeningTransaction":
                let publisher: AnyPublisher<ChannelOpeningTransaction, Error> = client.getEntityPublisher(id: id)
                return publisher.map { $0.status }.eraseToAnyPublisher()
            case "ChannelClosingTransaction":
                let publisher: AnyPublisher<ChannelClosingTransaction, Error> = client.getEntityPublisher(id: id)
                return publisher.map { $0.status }.eraseToAnyPublisher()
            default:
                throw TransactionStatusListener.TransactionStatusListenerError.typeNotSupported
            }
        }()
    }

    public func start() {
        let timerPublisher = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
        self.publisher
            .sink { completion in
                if case .failure(let error) = completion {
                    self.status = .fail(error)
                }
            } receiveValue: { status in
                self.status = .success(status)
            }
            .store(in: &self.cancellables)

        timerPublisher
            .flatMap { _ in self.publisher }
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

    private var client: WalletClient
    private var id: String
    private var cancellables = Set<AnyCancellable>()

    private var publisher: AnyPublisher<TransactionStatus, Error>
}
