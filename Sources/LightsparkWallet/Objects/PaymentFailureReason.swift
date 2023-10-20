// @generated
// This file was automatically generated and should not be edited.
// Copyright ©, 2023-present, Lightspark Group, Inc. - All Rights Reserved

/// This is an enum of the potential reasons why an OutgoingPayment sent from a Lightspark Node may have failed.
public enum PaymentFailureReason: String, Decodable {

    case none = "NONE"

    case timeout = "TIMEOUT"

    case noRoute = "NO_ROUTE"

    case error = "ERROR"

    case incorrectPaymentDetails = "INCORRECT_PAYMENT_DETAILS"

    case insufficientBalance = "INSUFFICIENT_BALANCE"

    case invoiceAlreadyPaid = "INVOICE_ALREADY_PAID"

    case selfPayment = "SELF_PAYMENT"

    case invoiceExpired = "INVOICE_EXPIRED"

    case riskScreeningFailed = "RISK_SCREENING_FAILED"
}
