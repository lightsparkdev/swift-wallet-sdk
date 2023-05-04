// @generated
// This file was automatically generated and should not be edited.
// Copyright ©, 2023-present, Lightspark Group, Inc. - All Rights Reserved

public enum InvoiceType: String, Decodable {
    /// A standard Bolt 11 invoice.
    case standard = "STANDARD"
    /// An AMP (Atomic Multi-path Payment) invoice.
    case amp = "AMP"
}
