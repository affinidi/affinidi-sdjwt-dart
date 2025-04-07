# API Reference

## Table of Contents

- [SdJwtHandler](#sdjwthandler)
- [SdJwt](#sdjwt)
- [Keys and Signing](#keys-and-signing)
- [Verification](#verification)

## SdJwtHandler

The main interface for SD-JWT operations:

- `sign()` - Signs claims with selective disclosure capabilities
- `present()` - Creates a presentation from an existing SD-JWT
- `verify()` - Verifies an SD-JWT and its disclosures
- `decodeAndVerify()` - Decodes a serialized SD-JWT string and verifies it in one step. This is the recommended method for processing received SD-JWTs when you have the issuer's public key.
- `unverifiedDecode()` - Decodes a serialized SD-JWT string without verifying the signature. Use this when you need to inspect an SD-JWT's contents before verification, such as when building UIs to display available disclosures.

## SdJwt

Represents a Selective Disclosure JWT:

- Properties:
  - `serialized` - The serialized string representation
  - `payload` - The decoded payload
  - `claims` - The complete set of claims after applying all disclosures
  - `disclosures` - The set of all disclosures
  - `jwsString` - The JWT part of the SD-JWT
  - `kbString` - The Key Binding JWT part (if present)

## Keys and Signing

- `SdPrivateKey` - Represents a private key for signing
- `SdPublicKey` - Represents a public key for verification
- `SDKeySigner` - Implements signing using SD-JWT keys
- `SDKeyVerifier` - Implements verification using SD-JWT keys
- `SdJwtSignAlgorithm` - Supported signing algorithms:
  - `es256` - ECDSA using P-256 curve and SHA-256
  - `es256k` - ECDSA using secp256k1 curve and SHA-256
  - `rs256` - RSASSA-PKCS1-v1_5 using SHA-256
  - `hs256` - HMAC using SHA-256
  - And more including `rs384`, `rs512`, `es384`, `es512`, `hs384`, and `hs512`

## Verification

- `SdJwtVerifierOutput` - Contains the result of verification
  - `isVerified` - Whether the SD-JWT was successfully verified
  - `isKbJwtVerified` - Whether key binding JWT was verified