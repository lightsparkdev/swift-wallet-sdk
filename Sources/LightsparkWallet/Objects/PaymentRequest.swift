// @generated
// This file was automatically generated and should not be edited.
// Copyright ©, 2023-present, Lightspark Group, Inc. - All Rights Reserved

public protocol PaymentRequest: Entity, Decodable {

    associatedtype PaymentRequestDataType: PaymentRequestData
    /// The details of the payment request.
    var data: PaymentRequestDataType { get }

    /// The status of the payment request.
    var status: PaymentRequestStatus { get }

}

public enum PaymentRequestEnum {
    case invoice(Invoice)

}

extension PaymentRequestEnum: Decodable {
    private enum CodingKeys: String, CodingKey {
        case __typename
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let typename = try container.decode(String.self, forKey: .__typename)
        switch typename {
        case "Invoice":
            let invoice = try Invoice(from: decoder)
            self = .invoice(invoice)

        default:
            throw DecodingError.dataCorruptedError(
                forKey: .__typename,
                in: container,
                debugDescription: "Invalid typename"
            )
        }
    }
}
