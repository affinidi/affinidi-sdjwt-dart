# SD-JWT for Dart

[![Dart SDK Version](https://img.shields.io/badge/dart-%3E%3D3.6.0-blue.svg)](https://dart.dev)
[![License: Apache](https://img.shields.io/badge/license-Apache%202.0-blue)](LICENSE)

The SD-JWT for Dart package provides libraries and tools to enable selective disclosure, enhancing security and privacy in the data-sharing process. It implements the IETF's [Selective Disclosure for JWTs (SD-JWT)](https://datatracker.ietf.org/doc/draft-ietf-oauth-selective-disclosure-jwt/) specification. 

The SD-JWT for Dart package enables:

- **Issuer** to create JWTs with selectively disclosable claims.
- **Holder** to present only specific claims to verifiers.
- **Verifier** to validate the authenticity of the presented claims.
- **Key binding** to prevent unauthorized presentations.

> **IMPORTANT:** 
> This project does not collect or process any personal data. However, when used as part of a broader system or application that handles personally identifiable information (PII), users are responsible for ensuring that any such use complies with applicable privacy laws and data protection obligations.

## Table of Contents

- [SD-JWT for Dart](#sd-jwt-for-dart)
  - [Table of Contents](#table-of-contents)
  - [Core Concepts](#core-concepts)
  - [Supported Algorithms](#supported-algorithms)
  - [Requirements](#requirements)
  - [Installation](#installation)
  - [Usage](#usage)
  - [API Reference](#api-reference)
  - [Support \& feedback](#support--feedback)
    - [Reporting technical issues](#reporting-technical-issues)
  - [Contributing](#contributing)

## Core Concepts

SD-JWT introduces several key concepts:

- **Selective Disclosure**: Claims can be selectively disclosed based on need
- **Cryptographic Binding**: Claims are cryptographically bound to the JWT
- **Key Binding**: Ensures only the intended holder can present the SD-JWT
- **Disclosures**: Individual pieces of information that can be selectively shared

## Supported Algorithms

The package supports the following signing algorithms:

- `ES256` - ECDSA using P-256 curve and SHA-256
- `ES256K` - ECDSA using secp256k1 curve and SHA-256
- `RS256` - RSASSA-PKCS1-v1_5 using SHA-256
- `HS256` - HMAC using SHA-256
- Additional algorithms: `RS384`, `RS512`, `ES384`, `ES512`, `HS384`, and `HS512`

For hash calculation in disclosures:

- `SHA-256` (default)
- `SHA-384`
- `SHA-512`

You can create your custom signer, hasher, and verifier to extend support for other algorithms. Refer to [this example](example/code_snippets/custom_algorithm.dart) on how to do this.

## Requirements

- Dart SDK version ^3.6.0

## Installation

Run:

```bash
dart pub add selective_disclosure_jwt
```

or manually, add the package into your `pubspec.yaml` file:

```yaml
dependencies:
  selective_disclosure_jwt: ^<version_number>
```

and then run the command below to install the package:

```bash
dart pub get
```

## Usage

After successfully installing the package, import it into your Dart code.

```dart
import 'package:selective_disclosure_jwt/selective_disclosure_jwt.dart';

void main() async {
  // ⚠️ CAUTION: The following keys are for quickstart and testing purposes only.
  // These keys are publicly exposed and MUST NOT be used in any production or real project.
  // Always generate and use your own secure keys for real-world use.
  final issuerPrivateKey = SdPrivateKey("""
-----BEGIN PRIVATE KEY-----
MIGHAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBG0wawIBAQQgRfYYQILHnIkhWOz2
gUl+dfvtkTQDx9OEJaqvKgZaIDuhRANCAATJZsFS61jqyM1ST6riibMlnnA5sTbv
5L1uGdTg7vBADB6xz9AnEMyHnWolqtqXD5n63dw7uDWC1E7jlqzVUOq1
-----END PRIVATE KEY-----
""", SdJwtSignAlgorithm.es256k);

  final issuerPublicKey = SdPublicKey("""
-----BEGIN PUBLIC KEY-----
MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEyWbBUutY6sjNUk+q4omzJZ5wObE2
7+S9bhnU4O7wQAwesc/QJxDMh51qJaralw+Z+t3cO7g1gtRO45as1VDqtQ==
-----END PUBLIC KEY-----
""", SdJwtSignAlgorithm.es256k);

  // 1. Create SD-JWT with selective disclosures
  final selective_disclosure_jwtHandlerV1 handler = selective_disclosure_jwtHandlerV1();

  final Map<String, String> claims = {
    'given_name': 'Alice',
    'family_name': 'Smith',
    'email': 'alice@example.com',
  };

  // Specify which claims should be selectively disclosable
  final disclosureFrame = {
    '_sd': ['given_name', 'email'],
  };

  // Sign the claims to produce the SD-JWT
  final SdJwt sdJwt = await handler.sign(
    claims: claims,
    disclosureFrame: disclosureFrame,
    signer: SDKeySigner(issuerPrivateKey),
  );

  print('SD-JWT: ${selective_disclosure_jwt.serialized}');

  // 2. Decode and verify the SD-JWT
  final SdJwt verified = handler.decodeAndVerify(
    sdJwtToken: sdJwt.serialized,
    verifier: SDKeyVerifier(issuerPublicKey),
  );

  print('Verified claims: ${verified.claims}');
  // Output: {family_name: Smith, given_name: Alice, email: alice@example.com}
}
```

For more examples, go to the [example folder](https://github.com/affinidi/affinidi-selective_disclosure_jwt-dart/tree/main/example/).

## API Reference

For the available operations, go to the [API reference page](https://github.com/affinidi/affinidi-selective_disclosure_jwt-dart/tree/main/doc/api_reference.md).

## Support & feedback

If you face any issues or have suggestions, please don't hesitate to contact us using [this link](https://share.hsforms.com/1i-4HKZRXSsmENzXtPdIG4g8oa2v).

### Reporting technical issues

If you have a technical issue with the Affinidi SD-JWT Dart's codebase, you can also create an issue directly in GitHub.

1. Ensure the bug was not already reported by searching on GitHub under
   [Issues](https://github.com/affinidi/affinidi-selective_disclosure_jwt-dart/issues).

2. If you're unable to find an open issue addressing the problem,
   [open a new one](https://github.com/affinidi/affinidi-selective_disclosure_jwt-dart/issues/new).
   Be sure to include a **title and clear description**, as much relevant information as possible,
   and a **code sample** or an **executable test case** demonstrating the expected behaviour that is not occurring.

## Contributing

Want to contribute?

Head over to our [CONTRIBUTING](https://github.com/affinidi/affinidi-selective_disclosure_jwt-dart/tree/main/CONTRIBUTING.md) guidelines.
