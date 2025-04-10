import 'package:sdjwt/sdjwt.dart';

void createArrayElemSdJwt() {
  // Array Element Disclosures
  final claims = {
    'phones': [
      {'type': 'home', 'number': '555-1234'},
      {'type': 'work', 'number': '555-5678'},
    ],
  };

  // Make the phone numbers selectively disclosable while keeping types visible
  final disclosureFrame = {
    'phones': [
      {
        '_sd': ['number'],
      },
      {
        '_sd': ['number'],
      },
    ],
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

  print("SD-JWT with array disclosures: ${sdJwt.serialized}");
}
