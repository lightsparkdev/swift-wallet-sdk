// @generated
// This file was automatically generated and should not be edited.
// Copyright ©, 2023-present, Lightspark Group, Inc. - All Rights Reserved

/// This is an object identifying the output of a test mode payment. This object can be used to retrieve the associated payment made from a Test Mode Payment call.
public struct CreateTestModePaymentoutput: Decodable {
    enum CodingKeys: String, CodingKey {

        case payment = "create_test_mode_paymentoutput_payment"

        case incomingPayment = "create_test_mode_paymentoutput_incoming_payment"

    }

    /// The payment that has been sent.
    public var payment: EntityWrapper

    /// The payment that has been received.
    public var incomingPayment: EntityWrapper

}

extension CreateTestModePaymentoutput {
    public static let fragment = """

        fragment CreateTestModePaymentoutputFragment on CreateTestModePaymentoutput {
            __typename
            create_test_mode_paymentoutput_payment: payment {
                id
            }
            create_test_mode_paymentoutput_incoming_payment: incoming_payment {
                id
            }
        }
        """
}
