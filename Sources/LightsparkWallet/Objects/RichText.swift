// @generated
// This file was automatically generated and should not be edited.
// Copyright ©, 2023-present, Lightspark Group, Inc. - All Rights Reserved

public struct RichText: Decodable {
    enum CodingKeys: String, CodingKey {

        case text = "rich_text_text"

    }

    public var text: String

}

extension RichText {
    public static let fragment = """

        fragment RichTextFragment on RichText {
            __typename
            rich_text_text: text
        }
        """
}
