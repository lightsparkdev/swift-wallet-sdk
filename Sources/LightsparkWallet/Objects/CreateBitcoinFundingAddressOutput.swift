// @generated
// This file was automatically generated and should not be edited.
// Copyright ©, 2023-present, Lightspark Group, Inc. - All Rights Reserved

public struct CreateBitcoinFundingAddressOutput: Decodable {
    enum CodingKeys: String, CodingKey {

        case bitcoinAddress = "create_bitcoin_funding_address_output_bitcoin_address"

    }

    public var bitcoinAddress: String

}

extension CreateBitcoinFundingAddressOutput {
    public static let fragment = """

        fragment CreateBitcoinFundingAddressOutputFragment on CreateBitcoinFundingAddressOutput {
            __typename
            create_bitcoin_funding_address_output_bitcoin_address: bitcoin_address
        }
        """
}
