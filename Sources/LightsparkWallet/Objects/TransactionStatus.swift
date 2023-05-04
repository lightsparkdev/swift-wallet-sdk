// @generated
// This file was automatically generated and should not be edited.
// Copyright ©, 2023-present, Lightspark Group, Inc. - All Rights Reserved

public enum TransactionStatus: String, Decodable {
    /// Transaction succeeded..
    case success = "SUCCESS"
    /// Transaction failed.
    case failed = "FAILED"
    /// Transaction has been initiated and is currently in-flight.
    case pending = "PENDING"
    /// For transaction type PAYMENT_REQUEST only. No payments have been made to a payment request.
    case notStarted = "NOT_STARTED"
    /// For transaction type PAYMENT_REQUEST only. A payment request has expired.
    case expired = "EXPIRED"
    /// For transaction type PAYMENT_REQUEST only.
    case cancelled = "CANCELLED"
}
