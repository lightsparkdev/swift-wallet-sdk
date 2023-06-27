//
//  Operation.swift
//  
//
//  Created by Zhen Lu on 6/26/23.
//  Copyright © 2023 Lightspark Group, Inc. All rights reserved.
//


import Foundation

struct Operation {
    var operation: String
    var variables: [AnyHashable: Any?]
    var signingKey: SecKey?
}
