// @generated
// This file was automatically generated and should not be edited.
// Copyright ©, 2023-present, Lightspark Group, Inc. - All Rights Reserved

public struct WalletToPaymentRequestsConnection: Decodable {
    enum CodingKeys: String, CodingKey {

        case pageInfo = "wallet_to_payment_requests_connection_page_info"

        case count = "wallet_to_payment_requests_connection_count"

        case entities = "wallet_to_payment_requests_connection_entities"

    }

    /// An object that holds pagination information about the objects in this connection.
    public var pageInfo: PageInfo

    /// The total count of objects in this connection, using the current filters. It is different from the number of objects returned in the current page (in the `entities` field).
    public var count: Int64

    /// The payment requests for the current page of this connection.
    public var entities: [PaymentRequestEnum]

}

extension WalletToPaymentRequestsConnection {
    public static let fragment = """

        fragment WalletToPaymentRequestsConnectionFragment on WalletToPaymentRequestsConnection {
            __typename
            wallet_to_payment_requests_connection_page_info: page_info {
                __typename
                page_info_has_next_page: has_next_page
                page_info_has_previous_page: has_previous_page
                page_info_start_cursor: start_cursor
                page_info_end_cursor: end_cursor
            }
            wallet_to_payment_requests_connection_count: count
            wallet_to_payment_requests_connection_entities: entities {
                id
            }
        }
        """
}
