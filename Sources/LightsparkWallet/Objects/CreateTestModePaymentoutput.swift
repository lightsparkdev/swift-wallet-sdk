// @generated
// This file was automatically generated and should not be edited.
// Copyright ©, 2023-present, Lightspark Group, Inc. - All Rights Reserved

public struct CreateTestModePaymentoutput: Decodable {
    enum CodingKeys: String, CodingKey {

        case payment = "create_test_mode_paymentoutput_payment"

    }

    /// The payment that has been sent.
    public var payment: EntityWrapper

}

extension CreateTestModePaymentoutput {
    public static let fragment = """

        fragment CreateTestModePaymentoutputFragment on CreateTestModePaymentoutput {
            __typename
            create_test_mode_paymentoutput_payment: payment {
                id
            }
        }
        """
}
