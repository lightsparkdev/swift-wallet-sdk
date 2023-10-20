// @generated
// This file was automatically generated and should not be edited.
// Copyright ©, 2023-present, Lightspark Group, Inc. - All Rights Reserved

/// This is an enum of the potential types of addresses that a node on the Lightning Network can have.
public enum NodeAddressType: String, Decodable {

    case ipv4 = "IPV4"

    case ipv6 = "IPV6"

    case tor = "TOR"
}
