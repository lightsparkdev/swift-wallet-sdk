//
//  AuthStateStorage.swift
//  LightsparkWallet
//
//  Created by Zhen Lu on 4/21/23.
//  Copyright © 2023 Lightspark Group, Inc. All rights reserved.
//

import Foundation

public protocol AuthStateStorage {
    func storeAuthStateData(data: Data)
    func getAuthStateData() -> Data?
    func deleteAuthStateData()
}
