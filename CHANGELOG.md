# Changelog

# v1.4.0
- The default AuthStateStorage implementation is replaced with a keychain backed storage class.

# v1.3.0
- Use GraphQL subscription for `WalletStatusListener` and `TransactionStatusListener`.
    - `WalletStatusListener` initialization throws error.
- Add crypto operations.

# v1.2.2
- Fix TransactionStatusListener

# v1.2.1
- Use CSPRNG for nonce generation.

# v1.2.0
- Add async/await and completion handler functions for JWTAuthManager.
- Improve WalletStatusListener to automatically stop when the wallet is ready.
- Add test mode operations: CreateTestModeInvoice and CreateTestModePayment.

# v1.1.0

- Make `initialize_wallet` a signed operation.
- Add missing transactions types.
- Provide remove key in Crypto utilities.

# v1.0.0

- First version of swift wallet SDK.
