// @generated
// This file was automatically generated and should not be edited.
// Copyright ©, 2023-present, Lightspark Group, Inc. - All Rights Reserved

/// This is an enum of the potential states that a payment request on the Lightning Network can take.
public enum PaymentRequestStatus: String, Decodable {

    case open = "OPEN"

    case closed = "CLOSED"
}
