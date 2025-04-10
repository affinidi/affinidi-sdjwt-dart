## SD-JWT for Dart Examples

Check the sample app and code snippets to learn how to integrate this package with your project.

### 1. Sample app for end-to-end implementation

Set up and run the end-to-end sample implementation of the Affinidi SD-JWT for Dart with Flutter - [view example](https://github.com/affinidi/affinidi-sdjwt-dart/tree/main/example/sample_app/).

### 2. Create and sign SD-JWT

Create and sign the selected disclosures as SD-JWT - [view example](https://github.com/affinidi/affinidi-sdjwt-dart/tree/main/example/sample_codes/creating_signing_sdjwt.dart).

### 3. Create and sign a various disclosure structure

Create and sign the nested disclosures as SD-JWT - [view example](https://github.com/affinidi/affinidi-sdjwt-dart/tree/main/example/sample_codes/nested_disclosure_structure.dart).

Create and sign the array element disclosures as SD-JWT - [view example](https://github.com/affinidi/affinidi-sdjwt-dart/tree/main/example/sample_codes/array_element_disclosures.dart).

### 4. Verify the SD-JWT

Decode and verify the SD-JWT string often shared to your application - [view example](https://github.com/affinidi/affinidi-sdjwt-dart/tree/main/example/sample_codes/decoding_verifying_sdjwt_string.dart).

Decode and verify the SD-JWT serialised data - [view example](https://github.com/affinidi/affinidi-sdjwt-dart/tree/main/example/sample_codes/verifying_sdjwt.dart).

### 5. Create a Key-binding JWT (KB-JWT)

Key-binding JWT ensures that only the intended holder can present the SD-JWT - [view example](https://github.com/affinidi/affinidi-sdjwt-dart/tree/main/example/sample_codes/key_binding_jwt.dart).

### 6. Create an SD-JWT presentation

Create the presentation of the selected disclosure - [view example](https://github.com/affinidi/affinidi-sdjwt-dart/tree/main/example/sample_codes/presenting_sdjwt.dart).

### 7. Use a custom algorithm

If you wish to use another algorithm outside of the bundled algorithm from the package, you can extend and implement the following interface - [view example](https://github.com/affinidi/affinidi-sdjwt-dart/tree/main/example/sample_codes/custom_algorithm.dart).

- For custom signer, extend the [Signer](https://github.com/affinidi/affinidi-sdjwt-dart/blob/main/lib/src/sign/signer.dart) interface class.

- For custom verifier, extend the [Verifier](https://github.com/affinidi/affinidi-sdjwt-dart/blob/main/lib/src/verify/verifier.dart) interface class.

- For custom hasher, extend the [Hasher](https://github.com/affinidi/affinidi-sdjwt-dart/blob/0b5e95c5dcadbc8e3e0903263b04101bf34483ca/lib/src/base/hasher.dart#L16) interface class.


