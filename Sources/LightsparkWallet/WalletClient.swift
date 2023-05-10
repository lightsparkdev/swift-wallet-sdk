//
//  WalletClient.swift
//  LightsparkWallet
//
//  Created by Zhen Lu on 4/21/23.
//  Copyright © 2023 Lightspark Group, Inc. All rights reserved.
//

import Combine
import Foundation

public enum WalletClientError: Error {
    case emptyDataError
}

/// Lightspark Wallet Client
///
/// A Lightspark Wallet Client is used to interact with the Lightspark Wallet APIs.
/// For each operation, the client provides three ways to execute the request:
/// - A publisher that emits the result of the request or an error.
/// - A completion closure that will be called when the request is completed.
/// - A async function to execute the request.
public class WalletClient {
    /// Initialize the wallet client
    ///
    /// Parameter accessToken: The accessToken to send in the http header.
    /// Parameter baseURLString: The graphql endpoint base url. Will use default endpoint if not set.
    /// Parameter httpAdditionalHeaders: Addition header fields to put in the requests.
    public init(
        accessToken: String,
        baseURLString: String? = nil,
        httpAdditionalHeaders: [AnyHashable: Any]? = nil
    ) {
        self.requester = Requester(
            authorization: "Bearer \(accessToken)",
            baseURLString: baseURLString,
            httpAdditionalHeaders: httpAdditionalHeaders
        )
    }

    private let requester: Requester
}

/// Wallet related operations
extension WalletClient {
    /// Deploys a wallet in the Lightspark infrastructure. This is an asynchronous operation, the caller should then
    /// poll the wallet frequently (or subscribe to its modifications). When this process is over, the Wallet status
    /// will change to `DEPLOYED` (or `FAILED`).
    ///
    /// - Returns: A publisher that emits a `DeployWalletOutput` object or an error.
    ///
    public func deployWalletPublisher() -> AnyPublisher<DeployWalletOutput, Error> {
        return self.executeRequestPublisher(operation: Mutations.deployWallet)
    }

    /// Deploys a wallet in the Lightspark infrastructure. This is an asynchronous operation, the caller should then
    /// poll the wallet frequently (or subscribe to its modifications). When this process is over, the Wallet status
    /// will change to `DEPLOYED` (or `FAILED`).
    ///
    /// - Parameter completion: A closure that will be called when the request is completed.
    ///
    public func deployWallet(completion: @escaping (DeployWalletOutput?, Error?) -> Void) {
        self.executeRequest(operation: Mutations.deployWallet, completion: completion)
    }

    /// Deploys a wallet in the Lightspark infrastructure. This is an asynchronous operation, the caller should then
    /// poll the wallet frequently (or subscribe to its modifications). When this process is over, the Wallet status
    /// will change to `DEPLOYED` (or `FAILED`).
    ///
    /// - Returns: A `DeployWalletOutput` object.
    ///
    public func deployWallet() async throws -> DeployWalletOutput {
        return try await self.executeRequest(operation: Mutations.deployWallet)
    }

    /// Initializes a wallet in the Lightspark infrastructure and syncs it to the Bitcoin network. This is an
    /// asynchronous operation, the caller should then poll the wallet frequently (or subscribe to its modifications).
    /// When this process is over, the Wallet status will change to `READY` (or `FAILED`).
    ///
    /// - Parameter signingPublicKey: The public key of the wallet. The key is a RSA key.
    ///
    /// - Returns: A publisher that emits a `InitializeWalletOutput` object or an error.
    public func initializeWalletPublisher(signingPublicKey: SecKey) -> AnyPublisher<InitializeWalletOutput, Error> {
        let keyString: String
        do {
            keyString = try Keys.base64StringRepresentationForPublicKey(publicKey: signingPublicKey)
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }

        let variables = [
            "signing_public_key": keyString
        ]

        return self.executeRequestPublisher(operation: Mutations.initlizeWallet, variables: variables)
    }

    /// Initializes a wallet in the Lightspark infrastructure and syncs it to the Bitcoin network. This is an
    /// asynchronous operation, the caller should then poll the wallet frequently (or subscribe to its modifications).
    /// When this process is over, the Wallet status will change to `READY` (or `FAILED`).
    ///
    /// - Parameter signingPublicKey: The public key of the wallet. The key is a RSA key.
    /// - Parameter completion: A closure that will be called when the request is completed.
    public func initializeWallet(
        signingPublicKey: SecKey,
        completion: @escaping (InitializeWalletOutput?, Error?) -> Void
    ) {
        let keyString: String
        do {
            keyString = try Keys.base64StringRepresentationForPublicKey(publicKey: signingPublicKey)
        } catch {
            completion(nil, error)
            return
        }

        let variables = [
            "signing_public_key": keyString
        ]

        self.executeRequest(operation: Mutations.initlizeWallet, variables: variables, completion: completion)
    }

