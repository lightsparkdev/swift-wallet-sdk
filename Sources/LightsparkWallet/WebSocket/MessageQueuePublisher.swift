//
//  MessageQueuePublisher.swift
//  LightsparkWallet
//
//  Created by Zhen Lu on 6/26/23.
//  Copyright © 2023 Lightspark Group, Inc. All rights reserved.
//

import Combine
import Foundation

/// A Publisher that stores incoming message until it gets subscribed.
class MessageQueuePublisher<T>: Publisher {
    typealias Output = T
    typealias Failure = Never

    private let subject = PassthroughSubject<T, Never>()
    private var values: [T] = []
    private var received = false

    func send(_ value: T) {
        if !received {
            values.append(value)
        }
        subject.send(value)
    }

    func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
        subject.receive(subscriber: subscriber)
        values.forEach { value in
            _ = subscriber.receive(value)
        }
        received = true
        values = []
    }
}
