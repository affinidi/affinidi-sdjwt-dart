import 'dart:typed_data';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:selective_disclosure_jwt/src/sign/signer.dart';
import 'package:selective_disclosure_jwt/src/verify/verifier.dart';

/// Bundled Crypto Algorithms.
enum SdJwtSignAlgorithm {
  /// HMAC using SHA-256.
  hs256(JWTAlgorithm.HS256),

  /// HMAC using SHA-384.
  hs384(JWTAlgorithm.HS384),

  /// HMAC using SHA-512.
  hs512(JWTAlgorithm.HS512),

  /// RSASSA-PKCS1-v1_5 using SHA-256.
  rs256(JWTAlgorithm.RS256),

  /// RSASSA-PKCS1-v1_5 using SHA-384.
  rs384(JWTAlgorithm.RS384),

  /// RSASSA-PKCS1-v1_5 using SHA-512.
  rs512(JWTAlgorithm.RS512),

  /// ECDSA using P-256 and SHA-256.
  es256(JWTAlgorithm.ES256),

  /// ECDSA using P-384 and SHA-384.
  es384(JWTAlgorithm.ES384),

  /// ECDSA using P-521 and SHA-512.
  es512(JWTAlgorithm.ES512),

  /// ECDSA using P-256 and SHA-256.
  es256k(JWTAlgorithm.ES256K),

  /// EdDSA using Ed25519.
  eddsa(JWTAlgorithm.EdDSA);

  /// A reference to the internally wrapped JWA instance.
  final JWTAlgorithm _jwa;

  /// Create an enum entry of supported SdJwtAlgorithms.
  const SdJwtSignAlgorithm(this._jwa);

  /// Lookup the SdJwtAlgorithms enum from a given algorithm name.
  factory SdJwtSignAlgorithm.fromString(String value) {
    return SdJwtSignAlgorithm.values.firstWhere(
      (jwa) => jwa._jwa.name == value,
      orElse: () => throw ArgumentError('Invalid algorithm: $value'),
    );
  }

  /// Lookup the SdJwtAlgorithm enum from a given elliptic curve. Relevant only for ECDSA based algorithms.
  factory SdJwtSignAlgorithm.fromCurve(String curve) {
    final normalizedCurve = normalizeCurve(curve);

    switch (normalizedCurve.toUpperCase()) {
      case 'P-256':
        return SdJwtSignAlgorithm.es256;
      case 'P-384':
        return SdJwtSignAlgorithm.es384;
      case 'P-521':
        return SdJwtSignAlgorithm.es512;
      case 'SECP256K1':
      case 'P-256K':
        return SdJwtSignAlgorithm.es256k;
      default:
        throw ArgumentError('Invalid curve: $curve');
    }
  }

  /// Standardize the name of the elliptic curve from different variants to a single standards compliant name.
  static String normalizeCurve(String curve) {
    switch (curve.toUpperCase()) {
      case 'SECP256K1':
      case 'P-256K':
        return 'secp256k1';
      default:
        return curve;
    }
  }

