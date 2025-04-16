import 'package:selective_disclosure_jwt/selective_disclosure_jwt.dart';

import 'consts.dart';

void main() async {
  final handler = SdJwtHandlerV1();

  // Option 1: Decode without verification
  // Use this when you need to examine the contents without verifying the signature
  // For example, when you want to see what disclosures are available
  final decodedOnly = handler.unverifiedDecode(
    sdJwtToken: serializedSdJwt,
    // Optional: provide a custom hasher if the SD-JWT uses a non-standard hashing algorithm
    // customHasher: myCustomHasher,
  );

  print('Decoded claims (unverified): ${decodedOnly.claims}');
  print('Available disclosures: ${decodedOnly.disclosures.length}');

  // Option 2: Decode and verify in one step
  // This verifies the signature against the issuer's public key
  try {
    final issuerPublicKey = SdPublicKey(
      publicKeyPem, // Issuer's public key in PEM format
      SdJwtSignAlgorithm.es256, // The algorithm used for signing
    );

    final verifier = SDKeyVerifier(issuerPublicKey);

    final verifiedResult = handler.decodeAndVerify(
      sdJwtToken: serializedSdJwt,
      verifier: verifier,
      // Optional: verify the key binding JWT if present
      verifyKeyBinding: true,
    );

    // If we got here, verification succeeded
    print('Verified claims: ${verifiedResult.claims}');

    // Check the verification status
    if (verifiedResult.isVerified == true) {
      print('SD-JWT is fully verified');
    }
  } catch (e) {
    print('Verification failed: $e');
  }
}
