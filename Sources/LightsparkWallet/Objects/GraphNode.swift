// @generated
// This file was automatically generated and should not be edited.
// Copyright ©, 2023-present, Lightspark Group, Inc. - All Rights Reserved
import Foundation

/// This object represents a node that exists on the Lightning Network, including nodes not managed by Lightspark. You can retrieve this object to get publicly available information about any node on the Lightning Network.
public struct GraphNode: Node, Entity, Decodable {
    enum CodingKeys: String, CodingKey {

        case id = "graph_node_id"

        case createdAt = "graph_node_created_at"

        case updatedAt = "graph_node_updated_at"

        case alias = "graph_node_alias"

        case bitcoinNetwork = "graph_node_bitcoin_network"

        case color = "graph_node_color"

        case conductivity = "graph_node_conductivity"

        case displayName = "graph_node_display_name"

        case publicKey = "graph_node_public_key"

    }

    /// The unique identifier of this entity across all Lightspark systems. Should be treated as an opaque string.
    public var id: String

    /// The date and time when the entity was first created.
    public var createdAt: Date

    /// The date and time when the entity was last updated.
    public var updatedAt: Date

    /// A name that identifies the node. It has no importance in terms of operating the node, it is just a way to identify and search for commercial services or popular nodes. This alias can be changed at any time by the node operator.
    public var alias: String?

    /// The Bitcoin Network this node is deployed in.
    public var bitcoinNetwork: BitcoinNetwork

    /// A hexadecimal string that describes a color. For example "#000000" is black, "#FFFFFF" is white. It has no importance in terms of operating the node, it is just a way to visually differentiate nodes. That color can be changed at any time by the node operator.
    public var color: String?

    /// A summary metric used to capture how well positioned a node is to send, receive, or route transactions efficiently. Maximizing a node's conductivity helps a node’s transactions to be capital efficient. The value is an integer ranging between 0 and 10 (bounds included).
    public var conductivity: Int64?

    /// The name of this node in the network. It will be the most human-readable option possible, depending on the data available for this node.
    public var displayName: String

    /// The public key of this node. It acts as a unique identifier of this node in the Lightning Network.
    public var publicKey: String?

}

extension GraphNode {
    public static let fragment = """

        fragment GraphNodeFragment on GraphNode {
            __typename
            graph_node_id: id
            graph_node_created_at: created_at
            graph_node_updated_at: updated_at
            graph_node_alias: alias
            graph_node_bitcoin_network: bitcoin_network
            graph_node_color: color
            graph_node_conductivity: conductivity
            graph_node_display_name: display_name
            graph_node_public_key: public_key
        }
        """
}

extension GraphNode {

    public static let addressesQuery = """
        query FetchNodeToAddressesConnection($first: Int, $types: [NodeAddressType!]) {
            current_wallet {
                ... on GraphNode {
                    addresses(, first: $first, types: $types) {
                    __typename
                    node_to_addresses_connection_count: count
                    node_to_addresses_connection_entities: entities {
                        __typename
                        node_address_address: address
                        node_address_type: type
                    }
                }
                }
            }
        }
        """

}
