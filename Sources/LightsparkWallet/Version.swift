//
//  Version.swift
//  LightsparkWallet
//
//  Created by Zhen Lu on 5/4/23.
//  Copyright © 2023 Lightspark Group, Inc. All rights reserved.
//

let version = "1.3.0"

func systemName() -> String{
#if os(iOS)
    return "iOS"
#elseif os(macOS)
    return "macOS"
#elseif os(watchOS)
    return "watchOS"
#elseif os(tvOS)
    return "tvOS"
#else
    return "Unknown"
#endif
}
