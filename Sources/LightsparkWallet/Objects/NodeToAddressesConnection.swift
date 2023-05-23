// @generated
// This file was automatically generated and should not be edited.
// Copyright ©, 2023-present, Lightspark Group, Inc. - All Rights Reserved

/// A connection between a node and the addresses it has announced for itself on Lightning Network.
public struct NodeToAddressesConnection: Decodable {
    enum CodingKeys: String, CodingKey {

        case count = "node_to_addresses_connection_count"

        case entities = "node_to_addresses_connection_entities"

    }

    /// The total count of objects in this connection, using the current filters. It is different from the number of objects returned in the current page (in the `entities` field).
    public var count: Int64

    /// The addresses for the current page of this connection.
    public var entities: [NodeAddress]

}

extension NodeToAddressesConnection {
    public static let fragment = """

        fragment NodeToAddressesConnectionFragment on NodeToAddressesConnection {
            __typename
            node_to_addresses_connection_count: count
            node_to_addresses_connection_entities: entities {
                __typename
                node_address_address: address
                node_address_type: type
            }
        }
        """
}