    /// Initializes a wallet in the Lightspark infrastructure and syncs it to the Bitcoin network. This is an
    /// asynchronous operation, the caller should then poll the wallet frequently (or subscribe to its modifications).
    /// When this process is over, the Wallet status will change to `READY` (or `FAILED`).
    ///
    /// - Parameter signingPublicKey: The public key of the wallet. The key is a RSA key.
    ///
    /// - Returns: A `InitializeWalletOutput` object.
    public func initializeWallet(signingPublicKey: SecKey) async throws -> InitializeWalletOutput {
        let keyString = try Keys.base64StringRepresentationForPublicKey(publicKey: signingPublicKey)
        let variables = [
            "signing_public_key": keyString
        ]

        return try await self.executeRequest(operation: Mutations.initlizeWallet, variables: variables)
    }

    /// Returns the wallet currently logged into the API.
    ///
    /// - Returns: A publisher that emits a `Wallet` object or an error.
    public func getCurrentWalletPublisher() -> AnyPublisher<Wallet, Error> {
        return self.executeRequestPublisher(operation: Queries.getCurrentWallet)
    }

    /// Returns the wallet currently logged into the API.
    ///
    /// - Parameter completion: A closure that will be called when the request is completed.
    public func getCurrentWallet(completion: @escaping (Wallet?, Error?) -> Void) {
        self.executeRequest(operation: Queries.getCurrentWallet, completion: completion)
    }

    /// Returns the wallet currently logged into the API.
    ///
    /// - Returns: A `Wallet` object.
    public func getCurrentWallet() async throws -> Wallet {
        return try await self.executeRequest(operation: Queries.getCurrentWallet)
    }

    /// Removes the wallet from Lightspark infrastructure. It won't be connected to the Lightning network anymore and
    /// its funds won't be accessible outside of the Funds Recovery Kit process.
    ///
    /// - Returns: A publisher that emits a `TerminateWalletOutput` object or an error.
    public func terminateWalletPublisher() -> AnyPublisher<TerminateWalletOutput, Error> {
        return self.executeRequestPublisher(operation: Mutations.terminateWallet)
    }

    /// Removes the wallet from Lightspark infrastructure. It won't be connected to the Lightning network anymore and
    /// its funds won't be accessible outside of the Funds Recovery Kit process.
    ///
    /// - Parameter completion: A closure that will be called when the request is completed.
    public func terminateWallet(completion: @escaping (TerminateWalletOutput?, Error?) -> Void) {
        self.executeRequest(operation: Mutations.terminateWallet, completion: completion)
    }

    /// Removes the wallet from Lightspark infrastructure. It won't be connected to the Lightning network anymore and
    /// its funds won't be accessible outside of the Funds Recovery Kit process.
    ///
    /// - Returns: A `TerminateWalletOutput` object.
    public func terminateWallet() async throws -> TerminateWalletOutput {
        return try await self.executeRequest(operation: Mutations.terminateWallet)
    }
}

/// L2 related operations
extension WalletClient {

    /// Generates a Lightning Invoice (follows the Bolt 11 specification) to request a payment from another Lightning
    /// Node.
    ///
    /// - Parameter amountMSats: The amount of the invoice in milli-satoshis.
    /// - Parameter memo: A memo to attach to the invoice.
    /// - Parameter invoiceType: The type of the invoice to generate.
    ///
    /// - Returns: A publisher that emits a `CreateInvoiceOutput` object or an error.
    public func createInvoicePublisher(
        amountMSats: Int64,
        memo: String?,
        invoiceType: InvoiceType = .standard
    ) -> AnyPublisher<CreateInvoiceOutput, Error> {
        let variables: [AnyHashable: Any?] = [
            "amount_msats": amountMSats,
            "memo": memo,
            "invoice_type": invoiceType.rawValue,
        ]
        return self.executeRequestPublisher(operation: Mutations.createInvoice, variables: variables)
    }

    /// Generates a Lightning Invoice (follows the Bolt 11 specification) to request a payment from another Lightning
    /// Node.
    ///
    /// - Parameter amountMSats: The amount of the invoice in milli-satoshis.
    /// - Parameter memo: A memo to attach to the invoice.
    /// - Parameter invoiceType: The type of the invoice to generate.
    /// - Parameter completion: A closure that will be called when the request is completed.
    public func createInvoice(
        amountMSats: Int64,
        memo: String?,
        invoiceType: InvoiceType = .standard,
        completion: @escaping (CreateInvoiceOutput?, Error?) -> Void
    ) {
        let variables: [AnyHashable: Any?] = [
            "amount_msats": amountMSats,
            "memo": memo,
            "invoice_type": invoiceType.rawValue,
        ]
        self.executeRequest(operation: Mutations.createInvoice, variables: variables, completion: completion)
    }

    /// Generates a Lightning Invoice (follows the Bolt 11 specification) to request a payment from another Lightning
    /// Node.
    ///
    /// - Parameter amountMSats: The amount of the invoice in milli-satoshis.
    /// - Parameter memo: A memo to attach to the invoice.
    /// - Parameter invoiceType: The type of the invoice to generate.
    ///
    /// - Returns: A `CreateInvoiceOutput` object.
    public func createInvoice(
        amountMSats: Int64,
        memo: String?,
        invoiceType: InvoiceType = .standard
    ) async throws -> CreateInvoiceOutput {
        let variables: [AnyHashable: Any?] = [
            "amount_msats": amountMSats,
            "memo": memo,
            "invoice_type": invoiceType.rawValue,
        ]
        return try await self.executeRequest(operation: Mutations.createInvoice, variables: variables)
    }