  /// Checks if the given JWK (ECDSA based) or the Algorithm name is among the bundled algorithms.
  static bool isSupported(String alg) {
    // Checks if the algorithm is among the bundled algorithms.
    try {
      SdJwtSignAlgorithm.fromString(alg);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  String toString() => _jwa.name;

  /// Return the name of the curve used by the ECDSA based algorithm. Returns null for other algorithms.
  String? get curve {
    switch (_jwa) {
      case JWTAlgorithm.ES256:
        return 'P-256';
      case JWTAlgorithm.ES384:
        return 'P-384';
      case JWTAlgorithm.ES512:
        return 'P-521';
      case JWTAlgorithm.ES256K:
        return 'secp256k1';
      case JWTAlgorithm.EdDSA:
        return 'Ed25519';
      default:
        return null;
    }
  }

  /// The string representation of The Internet Assigned Numbers Authority
  /// (IANA) name.
  String get ianaName => _jwa.name;
}

/// Abstract class representing an SD-JWT cryptographic key.
///  Subclasses:
/// - `SdPrivateKey` (for signing).
/// - `SdPublicKey` (for verification).
abstract class SdKey {
  /// The cryptographic key.
  final JWTKey _key;

  /// the algorithm implemented by the given key.
  final SdJwtSignAlgorithm alg;

  /// Creates an SD key from the provided key data in various supported formats and algorithm.
  ///
  /// Parameters:
  /// - **[keyData]**: The key data, either as a PEM string or a JWK map.
  /// - **[alg]**: The algorithm to use with this key.
  SdKey(dynamic keyData, this.alg) : _key = _createKey(keyData, alg);

  /// Parses keyData from various supported formats
  static JWTKey _createKey(
    dynamic keyData,
    SdJwtSignAlgorithm alg,
  ) {
    try {
      if (keyData is String) {
        switch (alg) {
          case SdJwtSignAlgorithm.hs256:
          case SdJwtSignAlgorithm.hs384:
          case SdJwtSignAlgorithm.hs512:
            return SecretKey(keyData);
          case SdJwtSignAlgorithm.rs256:
          case SdJwtSignAlgorithm.rs384:
          case SdJwtSignAlgorithm.rs512:
            if (keyData.contains('PRIVATE KEY')) {
              return RSAPrivateKey(keyData);
            } else {
              return RSAPublicKey(keyData);
            }
          case SdJwtSignAlgorithm.es256:
          case SdJwtSignAlgorithm.es384:
          case SdJwtSignAlgorithm.es512:
          case SdJwtSignAlgorithm.es256k:
            if (keyData.contains('PRIVATE KEY')) {
              return ECPrivateKey(keyData);
            } else {
              return ECPublicKey(keyData);
            }
          case SdJwtSignAlgorithm.eddsa:
            if (keyData.contains('PRIVATE KEY')) {
              return EdDSAPrivateKey.fromPEM(keyData);
            } else {
              return EdDSAPublicKey.fromPEM(keyData);
            }
        }
      } else if (keyData is Map<String, dynamic>) {
        return JWTKey.fromJWK(keyData);
      } else {
        throw ArgumentError(
            'Invalid key data type. Expected String (PEM) or Map<String, dynamic> (JWK).');
      }
    } catch (e) {
      throw ArgumentError(
        'Failed to create key from provided data for alg ${alg.ianaName}: $e. Data: $keyData',
      );
    }
  }

  /// Gets the IANA name for the algorithm used with this key.
  ///
  /// Returns the IANA standard name for the algorithm.
  String algIanaName() => alg.ianaName;

  @override
  String toString() => _key.toString();

  /// Returns the JSON Web Key version of the key
  Map<String, dynamic> toJson() {
    try {
      return _key.toJWK();
    } catch (e) {
      throw UnsupportedError(
          'This key type does not support conversion to JWK: $e');
    }
  }
}

/// Represents a private key for signing SD-JWTs.
///
/// This class is used for signing operations in the SD-JWT workflow.
class SdPrivateKey extends SdKey {
  /// Creates a private key from the provided key data and algorithm.
  ///
  /// Parameters:
  /// - **[key]**: The key data, either as a PEM string or a JWK map.
  /// - **[alg]**: The algorithm to use with this key.
  SdPrivateKey(super.key, super.alg);
}

/// Represents a public key for verifying SD-JWTs.
///
/// This class is used for verification operations in the SD-JWT workflow.
class SdPublicKey extends SdKey {
  /// Creates a public key from the provided key data and algorithm.
  ///
  /// Parameters:
  /// - **[key]**: The key data, either as a PEM string or a JWK map.
  /// - **[alg]**: The algorithm to use with this key.
  SdPublicKey(super.key, super.alg);
}

/// Implements the [Signer] for bundled algorithms and supported private key formats.
class SDKeySigner implements Signer {
  final SdPrivateKey _privateKey;

  @override
  final String? keyId;

  /// Creates the signer for the given [SdPrivateKey]
  ///
  /// Parameters:
  /// - **[_privateKey]**: The [SdPrivateKey] that can be used for signing
  /// - **[keyId]**: (optional) Any additional verification Id
  SDKeySigner(this._privateKey, {this.keyId});

  @override
  Future<Uint8List> sign(Uint8List input) async {
    final key = _privateKey._key;
    final algorithm = _privateKey.alg._jwa;

    return algorithm.sign(key, input);
  }

  @override
  String get algIanaName => _privateKey.alg.ianaName;
}

/// Implements the [Signer] for bundled algorithms and supported public key formats.
class SDKeyVerifier implements Verifier {
  final SdPublicKey _publicKey;

  /// Creates the verifier for the given [SdPublicKey].
  /// The public key of the JWT's issuer can be deduced as needed using any appropriate method.
  ///
  /// Parameters:
  /// - **[_publicKey]**: The [SdPublicKey] that can be used for verifying
  SDKeyVerifier(this._publicKey);

  /// Verify the signature bytes, for the given data bytes using the [SdPublicKey] and it's [SdJwtSignAlgorithm].
  ///
  /// Parameters:
  /// - **[data]**: The data bytes
  /// - **[signature]**: The signature bytes
  ///
  /// Returns whether the signature is correct
  @override
  bool verify(Uint8List data, Uint8List signature) {
    try {
      final key = _publicKey._key;
      final algorithm = _publicKey.alg._jwa;
      return algorithm.verify(key, data, signature);
    } catch (e) {
      return false;
    }
  }

  /// This Verifier can be used with any of the bundled algorithms.
  @override
  bool isAllowedAlgorithm(String algorithm) {
    return SdJwtSignAlgorithm.isSupported(algorithm);
  }
}
