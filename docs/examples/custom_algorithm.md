## Custom Algorithm

If you wish to use another algorithm outside of the bundled algorithm from the package, you can extend and implement the following interface:

- For custom signer, extend the [Signer](https://github.com/affinidi/affinidi-sdjwt-dart/blob/main/lib/src/sign/signer.dart) interface class.

- For custom verifier, extend the [Verifier](https://github.com/affinidi/affinidi-sdjwt-dart/blob/main/lib/src/verify/verifier.dart) interface class.

- For custom hasher, extend the [Hasher](https://github.com/affinidi/affinidi-sdjwt-dart/blob/0b5e95c5dcadbc8e3e0903263b04101bf34483ca/lib/src/base/hasher.dart#L16) interface class.


The sample code below shows you how to pass and use your custom signer when signing an SD-JWT.

```dart
import 'package:sdjwt/sdjwt.dart';

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
```

You can refer to this [implementation](https://github.com/affinidi/affinidi-sdjwt-dart/blob/main/lib/src/models/sdkey.dart#L181) of extending the interface to implement a custom signer.