    /// Decodes the content of an encoded payment request into structured data that can be used by the client.
    ///
    /// - Parameter encodedPaymentRequest: The encoded payment request to decode.
    ///
    /// - Returns: A publisher that emits an `InvoiceData` object or an error.
    public func decodePaymentRequestPublisher(encodedPaymentRequest: String) -> AnyPublisher<InvoiceData, Error> {
        let variables = [
            "encoded_payment_request": encodedPaymentRequest
        ]
        return self.executeRequestPublisher(operation: Queries.decodePaymentRequest, variables: variables)
    }

    /// Decodes the content of an encoded payment request into structured data that can be used by the client.
    ///
    /// - Parameter encodedPaymentRequest: The encoded payment request to decode.
    /// - Parameter completion: A closure that will be called when the request is completed.
    public func decodePaymentRequest(
        encodedPaymentRequest: String,
        completion: @escaping (InvoiceData?, Error?) -> Void
    ) {
        let variables = [
            "encoded_payment_request": encodedPaymentRequest
        ]
        self.executeRequest(operation: Queries.decodePaymentRequest, variables: variables, completion: completion)
    }

    /// Decodes the content of an encoded payment request into structured data that can be used by the client.
    ///
    /// - Parameter encodedPaymentRequest: The encoded payment request to decode.
    ///
    /// - Returns: An `InvoiceData` object.
    public func decodePaymentRequest(encodedPaymentRequest: String) async throws -> InvoiceData {
        let variables = [
            "encoded_payment_request": encodedPaymentRequest
        ]
        return try await self.executeRequest(operation: Queries.decodePaymentRequest, variables: variables)
    }

    /// Sends a payment to a node on the Lightning Network, based on the invoice (as defined by the BOLT11
    /// specification) that you provide.
    ///
    /// - Parameter encodedInvoice: The encoded invoice to pay.
    /// - Parameter amountMSats: The amount of the invoice in milli-satoshis. Should be set to nil if the invoice already contains the amount.
    /// - Parameter maximumFeeMSats: The maximum fee in milli-satoshis that you are willing to pay for this payment.
    /// - Parameter timeout: The timeout in seconds for the payment.
    /// - Parameter signingKey: The private key to use to sign the payment.
    ///
    /// - Returns: A publisher that emits a `PayInvoiceOutput` object or an error.
    public func payInvoicePublisher(
        encodedInvoice: String,
        amountMSats: Int64?,
        maximumFeeMSats: Int64,
        timeout: Int,
        signingKey: SecKey
    ) -> AnyPublisher<PayInvoiceOutput, Error> {
        var variables: [AnyHashable: Any?] = [
            "encoded_invoice": encodedInvoice,
            "timeout_secs": timeout,
            "maximum_fees_msats": maximumFeeMSats,
        ]
        if let amountMSats = amountMSats {
            variables["amount_msats"] = amountMSats
        }
        return self.executeRequestPublisher(
            operation: Mutations.payInvoice,
            variables: variables,
            signingKey: signingKey
        )
    }

    /// Sends a payment to a node on the Lightning Network, based on the invoice (as defined by the BOLT11
    /// specification) that you provide.
    ///
    /// - Parameter encodedInvoice: The encoded invoice to pay.
    /// - Parameter amountMSats: The amount of the invoice in milli-satoshis. Should be set to nil if the invoice already contains the amount.
    /// - Parameter maximumFeeMSats: The maximum fee in milli-satoshis that you are willing to pay for this payment.
    /// - Parameter timeout: The timeout in seconds for the payment.
    /// - Parameter signingKey: The private key to use to sign the payment.
    /// - Parameter completion: A closure that will be called when the request is completed.
    public func payInvoice(
        encodedInvoice: String,
        amountMSats: Int64?,
        maximumFeeMSats: Int64,
        timeout: Int,
        signingKey: SecKey,
        completion: @escaping (PayInvoiceOutput?, Error?) -> Void
    ) {
        var variables: [AnyHashable: Any?] = [
            "encoded_invoice": encodedInvoice,
            "timeout_secs": timeout,
            "maximum_fees_msats": maximumFeeMSats,
        ]
        if let amountMSats = amountMSats {
            variables["amount_msats"] = amountMSats
        }
        return self.executeRequest(
            operation: Mutations.payInvoice,
            variables: variables,
            signingKey: signingKey,
            completion: completion
        )
    }

    /// Sends a payment to a node on the Lightning Network, based on the invoice (as defined by the BOLT11
    /// specification) that you provide.
    ///
    /// - Parameter encodedInvoice: The encoded invoice to pay.
    /// - Parameter amountMSats: The amount of the invoice in milli-satoshis. Should be set to nil if the invoice already contains the amount.
    /// - Parameter maximumFeeMSats: The maximum fee in milli-satoshis that you are willing to pay for this payment.
    /// - Parameter timeout: The timeout in seconds for the payment.
    /// - Parameter signingKey: The private key to use to sign the payment.
    ///
    /// - Returns: A `PayInvoiceOutput` object.
    public func payInvoice(
        encodedInvoice: String,
        amountMSats: Int64?,
        maximumFeeMSats: Int64,
        timeout: Int,
        signingKey: SecKey
    ) async throws -> PayInvoiceOutput {
        var variables: [AnyHashable: Any?] = [
            "encoded_invoice": encodedInvoice,
            "timeout_secs": timeout,
            "maximum_fees_msats": maximumFeeMSats,
        ]
        if let amountMSats = amountMSats {
            variables["amount_msats"] = amountMSats
        }
        return try await self.executeRequest(
            operation: Mutations.payInvoice,
            variables: variables,
            signingKey: signingKey
        )
    }

