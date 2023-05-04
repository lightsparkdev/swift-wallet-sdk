// @generated
// This file was automatically generated and should not be edited.
// Copyright ©, 2023-present, Lightspark Group, Inc. - All Rights Reserved

public protocol PaymentRequestData: Decodable {

    var encodedPaymentRequest: String { get }

    var bitcoinNetwork: BitcoinNetwork { get }

}

public enum PaymentRequestDataEnum {
    case invoiceData(InvoiceData)

}

extension PaymentRequestDataEnum: Decodable {
    private enum CodingKeys: String, CodingKey {
        case __typename
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let typename = try container.decode(String.self, forKey: .__typename)
        switch typename {
        case "InvoiceData":
            let invoiceData = try InvoiceData(from: decoder)
            self = .invoiceData(invoiceData)

        default:
            throw DecodingError.dataCorruptedError(
                forKey: .__typename,
                in: container,
                debugDescription: "Invalid typename"
            )
        }
    }
}
