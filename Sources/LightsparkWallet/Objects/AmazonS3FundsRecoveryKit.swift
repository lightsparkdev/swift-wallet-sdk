// @generated
// This file was automatically generated and should not be edited.
// Copyright ©, 2023-present, Lightspark Group, Inc. - All Rights Reserved

public struct AmazonS3FundsRecoveryKit: FundsRecoveryKit, Decodable {
    enum CodingKeys: String, CodingKey {

        case bitcoinWalletAddress = "amazon_s3_funds_recovery_kit_bitcoin_wallet_address"

        case s3BucketUrl = "amazon_s3_funds_recovery_kit_s3_bucket_url"

    }

    /// The bitcoin address where the funds should be sent if the recovery kit is used.
    public var bitcoinWalletAddress: String

    /// The URL of the Amazon S3 bucket URL where we should upload the funds recovery kit.
    public var s3BucketUrl: String

}

extension AmazonS3FundsRecoveryKit {
    public static let fragment = """

        fragment AmazonS3FundsRecoveryKitFragment on AmazonS3FundsRecoveryKit {
            __typename
            amazon_s3_funds_recovery_kit_bitcoin_wallet_address: bitcoin_wallet_address
            amazon_s3_funds_recovery_kit_s3_bucket_url: s3_bucket_url
        }
        """
}
