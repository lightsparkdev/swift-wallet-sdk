// @generated
// This file was automatically generated and should not be edited.
// Copyright ©, 2023-present, Lightspark Group, Inc. - All Rights Reserved

public enum WalletStatus: String, Decodable {
    /// The wallet has not been set up yet and is ready to be deployed. This is the default status after the first login.
    case notSetup = "NOT_SETUP"
    /// The wallet is currently being deployed in the Lightspark infrastructure.
    case deploying = "DEPLOYING"
    /// The wallet has been deployed in the Lightspark infrastructure and is ready to be initialized.
    case deployed = "DEPLOYED"
    /// The wallet is currently being initialized.
    case initializing = "INITIALIZING"
    /// The wallet is available and ready to be used.
    case ready = "READY"
    /// The wallet is temporarily available, due to a transient issue or a scheduled maintenance.
    case unavailable = "UNAVAILABLE"
    /// The wallet had an unrecoverable failure. This status is not expected to happend and will be investigated by the Lightspark team.
    case failed = "FAILED"
    /// The wallet is being terminated.
    case terminating = "TERMINATING"
    /// The wallet has been terminated and is not available in the Lightspark infrastructure anymore. It is not connected to the Lightning network and its funds can only be accessed using the Funds Recovery flow.
    case terminated = "TERMINATED"
}
