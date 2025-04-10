import 'package:sdjwt/sdjwt.dart';

void createSdJwt() {
  // Create the claims to be included in the SD-JWT
  final claims = {
    'given_name': 'Alice',
    'family_name': 'Smith',
    'email': 'alice.smith@example.com',
    'birthdate': '1990-01-01',
    'address': {
      'street_address': '123 Main St',
      'locality': 'Anytown',
      'country': 'US'
    },
  };

  // Define which claims should be selectively disclosable
  final disclosureFrame = {
    '_sd': ['given_name', 'email', 'birthdate']
  };

  // Create issuer's private key for signing
  final issuerPrivateKey = SdPrivateKey(
    privateKeyPem, // Your private key in PEM format
    SdJwtSignAlgorithm.es256, // Choose appropriate algorithm
  );

  // Create the SD-JWT handler and signer
  final handler = SdJwtHandlerV1();
  final signer = SDKeySigner(issuerPrivateKey);

  // Sign the SD-JWT
  final sdJwt = handler.sign(
    claims: claims,
    disclosureFrame: disclosureFrame,
    signer: signer,
    // Optional: specify a different hasher
    // hasher: Base64EncodedOutputHasher.base64Sha512,
    // Optional: add holder key for key binding
    // holderPublicKey: holderPublicKey,
  );

  // Get the serialized SD-JWT
  final serialized = sdJwt.serialized;
  print("SD-JWT: $serialized");

  // Example output (truncated):
  // eyJhbGciOiJFUzI1NiIsInR5cCI6InNkK2p3dCJ9.eyJmYW1pbH...~eyJhbGciOiJFUzI1NiJ9.e30~
}
