# SD-JWT Dart SDK

[![Dart SDK Version](https://img.shields.io/badge/dart-%3E%3D3.6.0-blue.svg)](https://dart.dev)
[![License: Apache](https://img.shields.io/badge/license-Apache%202.0-blue)](LICENSE)

The SD-JWT Dart SDK provides libraries and tools to enable selective disclosure, enhancing security and privacy in the data-sharing process. It implements the IETF's [Selective Disclosure for JWTs (SD-JWT)](https://datatracker.ietf.org/doc/draft-ietf-oauth-selective-disclosure-jwt/)specification. 

The SD-JWT Dart package enables:

- **Issuer** to create JWTs with selectively disclosable claims.
- **Holder** to present only specific claims to verifiers.
- **Verifier** to validate the authenticity of the presented claims.
- **Key binding** to prevent unauthorized presentations.

> **IMPORTANT:** 
> This project does not collect or process personal data by default. However, when used as part of a broader system or application that handles personally identifiable information (PII), users are responsible for ensuring that any such use complies with applicable privacy laws and data protection obligations.

## Table of Contents

- [Core Concepts](#core-concepts)
- [Supported Algorithms](#supported-algorithms)
- [Installation](#installation)
- [Usage](#usage)
- [API Reference](#api-reference)
- [Support & feedback](#support--feedback)
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

You can create your custom signer, hasher, and verifier to extend support for other algorithms. Refer to [this example](docs/examples/custom_algorithm.md) on how to do this.

## Requirements

- Dart SDK version ^3.6.0

## Installation

Add the package into your `pubspec.yaml` file.

```yaml
dependencies:
  sdjwt: ^<version_number>
```

Then, run the command below to install the package.

```bash
dart pub get
```

## Usage

After successfully installing the package, import it into your Dart code.

```dart
import 'package:sdjwt/sdjwt.dart';

void main() async {
  // 1. Create SD-JWT with selective disclosures
  final handler = SdJwtHandlerV1();

  final claims = {
    'given_name': 'Alice',
    'family_name': 'Smith',
    'email': 'alice@example.com',
  };

  // Mark which claims should be selectively disclosable
  final disclosureFrame = {
    '_sd': ['given_name', 'email']
  };

  // Create the SD-JWT
  final sdJwt = handler.sign(
    claims: claims,
    disclosureFrame: disclosureFrame,
    signer: SDKeySigner(issuerPrivateKey),
  );

  print("SD-JWT: ${sdJwt.serialized}");

  // 2. Verify the SD-JWT
  final verified = handler.decodeAndVerify(
    sdJwtToken: sdJwt.serialized,
    verifier: SDKeyVerifier(issuerPublicKey),
  );

  print("Verified claims: ${verified.claims}");
  // Output: {given_name: Alice, family_name: Smith, email: alice@example.com}
}
```

For more sample usage, go to the [examples folder](docs/examples/), and for an end-to-end example implementation, refer to [this folder](example).

## API Reference

For the available operations, go to the [API reference page](docs/api_reference.md).

## Support & feedback

If you face any issues or have suggestions, please don't hesitate to contact us using [this link](https://share.hsforms.com/1i-4HKZRXSsmENzXtPdIG4g8oa2v).

### Reporting technical issues

If you have a technical issue with the Affinidi SD-JWT Dart's codebase, you can also create an issue directly in GitHub.

1. Ensure the bug was not already reported by searching on GitHub under
   [Issues](https://github.com/affinidi/affinidi-sdjwt-dart/issues).

2. If you're unable to find an open issue addressing the problem,
   [open a new one](https://github.com/affinidi/affinidi-sdjwt-dart/issues/new).
   Be sure to include a **title and clear description**, as much relevant information as possible,
   and a **code sample** or an **executable test case** demonstrating the expected behaviour that is not occurring.

## Contributing

Want to contribute?

Head over to our [CONTRIBUTING](CONTRIBUTING.md) guidelines.