    /// Sends a payment directly to a node on the Lightning Network through the public key of the node without an
    /// invoice.
    ///
    /// - Parameter destinationPublicKey: The public key of the node to send the payment to.
    /// - Parameter amountMSats: The amount of the payment in milli-satoshis.
    /// - Parameter maximumFeeMSats: The maximum fee in milli-satoshis that you are willing to pay for this payment.
    /// - Parameter timeout: The timeout in seconds for the payment.
    /// - Parameter signingKey: The private key to use to sign the payment.
    ///
    /// - Returns: A publisher that emits a `PayInvoiceOutput` object or an error.
    public func sendPaymentPublisher(
        destinationPublicKey: String,
        amountMSats: Int64,
        maximumFeeMSats: Int64,
        timeout: Int,
        signingKey: SecKey
    ) -> AnyPublisher<PayInvoiceOutput, Error> {
        let variables: [AnyHashable: Any?] = [
            "destination_public_key": destinationPublicKey,
            "amount_msats": amountMSats,
            "timeout_secs": timeout,
            "maximum_fees_msats": maximumFeeMSats,
        ]
        return self.executeRequestPublisher(
            operation: Mutations.sendPayment,
            variables: variables,
            signingKey: signingKey
        )
    }

    /// Sends a payment directly to a node on the Lightning Network through the public key of the node without an
    /// invoice.
    ///
    /// - Parameter destinationPublicKey: The public key of the node to send the payment to.
    /// - Parameter amountMSats: The amount of the payment in milli-satoshis.
    /// - Parameter maximumFeeMSats: The maximum fee in milli-satoshis that you are willing to pay for this payment.
    /// - Parameter timeout: The timeout in seconds for the payment.
    /// - Parameter signingKey: The private key to use to sign the payment.
    /// - Parameter completion: A closure that will be called when the request is completed.
    public func sendPayment(
        destinationPublicKey: String,
        amountMSats: Int64,
        maximumFeeMSats: Int64,
        timeout: Int,
        signingKey: SecKey,
        completion: @escaping (PayInvoiceOutput?, Error?) -> Void
    ) {
        let variables: [AnyHashable: Any?] = [
            "destination_public_key": destinationPublicKey,
            "amount_msats": amountMSats,
            "timeout_secs": timeout,
            "maximum_fees_msats": maximumFeeMSats,
        ]
        self.executeRequest(
            operation: Mutations.sendPayment,
            variables: variables,
            signingKey: signingKey,
            completion: completion
        )
    }

    /// Sends a payment directly to a node on the Lightning Network through the public key of the node without an
    /// invoice.
    ///
    /// - Parameter destinationPublicKey: The public key of the node to send the payment to.
    /// - Parameter amountMSats: The amount of the payment in milli-satoshis.
    /// - Parameter maximumFeeMSats: The maximum fee in milli-satoshis that you are willing to pay for this payment.
    /// - Parameter timeout: The timeout in seconds for the payment.
    /// - Parameter signingKey: The private key to use to sign the payment.
    ///
    /// - Returns: A `PayInvoiceOutput` object.
    public func sendPayment(
        destinationPublicKey: String,
        amountMSats: Int64,
        maximumFeeMSats: Int64,
        timeout: Int,
        signingKey: SecKey
    ) async throws -> PayInvoiceOutput {
        let variables: [AnyHashable: Any?] = [
            "destination_public_key": destinationPublicKey,
            "amount_msats": amountMSats,
            "timeout_secs": timeout,
            "maximum_fees_msats": maximumFeeMSats,
        ]
        return try await self.executeRequest(
            operation: Mutations.sendPayment,
            variables: variables,
            signingKey: signingKey
        )
    }

    /// Returns an estimate of the fees that will be paid to send a payment to a Lightning node.
    ///
    /// - Parameter destinationPublicKey: The public key of the node to send the payment to.
    /// - Parameter amountMSats: The amount of the payment in milli-satoshis.
    ///
    /// - Returns: A publisher that emits a `LightningFeeEstimateOutput` object or an error.
    public func lightningFeeEstimateForNodePublisher(
        destinationPublicKey: String,
        amountMSats: Int64
    ) -> AnyPublisher<LightningFeeEstimateOutput, Error> {
        let variables: [AnyHashable: Any] = [
            "destination_node_public_key": destinationPublicKey,
            "amount_msats": amountMSats,
        ]

        return self.executeRequestPublisher(operation: Queries.lightningFeeEstimateForNode, variables: variables)
    }

