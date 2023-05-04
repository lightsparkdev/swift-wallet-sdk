// @generated
// This file was automatically generated and should not be edited.
// Copyright ©, 2023-present, Lightspark Group, Inc. - All Rights Reserved

public protocol LightningTransaction: Transaction, Entity, Decodable {

}

public enum LightningTransactionEnum {
    case incomingPayment(IncomingPayment)
    case outgoingPayment(OutgoingPayment)

}

extension LightningTransactionEnum: Decodable {
    private enum CodingKeys: String, CodingKey {
        case __typename
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let typename = try container.decode(String.self, forKey: .__typename)
        switch typename {
        case "IncomingPayment":
            let incomingPayment = try IncomingPayment(from: decoder)
            self = .incomingPayment(incomingPayment)
        case "OutgoingPayment":
            let outgoingPayment = try OutgoingPayment(from: decoder)
            self = .outgoingPayment(outgoingPayment)

        default:
            throw DecodingError.dataCorruptedError(
                forKey: .__typename,
                in: container,
                debugDescription: "Invalid typename"
            )
        }
    }
}
