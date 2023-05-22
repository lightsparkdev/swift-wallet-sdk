// @generated
// This file was automatically generated and should not be edited.
// Copyright ©, 2023-present, Lightspark Group, Inc. - All Rights Reserved

/// An object that represents the address of a node on the Lightning Network.
public struct NodeAddress: Decodable {
    enum CodingKeys: String, CodingKey {

        case address = "node_address_address"

        case type = "node_address_type"

    }

    /// The string representation of the address.
    public var address: String

    /// The type, or protocol, of this address.
    public var type: NodeAddressType

}

extension NodeAddress {
    public static let fragment = """

        fragment NodeAddressFragment on NodeAddress {
            __typename
            node_address_address: address
            node_address_type: type
        }
        """
}
