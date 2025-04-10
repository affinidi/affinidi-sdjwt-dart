import 'package:sdjwt/sdjwt.dart';

void presentWithKeyBinding(String serializedSdJwt) {
  // Parse the SD-JWT without verification
  final handler = SdJwtHandlerV1();
  final sdJwt = handler.unverifiedDecode(sdJwtToken: serializedSdJwt);

  // Configure holder's key pair
  final holderPrivateKey = SdPrivateKey(
    holderPrivateKeyPem,
    SdJwtSignAlgorithm.es256,
  );
  final holderPublicKey = SdPublicKey(
    holderPublicKeyPem,
    SdJwtSignAlgorithm.es256,
  );

  // Create holder signer for key binding
  final holderSigner = SDKeySigner(holderPrivateKey);

  // Select which disclosures to keep
  final disclosuresToKeep = sdJwt.disclosures.where(
    (d) => d.claimName == 'given_name' || d.claimName == 'email'
  ).toSet();

  // Present with key binding
  final presentation = handler.present(
    sdJwt: sdJwt,
    disclosuresToKeep: disclosuresToKeep,
    presentWithKbJwtInput: PresentWithKbJwtInput(
      'https://verifier.example.com', // Audience (verifier)
      holderSigner, 
      holderPublicKey,
    ),
  );

  // Get the serialized presentation with key binding
  final keyBoundPresentation = presentation.serialized;
  print("KB-JWT Presentation: $keyBoundPresentation");

  // Example output (truncated):
  // eyJhbGciOiJFUzI1NiIsInR5cCI6InNkK2p3dCJ9...~eyJhbGciOiJFUzI1NiJ9.e30~eyJhbGciOiJFUzI1NiJ9...
}