    /// Returns an estimate of the fees that will be paid to send a payment to a Lightning node.
    ///
    /// - Parameter destinationPublicKey: The public key of the node to send the payment to.
    /// - Parameter amountMSats: The amount of the payment in milli-satoshis.
    /// - Parameter completion: A closure that will be called when the request is completed.
    public func lightningFeeEstimateForNode(
        destinationPublicKey: String,
        amountMSats: Int64,
        completion: @escaping (LightningFeeEstimateOutput?, Error?) -> Void
    ) {
        let variables: [AnyHashable: Any] = [
            "destination_node_public_key": destinationPublicKey,
            "amount_msats": amountMSats,
        ]

        self.executeRequest(
            operation: Queries.lightningFeeEstimateForNode,
            variables: variables,
            completion: completion
        )
    }

    /// Returns an estimate of the fees that will be paid to send a payment to a Lightning node.
    ///
    /// - Parameter destinationPublicKey: The public key of the node to send the payment to.
    /// - Parameter amountMSats: The amount of the payment in milli-satoshis.
    ///
    /// - Returns: A `LightningFeeEstimateOutput` object.
    public func lightningFeeEstimateForNode(
        destinationPublicKey: String,
        amountMSats: Int64
    ) async throws -> LightningFeeEstimateOutput {
        let variables: [AnyHashable: Any] = [
            "destination_node_public_key": destinationPublicKey,
            "amount_msats": amountMSats,
        ]

        return try await self.executeRequest(operation: Queries.lightningFeeEstimateForNode, variables: variables)
    }

    /// Returns an estimate of the fees that will be paid for a Lightning invoice.
    ///
    /// - Parameter encodedPaymentRequest: The encoded payment request for the invoice.
    /// - Parameter amountMSats: The amount of the payment in milli-satoshis.
    ///
    /// - Returns: A publisher that emits a `LightningFeeEstimateOutput` object or an error.
    public func lightningFeeEstimateForInvoicePublisher(
        encodedPaymentRequest: String,
        amountMSats: Int64?
    ) -> AnyPublisher<LightningFeeEstimateOutput, Error> {
        var variables: [AnyHashable: Any] = [
            "encoded_payment_request": encodedPaymentRequest,
        ]
        if let amountMSats = amountMSats {
            variables["amount_msats"] = amountMSats
        }

        return self.executeRequestPublisher(operation: Queries.lightningFeeEstimateForInvoice, variables: variables)
    }

    /// Returns an estimate of the fees that will be paid for a Lightning invoice.
    ///
    /// - Parameter encodedPaymentRequest: The encoded payment request for the invoice.
    /// - Parameter amountMSats: The amount of the payment in milli-satoshis.
    /// - Parameter completion: A closure that will be called when the request is completed.
    public func lightningFeeEstimateForInvoice(
        encodedPaymentRequest: String,
        amountMSats: Int64?,
        completion: @escaping (LightningFeeEstimateOutput?, Error?) -> Void
    ) {
        var variables: [AnyHashable: Any] = [
            "encoded_payment_request": encodedPaymentRequest,
        ]
        if let amountMSats = amountMSats {
            variables["amount_msats"] = amountMSats
        }

        self.executeRequest(
            operation: Queries.lightningFeeEstimateForInvoice,
            variables: variables,
            completion: completion
        )
    }

    /// Returns an estimate of the fees that will be paid for a Lightning invoice.
    ///
    /// - Parameter encodedPaymentRequest: The encoded payment request for the invoice.
    /// - Parameter amountMSats: The amount of the payment in milli-satoshis.
    ///
    /// - Returns: A `LightningFeeEstimateOutput` object.
    public func lightningFeeEstimateForInvoice(
        encodedPaymentRequest: String,
        amountMSats: Int64?
    ) async throws -> LightningFeeEstimateOutput {
        var variables: [AnyHashable: Any] = [
            "encoded_payment_request": encodedPaymentRequest,
        ]
        if let amountMSats = amountMSats {
            variables["amount_msats"] = amountMSats
        }

        return try await self.executeRequest(operation: Queries.lightningFeeEstimateForInvoice, variables: variables)
    }
}

/// L1 related operations
extension WalletClient {
    /// Returns an estimate of the fees of a transaction on the Bitcoin Network.
    ///
    /// - Returns: A publisher that emits a `FeeEstimate` object or an error.
    public func bitcoinFeeEstimatePublisher() -> AnyPublisher<FeeEstimate, Error> {
        return self.executeRequestPublisher(operation: Queries.bitcoinFeeEstimate)
    }

    /// Returns an estimate of the fees of a transaction on the Bitcoin Network.
    ///
    /// - Parameter completion: A closure that will be called when the request is completed.
    public func bitcoinFeeEstimate(completion: @escaping (FeeEstimate?, Error?) -> Void) {
        self.executeRequest(operation: Queries.bitcoinFeeEstimate, completion: completion)
    }

    /// Returns an estimate of the fees of a transaction on the Bitcoin Network.
    ///
    /// - Returns: A `FeeEstimate` object.
    public func bitcoinFeeEstimate() async throws -> FeeEstimate {
        return try await self.executeRequest(operation: Queries.bitcoinFeeEstimate)
    }

