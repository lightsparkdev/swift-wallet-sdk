// @generated
// This file was automatically generated and should not be edited.
// Copyright ©, 2023-present, Lightspark Group, Inc. - All Rights Reserved

public protocol Node: Entity, Decodable {

    /// A name that identifies the node. It has no importance in terms of operating the node, it is just a way to identify and search for commercial services or popular nodes. This alias can be changed at any time by the node operator.
    var alias: String? { get }

    /// The Bitcoin Network this node is deployed in.
    var bitcoinNetwork: BitcoinNetwork { get }

    /// A hexadecimal string that describes a color. For example "#000000" is black, "#FFFFFF" is white. It has no importance in terms of operating the node, it is just a way to visually differentiate nodes. That color can be changed at any time by the node operator.
    var color: String? { get }

    /// A summary metric used to capture how well positioned a node is to send, receive, or route transactions efficiently. Maximizing a node's conductivity helps a node’s transactions to be capital efficient. The value is an integer ranging between 0 and 10 (bounds included).
    var conductivity: Int64? { get }

    /// The name of this node in the network. It will be the most human-readable option possible, depending on the data available for this node.
    var displayName: String { get }

    /// The public key of this node. It acts as a unique identifier of this node in the Lightning Network.
    var publicKey: String? { get }

}

public enum NodeEnum {
    case graphNode(GraphNode)

}

extension NodeEnum: Decodable {
    private enum CodingKeys: String, CodingKey {
        case __typename
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let typename = try container.decode(String.self, forKey: .__typename)
        switch typename {
        case "GraphNode":
            let graphNode = try GraphNode(from: decoder)
            self = .graphNode(graphNode)

        default:
            throw DecodingError.dataCorruptedError(
                forKey: .__typename,
                in: container,
                debugDescription: "Invalid typename"
            )
        }
    }
}
