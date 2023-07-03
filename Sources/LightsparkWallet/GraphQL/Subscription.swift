//
//  Subscription.swift
//  LightsparkWallet
//
//  Created by Zhen Lu on 7/3/23.
//  Copyright © 2023 Lightspark Group, Inc. All rights reserved.
//


import Combine
import Foundation

public struct Subscription<T> {
    public var id: String
    public var publisher: AnyPublisher<T, Error>
}
