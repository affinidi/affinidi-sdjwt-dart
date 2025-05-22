import 'dart:convert';
import 'dart:typed_data';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:selective_disclosure_jwt/src/utils/common.dart';
import 'package:selective_disclosure_jwt/src/verify/verifier.dart';

/// A mixin that provides common JWT verification functionality.
///
/// This mixin includes methods for verifying JWT signatures, time-based claims,
/// and confirmation claims (cnf).
///
/// @internal
/// This is an internal implementation detail, not intended for direct use by consumers of the package.
mixin JwtVerifier {
  /// Verifies the signature of a JWT using the provided key.
  ///
  /// Parameters:
  /// - **[serialized]**: The JWT string to verify.
  /// - **[verifier]**: The [Verifier] to use for verification.
  ///
  /// Returns the verified JWT object if successful.
  /// Throws an exception if verification fails.
  bool verifyJwt({
    required String serialized,
    required Verifier verifier,
  }) {
    final JWT decodedJwt;
    try {
      decodedJwt = JWT.decode(serialized);
    } catch (e) {
      throw Exception('Invalid JWT format: $e');
    }

    final headerJson = decodedJwt.header;
    if (headerJson == null) {
      throw Exception('JWT header is missing');
    }

    // Verify that the algorithm is supported by the verifier.
    final alg = headerJson['alg'] as String?;
    if (alg == null || !verifier.isAllowedAlgorithm(alg)) {
      throw Exception('JWT verification failed: Supported alg not found');
    }

    final parts = serialized.split('.');
    if (parts.length != 3) {
      throw Exception('Invalid JWT format: expected 3 parts');
    }

    final signInput = ascii.encode('${parts[0]}.${parts[1]}');
    final signature = base64Url.decode(base64Url.normalize(parts[2]));

    return verifier.verify(
      Uint8List.fromList(signInput),
      Uint8List.fromList(signature),
    );
  }

  /// Verifies time-based claims in the JWT payload.
  ///
  /// Checks that:
  /// - The expiration time (exp) is in the future
  /// - The issued at time (iat) is in the past
  /// - The not before time (nbf), if present, is in the past
  ///
  /// Parameters:
  /// - **[payload]**: The JWT payload containing the claims.
  ///
  /// Returns true if all time-based claims are valid, false otherwise.
  /// Throws an exception if required claims are missing.
  bool verifyTimeBasedClaims(Map<String, dynamic> payload) {
    final now = jwtNow();

    final exp = payload['exp'];
    if (exp == null) {
      throw Exception('Expiry claim (exp) is missing');
    }
    if (exp < now) return false;

    final iat = payload['iat'];
    if (iat == null) {
      throw Exception('Issued at claim (iat) is missing');
    }
    if (iat > now) return false;

    final nbf = payload['nbf'];
    if (nbf != null && nbf > now) return false;

    return true;
  }
}
