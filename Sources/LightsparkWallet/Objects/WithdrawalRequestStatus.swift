// @generated
// This file was automatically generated and should not be edited.
// Copyright ©, 2023-present, Lightspark Group, Inc. - All Rights Reserved

/// This is an enum of the potential statuses that a Withdrawal can take.
public enum WithdrawalRequestStatus: String, Decodable {

    case created = "CREATED"

    case failed = "FAILED"

    case inProgress = "IN_PROGRESS"

    case successful = "SUCCESSFUL"
}