    /// Withdraws funds from the account and sends it to the requested bitcoin address.
    ///
    /// The process is asynchronous and may take up to a few minutes. You can check the progress by polling the
    /// `WithdrawalRequest` that is created, or by subscribing to a webhook.
    ///
    /// - Parameter bitcoinAddress: The bitcoin address to send the funds to.
    /// - Parameter amountSats: The amount of the withdrawal in satoshis.
    /// - Parameter signingKey: The private key to sign the request with.
    ///
    /// - Returns: A publisher that emits a `RequestWithdrawalOutput` object or an error.
    public func requestWithdrawalPublisher(
        bitcoinAddress: String,
        amountSats: Int64,
        signingKey: SecKey
    ) -> AnyPublisher<RequestWithdrawalOutput, Error> {
        let variables: [AnyHashable: Any?] = [
            "bitcoin_address": bitcoinAddress,
            "amount_sats": amountSats,
        ]

        return self.executeRequestPublisher(
            operation: Mutations.requestWithdrawal,
            variables: variables,
            signingKey: signingKey
        )
    }

    /// Withdraws funds from the account and sends it to the requested bitcoin address.
    ///
    /// The process is asynchronous and may take up to a few minutes. You can check the progress by polling the
    /// `WithdrawalRequest` that is created, or by subscribing to a webhook.
    ///
    /// - Parameter bitcoinAddress: The bitcoin address to send the funds to.
    /// - Parameter amountSats: The amount of the withdrawal in satoshis.
    /// - Parameter signingKey: The private key to sign the request with.
    /// - Parameter completion: A closure that will be called when the request is completed.
    public func requestWithdrawal(
        bitcoinAddress: String,
        amountSats: Int64,
        signingKey: SecKey,
        completion: @escaping (RequestWithdrawalOutput?, Error?) -> Void
    ) {
        let variables: [AnyHashable: Any?] = [
            "bitcoin_address": bitcoinAddress,
            "amount_sats": amountSats,
        ]

        self.executeRequest(
            operation: Mutations.requestWithdrawal,
            variables: variables,
            signingKey: signingKey,
            completion: completion
        )
    }

    /// Withdraws funds from the account and sends it to the requested bitcoin address.
    ///
    /// The process is asynchronous and may take up to a few minutes. You can check the progress by polling the
    /// `WithdrawalRequest` that is created, or by subscribing to a webhook.
    ///
    /// - Parameter bitcoinAddress: The bitcoin address to send the funds to.
    /// - Parameter amountSats: The amount of the withdrawal in satoshis.
    /// - Parameter signingKey: The private key to sign the request with.
    ///
    /// - Returns: A `RequestWithdrawalOutput` object.
    public func requestWithdrawal(
        bitcoinAddress: String,
        amountSats: Int64,
        signingKey: SecKey
    ) async throws -> RequestWithdrawalOutput {
        let variables: [AnyHashable: Any?] = [
            "bitcoin_address": bitcoinAddress,
            "amount_sats": amountSats,
        ]

        return try await self.executeRequest(
            operation: Mutations.requestWithdrawal,
            variables: variables,
            signingKey: signingKey
        )
    }

    /// Creates a Bitcoin address for this wallet. You can use this address to send funds to your wallet on the Bitcoin
    /// network. It is a best practice to generate a new wallet address every time you need to send money. You can
    /// generate as many wallet addresses as you want.
    ///
    /// - Returns: A publisher that emits a `CreateBitcoinFundingAddressOutput` object or an error.
    public func createBitcoinFundingAddressPublisher() -> AnyPublisher<CreateBitcoinFundingAddressOutput, Error> {
        return self.executeRequestPublisher(operation: Mutations.createBitcoinFundingAddress)
    }

    /// Creates a Bitcoin address for this wallet. You can use this address to send funds to your wallet on the Bitcoin
    /// network. It is a best practice to generate a new wallet address every time you need to send money. You can
    /// generate as many wallet addresses as you want.
    ///
    /// - Parameter completion: A closure that will be called when the request is completed.
    public func createBitcoinFundingAddress(
        completion: @escaping (
            CreateBitcoinFundingAddressOutput?,
            Error?
        ) -> Void
    ) {
        self.executeRequest(operation: Mutations.createBitcoinFundingAddress, completion: completion)
    }

    /// Creates a Bitcoin address for this wallet. You can use this address to send funds to your wallet on the Bitcoin
    /// network. It is a best practice to generate a new wallet address every time you need to send money. You can
    /// generate as many wallet addresses as you want.
    ///
    /// - Returns: A `CreateBitcoinFundingAddressOutput` object.
    public func createBitcoinFundingAddress() async throws -> CreateBitcoinFundingAddressOutput {
        return try await self.executeRequest(operation: Mutations.createBitcoinFundingAddress)
    }
}

// Entity queries
extension WalletClient {
    /// Returns a publisher that emits an entity of type `T` or an error.
    ///
    /// - Parameter id: the id of the entity to fetch.
    ///
    /// - Returns: A publisher that emits an entity of type `T` or an error.
    public func getEntityPublisher<T: Entity>(id: String) -> AnyPublisher<T, Error> {
        let variables = [
            "id": id
        ]

        return self.executeRequestPublisher(operation: self.entityQuery(T.self), variables: variables)
    }

