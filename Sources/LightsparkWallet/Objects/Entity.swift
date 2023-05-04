// @generated
// This file was automatically generated and should not be edited.
// Copyright ©, 2023-present, Lightspark Group, Inc. - All Rights Reserved
import Foundation

public protocol Entity: Decodable {
    static var fragment: String { get }

    /// The unique identifier of this entity across all Lightspark systems. Should be treated as an opaque string.
    var id: String { get }

    /// The date and time when the entity was first created.
    var createdAt: Date { get }

    /// The date and time when the entity was last updated.
    var updatedAt: Date { get }

}

public enum EntityEnum {
    case deposit(Deposit)
    case incomingPayment(IncomingPayment)
    case invoice(Invoice)
    case outgoingPayment(OutgoingPayment)
    case wallet(Wallet)
    case withdrawal(Withdrawal)
    case withdrawalRequest(WithdrawalRequest)

}

extension EntityEnum: Decodable {
    private enum CodingKeys: String, CodingKey {
        case __typename
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let typename = try container.decode(String.self, forKey: .__typename)
        switch typename {
        case "Deposit":
            let deposit = try Deposit(from: decoder)
            self = .deposit(deposit)
        case "IncomingPayment":
            let incomingPayment = try IncomingPayment(from: decoder)
            self = .incomingPayment(incomingPayment)
        case "Invoice":
            let invoice = try Invoice(from: decoder)
            self = .invoice(invoice)
        case "OutgoingPayment":
            let outgoingPayment = try OutgoingPayment(from: decoder)
            self = .outgoingPayment(outgoingPayment)
        case "Wallet":
            let wallet = try Wallet(from: decoder)
            self = .wallet(wallet)
        case "Withdrawal":
            let withdrawal = try Withdrawal(from: decoder)
            self = .withdrawal(withdrawal)
        case "WithdrawalRequest":
            let withdrawalRequest = try WithdrawalRequest(from: decoder)
            self = .withdrawalRequest(withdrawalRequest)

        default:
            throw DecodingError.dataCorruptedError(
                forKey: .__typename,
                in: container,
                debugDescription: "Invalid typename"
            )
        }
    }
}
