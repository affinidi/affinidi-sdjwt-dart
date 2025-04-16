import 'package:selective_disclosure_jwt/selective_disclosure_jwt.dart';

import 'consts.dart';

void main() async {
  // Create verifier with issuer's public key
  final publicKey = SdPublicKey(
    publicKeyPem, // Issuer's public key in PEM format
    SdJwtSignAlgorithm.es256, // Same algorithm used for signing
  );
  final verifier = SDKeyVerifier(publicKey);

  // Create SD-JWT handler
  final handler = SdJwtHandlerV1();

  try {
    // Decode and verify the SD-JWT in one step
    final verificationResult = handler.decodeAndVerify(
      sdJwtToken: serializedSdJwt,
      verifier: verifier,
      // Optional: verify key binding if present
      verifyKeyBinding: true,
    );

    // Access verified claims
    print('Verification successful!');
    print('Claims: ${verificationResult.claims}');

    // Example output:
    // Verification successful!
    // Claims: {given_name: Alice, family_name: Smith, email: alice.smith@example.com}
  } catch (e) {
    print('Verification failed: $e');
  }
}
