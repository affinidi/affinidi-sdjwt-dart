import 'package:sdjwt/sdjwt.dart';

void presentSdJwt(String serializedSdJwt) {
  // Parse the original SD-JWT without verification
  final handler = SdJwtHandlerV1();
  final sdJwt = handler.unverifiedDecode(sdJwtToken: serializedSdJwt);

  // Select which disclosures to keep (e.g., only share name and email, not birthdate)
  final disclosuresToKeep =
      sdJwt.disclosures
          .where((d) => d.claimName == 'given_name' || d.claimName == 'email')
          .toSet();

  // Create a presentation with only selected disclosures
  final presentation = handler.present(
    sdJwt: sdJwt,
    disclosuresToKeep: disclosuresToKeep,
  );

  // Get the serialized presentation to share with the verifier
  final presentationString = presentation.serialized;
  print("Presentation SD-JWT: $presentationString");

  // Example output (truncated):
  // eyJhbGciOiJFUzI1NiIsInR5cCI6InNkK2p3dCJ9.eyJmYW1pbH...~eyJhbGciOiJFUzI1NiJ9.e30~
}
