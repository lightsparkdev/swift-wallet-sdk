// @generated
// This file was automatically generated and should not be edited.
// Copyright ©, 2023-present, Lightspark Group, Inc. - All Rights Reserved

public struct PageInfo: Decodable {
    enum CodingKeys: String, CodingKey {

        case hasNextPage = "page_info_has_next_page"

        case hasPreviousPage = "page_info_has_previous_page"

        case startCursor = "page_info_start_cursor"

        case endCursor = "page_info_end_cursor"

    }

    public var hasNextPage: Bool?

    public var hasPreviousPage: Bool?

    public var startCursor: String?

    public var endCursor: String?

}

extension PageInfo {
    public static let fragment = """

        fragment PageInfoFragment on PageInfo {
            __typename
            page_info_has_next_page: has_next_page
            page_info_has_previous_page: has_previous_page
            page_info_start_cursor: start_cursor
            page_info_end_cursor: end_cursor
        }
        """
}