    /// Returns an entity of type `T` or an error.
    ///
    /// - Parameter id: the id of the entity to fetch.
    /// - Parameter completion: A closure that will be called when the request is completed.
    public func getEntity<T: Entity>(id: String, completion: @escaping (T?, Error?) -> Void) {
        let variables = [
            "id": id
        ]

        return self.executeRequest(operation: self.entityQuery(T.self), variables: variables, completion: completion)
    }

    /// Returns an entity of type `T` or an error.
    ///
    /// - Parameter id: the id of the entity to fetch.
    ///
    /// - Returns: An entity of type `T`.
    public func getEntity<T: Entity>(id: String) async throws -> T {
        let variables = [
            "id": id
        ]

        return try await self.executeRequest(operation: self.entityQuery(T.self), variables: variables)
    }

    private func entityQuery(_ t: Entity.Type) -> String {
        """
        query getEntity($id: String!) {
            entity(id: $id) {
                ...\(String(describing: t))Fragment
            }
        }

        \(t.fragment)
        """
    }
}

// Transactions and payment requests
extension WalletClient {
    /// Performs a fetch for the transactions of this wallet.
    ///
    /// - Parameter first: The number of transactions to fetch.
    /// - Parameter after: Fetch transactions after this cursor.
    /// - Parameter afterDate: Fetch transactions after this date.
    /// - Parameter beforeDate: Fetch transactions before this date.
    /// - Parameter status: Fetch transactions with this status.
    /// - Parameter types: Fetch transactions with this type.
    ///
    /// - Returns: A publisher that emits a list of `WalletToTransactionsConnection` objects or an error.
    public func fetchTransactionsPublisher(
        first: Int? = nil,
        after: String? = nil,
        afterDate: Date? = nil,
        beforeDate: Date? = nil,
        status: [TransactionStatus]? = nil,
        types: [TransactionType]? = nil
    ) -> AnyPublisher<WalletToTransactionsConnection, Error> {
        let variables = self.transactionQueryVariables(
            first: first,
            after: after,
            afterDate: afterDate,
            beforeDate: beforeDate,
            status: status,
            types: types
        )
        return self.executeRequestPublisher(operation: Wallet.transactionsQuery, variables: variables)
    }

    /// Performs a fetch for the transactions of this wallet.
    ///
    /// - Parameter first: The number of transactions to fetch.
    /// - Parameter after: Fetch transactions after this cursor.
    /// - Parameter afterDate: Fetch transactions after this date.
    /// - Parameter beforeDate: Fetch transactions before this date.
    /// - Parameter status: Fetch transactions with this status.
    /// - Parameter types: Fetch transactions with this type.
    /// - Parameter completion: A closure that will be called when the request is completed.
    public func fetchTransactions(
        first: Int? = nil,
        after: String? = nil,
        afterDate: Date? = nil,
        beforeDate: Date? = nil,
        status: [TransactionStatus]? = nil,
        types: [TransactionType]? = nil,
        completion: @escaping (WalletToTransactionsConnection?, Error?) -> Void
    ) {
        let variables = self.transactionQueryVariables(
            first: first,
            after: after,
            afterDate: afterDate,
            beforeDate: beforeDate,
            status: status,
            types: types
        )
        return self.executeRequest(operation: Wallet.transactionsQuery, variables: variables, completion: completion)
    }

    /// Performs a fetch for the transactions of this wallet.
    ///
    /// - Parameter first: The number of transactions to fetch.
    /// - Parameter after: Fetch transactions after this cursor.
    /// - Parameter afterDate: Fetch transactions after this date.
    /// - Parameter beforeDate: Fetch transactions before this date.
    /// - Parameter status: Fetch transactions with this status.
    /// - Parameter types: Fetch transactions with this type.
    ///
    /// - Returns: A list of `WalletToTransactionsConnection` objects.
    public func fetchTransactions(
        first: Int? = nil,
        after: String? = nil,
        afterDate: Date? = nil,
        beforeDate: Date? = nil,
        status: [TransactionStatus]? = nil,
        types: [TransactionType]? = nil
    ) async throws -> WalletToTransactionsConnection {
        let variables = self.transactionQueryVariables(
            first: first,
            after: after,
            afterDate: afterDate,
            beforeDate: beforeDate,
            status: status,
            types: types
        )
        return try await self.executeRequest(operation: Wallet.transactionsQuery, variables: variables)
    }

    /// Performs a fetch for the payment requests of this wallet.
    ///
    /// - Parameter first: The number of transactions to fetch.
    /// - Parameter after: Fetch transactions after this cursor.
    /// - Parameter afterDate: Fetch transactions after this date.
    /// - Parameter beforeDate: Fetch transactions before this date.
    ///
    /// - Returns: A publisher that emits a list of `WalletToPaymentRequestsConnection` objects or an error.
    public func fetchPaymentRequestPublisher(
        first: Int? = nil,
        after: String? = nil,
        afterDate: Date? = nil,
        beforeDate: Date? = nil
    ) -> AnyPublisher<WalletToPaymentRequestsConnection, Error> {
        let variables = self.paymentRequestQueryVariables(
            first: first,
            after: after,
            afterDate: afterDate,
            beforeDate: beforeDate
        )
        return self.executeRequestPublisher(operation: Wallet.paymentRequestsQuery, variables: variables)
    }

