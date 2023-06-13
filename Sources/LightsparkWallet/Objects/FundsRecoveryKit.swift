// @generated
// This file was automatically generated and should not be edited.
// Copyright ©, 2023-present, Lightspark Group, Inc. - All Rights Reserved

public protocol FundsRecoveryKit: Decodable {

    /// The bitcoin address where the funds should be sent if the recovery kit is used.
    var bitcoinWalletAddress: String { get }

}

public enum FundsRecoveryKitEnum {
    case amazonS3FundsRecoveryKit(AmazonS3FundsRecoveryKit)

}

extension FundsRecoveryKitEnum: Decodable {
    private enum CodingKeys: String, CodingKey {
        case __typename
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let typename = try container.decode(String.self, forKey: .__typename)
        switch typename {
        case "AmazonS3FundsRecoveryKit":
            let amazonS3FundsRecoveryKit = try AmazonS3FundsRecoveryKit(from: decoder)
            self = .amazonS3FundsRecoveryKit(amazonS3FundsRecoveryKit)

        default:
            throw DecodingError.dataCorruptedError(
                forKey: .__typename,
                in: container,
                debugDescription: "Invalid typename"
            )
        }
    }
}
