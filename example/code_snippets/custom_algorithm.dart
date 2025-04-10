import 'package:sdjwt/sdjwt.dart';
import 'package:sdjwt/src/sign/signer.dart';

class MyCustomSigner implements Signer {
  final SdPrivateKey _privateKey;

  @override
  final String? keyId;

  /// Creates the signer for the given [SdPrivateKey]
  ///
  /// Parameters:
  /// - **[_privateKey]**: The [SdPrivateKey] that can be used for signing
  /// - **[keyId]**: (optional) Any additional verification Id
  MyCustomSigner(this._privateKey, {this.keyId});

  @override
  Uint8List sign(Uint8List input) {
    final sig = _privateKey._key.sign(
      input,
      algorithm: _privateKey.algIanaName(),
    );
    return Uint8List.fromList(sig);
  }

  @override
  String get algIanaName => _privateKey.alg.ianaName;
}

void createSdJwt() {
  // Create the SD-JWT handler and signer
  final handler = SdJwtHandlerV1();
  final customSigner = MyCustomSigner(issuerPrivateKeyInCustomFormat);

  // Sign the SD-JWT
  final sdJwt = handler.sign(
    claims: claims,
    disclosureFrame: disclosureFrame,
    signer: customSigner,
  );

  // Get the serialized SD-JWT
  final serialized = sdJwt.serialized;
  print("SD-JWT: $serialized");
}
