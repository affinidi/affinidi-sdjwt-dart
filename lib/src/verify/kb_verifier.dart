import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:selective_disclosure_jwt/selective_disclosure_jwt.dart';
import 'package:selective_disclosure_jwt/src/base/action.dart';
import 'package:selective_disclosure_jwt/src/utils/kb_jwt/base64_digest_calculator.dart';
import 'package:selective_disclosure_jwt/src/verify/jwt_verifier_base.dart';

/// Action class for verifying Key Binding JWTs (KB-JWTs).
///
/// This class implements the logic for verifying KB-JWTs according to the SD-JWT specification.
///
/// @internal
/// This is an internal implementation detail, not intended for direct use by consumers of the package.
class KbVerifyAction extends Action<SdJwt, bool> with JwtVerifier {
  /// Calculator for base64 digests.
  final Base64DigestCalculator _hashCalculator;

  /// Creates a new action for verifying KB-JWTs.
  ///
  /// Parameters:
  /// - **[hashCalculator]**: Calculator for base64 digests.
  KbVerifyAction({Base64DigestCalculator? hashCalculator})
      : _hashCalculator = hashCalculator ?? Base64DigestCalculator();

  @override
  bool execute(SdJwt sdJwt) {
    final kbJwt = sdJwt.kbString;

    if (kbJwt == null || kbJwt.isEmpty) {
      throw Exception('a valid kbJwt is required');
    }

    final Map<String, dynamic>? cnf = sdJwt.payload['cnf'];
    if (cnf == null || cnf.isEmpty) {
      throw Exception('sdJwt should have a valid `cnf` claim');
    }

    final Map<String, dynamic>? jwk = sdJwt.payload['cnf']['jwk'];
    if (jwk == null || jwk.isEmpty) {
      throw Exception(
          'only `jwk` based proof of possession is supported at the moment');
    }

    final JWT decodedKbJwt;
    try {
      decodedKbJwt = JWT.decode(kbJwt);
    } catch (e) {
      throw ArgumentError('Invalid KB-JWT format or failed to decode: $e');
    }

    final headerJson = decodedKbJwt.header;
    if (headerJson == null) {
      throw Exception('KB-JWT is missing header');
    }

    final alg = headerJson['alg'] as String?;
    final kbJwtPayload = decodedKbJwt.payload;
    if (kbJwtPayload == null) {
      throw Exception('KB-JWT is missing payload');
    }

    if (alg == null || alg.isEmpty) {
      throw Exception(
          "Kb JWT is missing the 'alg' header needed to verify the signature");
    }

    if (!SdJwtSignAlgorithm.isSupported(alg)) {
      throw Exception(
          'The jwk uses a crypto algorithm that is currently not supported');
    }

    final publicKey = SdPublicKey(jwk, SdJwtSignAlgorithm.fromString(alg));
    final kbJwtVerifier = SDKeyVerifier(publicKey);

    // Calculate SD Hash from disclosures
    final String sdHash = _hashCalculator.execute(sdJwt);

    try {
      // 1. Verify kbJwt Signature
      if (!verifyJwt(
        serialized: kbJwt,
        verifier: kbJwtVerifier,
      )) {
        return false;
      }

      // 2. Verify time-based claims
      if (!verifyTimeBasedClaims(kbJwtPayload)) {
        return false;
      }

      // 3. Verify SD Hash
      if (!_verifySdHash(kbJwtPayload, sdHash)) {
        return false;
      }

      return true;
    } catch (e) {
      throw Exception('Failed to verify KB JWT: $e');
    }
  }

  bool _verifySdHash(Map<String, dynamic> payload, String sdHash) {
    final sdHashClaim = payload['sd_hash'];
    if (sdHashClaim == null) {
      throw Exception('SD Hash claim is missing');
    }
    return sdHashClaim == sdHash;
  }
}
