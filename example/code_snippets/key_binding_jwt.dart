import 'package:sdjwt/sdjwt.dart';

import 'consts.dart';

const serializedSdJwt =
    r'eyJhbGciOiJFUzI1NksiLCJ0eXAiOiJzZCtqd3QifQ.eyJsYXN0X25hbWUiOiJCb3ciLCJfc2QiOlsicTdKeTRkVzVObEs3NXNiZzVNYzdUVzVzTEx3YktidVgxRHlxcGFsNHM2USJdLCJfc2RfYWxnIjoic2hhLTI1NiIsImNuZiI6eyJqd2siOnsia3R5IjoiRUMiLCJjcnYiOiJQLTI1NiIsIngiOiJ5V2JCVXV0WTZzak5Vay1xNG9tekpaNXdPYkUyNy1TOWJoblU0Tzd3UUF3IiwieSI6IkhySFAwQ2NRekllZGFpV3EycGNQbWZyZDNEdTROWUxVVHVPV3JOVlE2clUifX19.bGCJst5PfNV2rLsHaLwE6dTXbXkngycrdDpsKtaoqIf3xedfcgX80oZlcujlUY4cq4xE1C98hcie503-Fj2CtQ~WyJFZ1BHek9kSGY3dmNVRlhkNGRaTV93IiwiZmlyc3RfbmFtZSIsIlJhaW4iXQ==~';

void main() async {
  // Parse the SD-JWT without verification
  final handler = SdJwtHandlerV1();

  // Create verifier with issuer's public key
  final holderPublicKey = SdPublicKey(
    publicKeyPem, // Issuer's public key in PEM format
    SdJwtSignAlgorithm.es256, // Same algorithm used for signing
  );
  final verifier = SDKeyVerifier(holderPublicKey);
  final sdJwt =
      handler.decodeAndVerify(sdJwtToken: serializedSdJwt, verifier: verifier);

  // Configure holder's key pair
  final holderPrivateKey = SdPrivateKey(
    privateKeyPem,
    SdJwtSignAlgorithm.es256,
  );

  // Create holder signer for key binding
  final holderSigner = SDKeySigner(holderPrivateKey);

  // Select which disclosures to keep
  final disclosuresToKeep = sdJwt.disclosures
      .where((d) => d.claimName == 'given_name' || d.claimName == 'email')
      .toSet();

  // Present with key binding
  final presentation = await handler.present(
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
