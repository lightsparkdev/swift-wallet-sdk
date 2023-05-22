// @generated
// This file was automatically generated and should not be edited.
// Copyright ©, 2023-present, Lightspark Group, Inc. - All Rights Reserved

public struct CreateTestModeInvoiceOutput: Decodable {
    enum CodingKeys: String, CodingKey {

        case encodedPaymentRequest = "create_test_mode_invoice_output_encoded_payment_request"

    }

    public var encodedPaymentRequest: String

}

extension CreateTestModeInvoiceOutput {
    public static let fragment = """

        fragment CreateTestModeInvoiceOutputFragment on CreateTestModeInvoiceOutput {
            __typename
            create_test_mode_invoice_output_encoded_payment_request: encoded_payment_request
        }
        """
}