    /// Performs a fetch for the payment requests of this wallet.
    ///
    /// - Parameter first: The number of transactions to fetch.
    /// - Parameter after: Fetch transactions after this cursor.
    /// - Parameter afterDate: Fetch transactions after this date.
    /// - Parameter beforeDate: Fetch transactions before this date.
    /// - Parameter completion: A closure that will be called when the request is completed.
    public func fetchPaymentRequest(
        first: Int? = nil,
        after: String? = nil,
        afterDate: Date? = nil,
        beforeDate: Date? = nil,
        completion: @escaping (WalletToTransactionsConnection?, Error?) -> Void
    ) {
        let variables = self.paymentRequestQueryVariables(
            first: first,
            after: after,
            afterDate: afterDate,
            beforeDate: beforeDate
        )
        return self.executeRequest(operation: Wallet.paymentRequestsQuery, variables: variables, completion: completion)
    }

    /// Performs a fetch for the payment requests of this wallet.
    ///
    /// - Parameter first: The number of transactions to fetch.
    /// - Parameter after: Fetch transactions after this cursor.
    /// - Parameter afterDate: Fetch transactions after this date.
    /// - Parameter beforeDate: Fetch transactions before this date.
    ///
    /// - Returns: A list of `WalletToPaymentRequestsConnection` objects or an error.
    public func fetchPaymentRequest(
        first: Int? = nil,
        after: String? = nil,
        afterDate: Date? = nil,
        beforeDate: Date? = nil
    ) async throws -> WalletToTransactionsConnection {
        let variables = self.paymentRequestQueryVariables(
            first: first,
            after: after,
            afterDate: afterDate,
            beforeDate: beforeDate
        )
        return try await self.executeRequest(operation: Wallet.paymentRequestsQuery, variables: variables)
    }

    private func transactionQueryVariables(
        first: Int? = nil,
        after: String? = nil,
        afterDate: Date? = nil,
        beforeDate: Date? = nil,
        status: [TransactionStatus]? = nil,
        types: [TransactionType]? = nil
    ) -> [AnyHashable: Any?] {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return [
            "first": first,
            "after": after,
            "created_after_date": afterDate.map { formatter.string(from: $0) },
            "created_before_date": beforeDate.map { formatter.string(from: $0) },
            "status": status?.map { $0.rawValue },
            "types": types?.map { $0.rawValue },
        ]
    }

    private func paymentRequestQueryVariables(
        first: Int? = nil,
        after: String? = nil,
        afterDate: Date? = nil,
        beforeDate: Date? = nil
    ) -> [AnyHashable: Any?] {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return [
            "first": first,
            "after": after,
            "created_after_date": afterDate.map { formatter.string(from: $0) },
            "created_before_date": beforeDate.map { formatter.string(from: $0) },
        ]
    }
}

// Execute graphql
extension WalletClient {
    public func executeRequest<T: Decodable>(
        operation: String,
        variables: [AnyHashable: Any?] = [:],
        signingKey: SecKey? = nil,
        completion: @escaping (T?, Error?) -> Void
    ) {
        self.requester.executeGraphQLOperation(
            operation: operation,
            variables: variables,
            signingKey: signingKey
        ) { data, error in
            if let error = error {
                completion(nil, error)
                return
            }

            guard let data = data else {
                completion(nil, WalletClientError.emptyDataError)
                return
            }

            do {
                let response = try JSONDecoder.lightsparkJSONDecoder().decode(Response<T>.self, from: data)
                if let data = response.data {
                    completion(data, nil)
                } else {
                    completion(nil, WalletClientError.emptyDataError)
                }
            } catch {
                completion(nil, error)
            }
        }
    }

    public func executeRequest<T: Decodable>(
        operation: String,
        variables: [AnyHashable: Any?] = [:],
        signingKey: SecKey? = nil
    ) async throws -> T {
        let data = try await self.requester.executeGraphQLOperation(
            operation: operation,
            variables: variables,
            signingKey: signingKey
        )
        let response = try JSONDecoder.lightsparkJSONDecoder().decode(Response<T>.self, from: data)
        if let data = response.data {
            return data
        } else {
            throw WalletClientError.emptyDataError
        }
    }

    public func executeRequestPublisher<T: Decodable>(
        operation: String,
        variables: [AnyHashable: Any?] = [:],
        signingKey: SecKey? = nil
    )
        -> AnyPublisher<T, Error>
    {
        return self.requester.executeGraphQLOperationPublisher(
            operation: operation,
            variables: variables,
            signingKey: signingKey
        )
        .tryMap { data in
            let response = try JSONDecoder.lightsparkJSONDecoder().decode(Response<T>.self, from: data)
            if let data = response.data {
                return data
            } else {
                if let error = response.errors?.first {
                    throw error
                }
                throw WalletClientError.emptyDataError
            }
        }
        .eraseToAnyPublisher()
    }
}
