import 'dart:typed_data';

import 'package:sdjwt/sdjwt.dart';

class MyCustomSigner implements Signer {
  @override
  String? get keyId => "key id";

  @override
  Future<Uint8List> sign(Uint8List input) {
    return Future.value(
      Uint8List.fromList(
        [1, 2, 3, 4],
      ),
    );
  }

  @override
  String get algIanaName => 'CUSTOM';
}

void main() async {
  // Create the SD-JWT handler and signer
  final handler = SdJwtHandlerV1();
  final customSigner = MyCustomSigner();

  final claims = {
    'given_name': 'Alice',
    'family_name': 'Smith',
  };

  // Define which claims should be selectively disclosable
  final disclosureFrame = {
    '_sd': ['given_name'],
  };

  // Sign the SD-JWT
  final sdJwt = await handler.sign(
    claims: claims,
    disclosureFrame: disclosureFrame,
    signer: customSigner,
  );

  // Get the serialized SD-JWT
  final serialized = sdJwt.serialized;
  print("SD-JWT: $serialized");
}
