import 'package:sdjwt/sdjwt.dart';

void createNestedSdJwt() {

  final claims = {
    'address': {
      'street': '123 Main St',
      'city': 'Anytown',
      'state': 'CA',
      'postal_code': '12345',
      'country': 'US'
    },
    'email': 'john.doe@example.com',
  };

  // Make email and specific address fields selectively disclosable
  final disclosureFrame = {
    '_sd': ['email'],
    'address': {
      '_sd': ['street', 'postal_code']
    }
  };

  // Create issuer's private key for signing
  final issuerPrivateKey = SdPrivateKey(
    privateKeyPem, // Your private key in PEM format
    SdJwtSignAlgorithm.es256, // Choose appropriate algorithm
  );

  // Create the SD-JWT handler and signer
  final handler = SdJwtHandlerV1();
  final signer = SDKeySigner(issuerPrivateKey);

  final sdJwt = handler.sign(
    claims: claims,
    disclosureFrame: disclosureFrame,
    signer: signer,
  );

  print("SD-JWT with nested disclosures: ${sdJwt.serialized}");

}