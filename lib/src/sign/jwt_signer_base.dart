import 'dart:convert';

import 'package:selective_disclosure_jwt/src/sign/signer.dart';
import 'package:selective_disclosure_jwt/src/utils/common.dart';

/// A mixin that provides common JWT signing functionality.
///
/// This mixin includes methods for generating signed compact jwt.
///
/// @internal
/// This is an internal implementation detail, not intended for direct use by consumers of the package.
mixin JwtSigner {
  /// Generates a signed compact JWT from the [claims] as payload and [protectedHeaders]
  /// as header using the provided [signer].
  ///
  /// Parameters:
  /// - **[signer]**: The signer for signing the JWT.
  /// - **[claims]**: The claims to be included in the JWT payload.
  /// - **[protectedHeaders]**: The headers to include in the signed JWT.
  ///
  /// Returns a compact serialized JWT string.
  Future<String> generateSignedCompactJwt({
    required Signer signer,
    required Map<String, dynamic> claims,
    Map<String, dynamic> protectedHeaders = const {},
  }) async {
    final headers = <String, dynamic>{'alg': signer.algIanaName};

    if (signer.keyId != null) {
      headers['kid'] = signer.keyId;
    }

    headers.addAll(jsonDecode(jsonEncode(protectedHeaders)));

    final encodedPayload = base64UrlEncode(claims);
    final encodedHeader = base64UrlEncode(headers);

    final signInput = utf8.encode('$encodedHeader.$encodedPayload');

    final signature = await signer.sign(signInput);
    final encodedSignature = base64UrlEncode(signature);

    return '$encodedHeader.$encodedPayload.$encodedSignature';
  }
}
