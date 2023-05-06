# Lightspark Wallet Swift SDK

This is a Swift Wallet SDK for the Lightspark Wallet APIs. It can be used from an iOS environment
to integrate with a Lightspark Lightning wallet.

## Installation

### Swift Package Manager
Lightspark Wallet SDK is compatible with Swift Package Manager v5 (Swift 5 and above). Simply add
it to the dependencies in your Package.swift.

```swift
dependencies: [
    .package(url: "https://github.com/lightsparkdev/swift-wallet-sdk.git", )
]
```
And then add it to your target dependencies:

```
targets: [
    .target(
        name: "MyProject",
        dependencies: [
            .product(name: "LightsparkWallet", package: "swift-wallet-sdk"),
        ]
    ),
    .testTarget(
        name: "MyProjectTests",
        dependencies: ["MyProject"])
]
```

After the installation you can import `LightsparkWallet` in your `.swift` files.

```swift
import LightsparkWallet
```

## Get started

The main entry point for the SDK is `WalletClient`. To initialize a `WalletClient`, an
authorization token is needed. The `authorization` field is the string to put in the http request
header's `authorization` field.

```swift
let walletClient = WalletClient(authorization: "Bearer \(accessToken)")
``` 

For each operation in the `WalletClient`, we provide 3 different ways to use it:
- Publisher: returns a publisher using the Swift Combine framework to emit the result.
- CompletionBlock: uses a completion block for callback.
- Swift async await function: uses Swift async await to return the result.

For example, to perform the operation `getCurrentWallet`, you can do

```swift
// Using publisher
var cancellables = [AnyCancellables]()
walletClient.getCurrentWalletPublisher()
    .sink() { completion in
        // handle completion
    } receiveValue { wallet in
        // handle result
    }
    .store(in: &cancellables)
}

// Using completion block
walletClient.getCurrentWallet() { wallet, error in
    // handle completion block
}

// Using async await
do {
    let wallet = try await walletClient.getCurrentWallet()
} catch {
    // handle error
}
```

## JWT Authentication

The current version of the SDK supports JWT authentication, which is intended for client-side use.
To authenticate, you'll need to login using your Lightspark account ID and
a JWT allocated for the user by your own server.

First, you'll need to register your account public key with Lightspark. You can do this from
the [Lightspark API Tokens page](https://app.lightspark.com/api-config). You'll need to provide the
public key for the account you want to use to sign JWTs. You can generate a keypair using the _
ES256_ algorithm using the following command:

```bash
openssl ecparam -genkey -name prime256v1 -noout -out private.key
```

This will generate a private key file called private.key. You can then generate the public key file
using the following command:

```bash
openssl ec -in private.key -pubout -out public.key
```

You can then copy the contents of the public key file into the "JWT Public Key" field on the API
Tokens page. You'll also want to copy the private key into your server code (or rather in secret
keystore or environment variable), so that you can use it to sign JWTs.

Next, you'll need to create a JWT for the user. You should expose an endpoint from your backend to
create these tokens. For example, to create a JWT from a typescript+node server:

```typescript
import * as jwt from "jsonwebtoken";

// Create a JSON object that contains the claims for your JWT.
const claims = {
  aud: "https://api.lightspark.com",
  // Any unique identifier for the user.
  sub: "511c7eb8-9afe-4f69-989a-8d1113a33f3d",
  // True to use the test environment, false to use the production environment.
  test: true,
  iat: 1516239022,
  // Expriation time for the JWT.
  exp: 1799393363,
};

// Call the `sign()` method on the `jsonwebtoken` library, passing in the JSON object and your private key.
const token = jwt.sign(claims, "your private key");

// Now send the token back to the client so that they can use it to authenticate with the Lightspark SDK.
```

Now on the client, you can login using the JWT and your company's account ID from the api tokens
page:

```swift
let authManager = JWTAuthManager(accountID: self.accountID, secret: self.walletToken)
authManager.login { accessToken, error in
    guard let access = access else {
		// handle error
        return
    }
    let walletClient = WalletClient(authorization: "Bearer \(accessToken)")
}
````

## Sample App
Please refer to the sample app in /DemoApp for more examples.
