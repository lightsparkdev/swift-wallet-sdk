// @generated
// This file was automatically generated and should not be edited.
// Copyright ©, 2023-present, Lightspark Group, Inc. - All Rights Reserved

public protocol Connection: Decodable {

    /// The total count of objects in this connection, using the current filters. It is different from the number of objects returned in the current page (in the `entities` field).
    var count: Int64 { get }

    /// An object that holds pagination information about the objects in this connection.
    var pageInfo: PageInfo { get }

}

public enum ConnectionEnum {
    case walletToPaymentRequestsConnection(WalletToPaymentRequestsConnection)
    case walletToTransactionsConnection(WalletToTransactionsConnection)

}

extension ConnectionEnum: Decodable {
    private enum CodingKeys: String, CodingKey {
        case __typename
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let typename = try container.decode(String.self, forKey: .__typename)
        switch typename {
        case "WalletToPaymentRequestsConnection":
            let walletToPaymentRequestsConnection = try WalletToPaymentRequestsConnection(from: decoder)
            self = .walletToPaymentRequestsConnection(walletToPaymentRequestsConnection)
        case "WalletToTransactionsConnection":
            let walletToTransactionsConnection = try WalletToTransactionsConnection(from: decoder)
            self = .walletToTransactionsConnection(walletToTransactionsConnection)

        default:
            throw DecodingError.dataCorruptedError(
                forKey: .__typename,
                in: container,
                debugDescription: "Invalid typename"
            )
        }
    }
}
