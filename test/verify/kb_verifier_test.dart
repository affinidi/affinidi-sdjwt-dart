import 'dart:convert';
import 'dart:io';

import 'package:selective_disclosure_jwt/selective_disclosure_jwt.dart';
import 'package:selective_disclosure_jwt/src/models/sdjwt.dart';
import 'package:selective_disclosure_jwt/src/validator/kb_signer_input_validator.dart';
import 'package:selective_disclosure_jwt/src/verify/kb_verifier.dart';
import 'package:test/test.dart';

void main() {
  group('KbVerifier', () {
    late KbVerifyAction verifyAction;
    late Map<String, dynamic> mockHolderKey;
    late SdJwt sdJwtWithoutCnf;
    late SdJwt sdJwtWithCnf;
    late Signer signer;
    late AsyncKbJwtSignerInputValidator validator;

    final claims = {
      'id': '1234',
      'first_name': 'Rain',
      'last_name': 'Bow',
    };
    final disclosureFrame = {
      '_sd': [
        'last_name',
      ],
    };

    setUp(() async {
      final privateKeyFile = File(
        'test/resources/ecdsa_sdjwt_test_private_key.pem',
      );
      final publicKeyFile = File(
        'test/resources/ecdsa_sdjwt_test_public_key.pem',
      );

      final privateKeyStr = privateKeyFile.readAsStringSync();
      final publicKeyStr = publicKeyFile.readAsStringSync();

      final issuerPrivateKey =
          SdPrivateKey(privateKeyStr, SdJwtSignAlgorithm.es256);
      final holderPublicKey =
          SdPublicKey(publicKeyStr, SdJwtSignAlgorithm.es256);

      signer = SDKeySigner(issuerPrivateKey);

      final sdSigner = SdJwtSigner();

      final SdJwtSignerInput signerInput = SdJwtSignerInput(
          claims: Map<String, dynamic>.from(claims),
          disclosureFrame: disclosureFrame,
          hasher: Base64EncodedOutputHasher.base64Sha256,
          signer: signer);

      sdJwtWithoutCnf = await sdSigner.execute(signerInput);

      final SdJwtSignerInput signerInputWithCnf = SdJwtSignerInput(
          claims: Map<String, dynamic>.from(claims),
          disclosureFrame: disclosureFrame,
          signer: signer,
          hasher: Base64EncodedOutputHasher.base64Sha256,
          holderPublicKey: holderPublicKey);
      sdJwtWithCnf = await sdSigner.execute(signerInputWithCnf);

      verifyAction = KbVerifyAction();

      validator = AsyncKbJwtSignerInputValidator();

      mockHolderKey = {
        'kty': 'EC',
        'crv': 'P-256',
        'x': base64Url.encode(List.filled(32, 1)),
        'y': base64Url.encode(List.filled(32, 2))
      };
    });

    Future<String> createMockJwt(Map<String, dynamic> payload) async {
      final jwtSigner = SdJwtSigner();
      return await jwtSigner.generateSignedCompactJwt(
          signer: signer, claims: payload, protectedHeaders: {'typ': 'jwt'});
    }

    test('verify should throw for invalid JWT format', () async {
      expect(() => verifyAction.execute(sdJwtWithCnf.withKbJwt('invalid.jwt')),
          throwsArgumentError);
    });

    test('verify should throw for missing CNF claim', () async {
      expect(
          () => verifyAction.execute(sdJwtWithoutCnf.withKbJwt('invalid.jwt')),
          throwsException);
    });

    test('verify should throw for missing SD hash claim', () async {
      final jwt = await createMockJwt({
        'exp': DateTime.now().add(Duration(hours: 1)).millisecondsSinceEpoch ~/
            1000,
        'iat': DateTime.now().millisecondsSinceEpoch ~/ 1000,
        'cnf': {'jwk': mockHolderKey}
      });

      final result = verifyAction.execute(sdJwtWithCnf.withKbJwt(jwt));
      expect(result, isFalse);
    });

    test('verify should return false for invalid SD hash', () async {
      final jwt = await createMockJwt({
        'exp': DateTime.now().add(Duration(hours: 1)).millisecondsSinceEpoch ~/
            1000,
        'iat': DateTime.now().millisecondsSinceEpoch ~/ 1000,
        'cnf': {'jwk': mockHolderKey},
        'sd_hash': 'differentHash'
      });

      final result = verifyAction.execute(sdJwtWithCnf.withKbJwt(jwt));
      expect(result, isFalse);
    });

    test('verify should return false for expired token', () async {
      final jwt = await createMockJwt({
        'exp': DateTime.now()
                .subtract(Duration(hours: 1))
                .millisecondsSinceEpoch ~/
            1000,
        'iat': DateTime.now()
                .subtract(Duration(hours: 2))
                .millisecondsSinceEpoch ~/
            1000,
        'cnf': {'jwk': mockHolderKey},
        'sd_hash': 'mockHash'
      });

      final result = verifyAction.execute(sdJwtWithCnf.withKbJwt(jwt));
      expect(result, isFalse);
    });

    test('throws exception if SdJwt is not verified', () async {
      final SdJwtSigner sdSignerForTest = SdJwtSigner();
      final SdJwtSignerInput localSignerInput = SdJwtSignerInput(
        claims: Map<String, dynamic>.from(claims),
        disclosureFrame: disclosureFrame,
        hasher: Base64EncodedOutputHasher.base64Sha256,
        signer: signer,
      );
      final newlySignedJwt = await sdSignerForTest.execute(localSignerInput);

      final unverifiedSdJwt = SdJwt.parse(newlySignedJwt.serialized);

      expect(unverifiedSdJwt.isVerified != true, isTrue);

      final input = KbJwtSignerInput(
        sdJwtToken: unverifiedSdJwt,
        disclosuresToKeep: {},
        audience: 'https://example.com',
        holderPublicKey: null,
        signer: signer,
      );

      expect(
        () => validator.execute(input),
        throwsA(predicate((e) => e.toString().contains('must be verified'))),
      );
    });

    test('throws exception if disclosuresToKeep are not present in SD-JWT', () {
      final input = KbJwtSignerInput(
        sdJwtToken: sdJwtWithCnf,
        disclosuresToKeep: {
          Disclosure.from(
              salt: "dummy salt",
              claimValue: "dummy value",
              hasher: Base64EncodedOutputHasher.base64Sha256)
        },
        audience: 'https://example.com',
        holderPublicKey: null,
        signer: signer,
      );

      expect(
        () => validator.execute(input),
        throwsA(predicate(
            (e) => e.toString().contains('not all disclosuresToKeep'))),
      );
    });

    test('throws exception if cnf does not match holder key', () {
      final input = KbJwtSignerInput(
        sdJwtToken: sdJwtWithCnf,
        disclosuresToKeep: sdJwtWithCnf.disclosures,
        audience: 'https://example.com',
        holderPublicKey: SdPublicKey(
            File(
              'test/resources/ecdsa_sdjwt_test_private_key.pem',
            ).readAsStringSync(),
            SdJwtSignAlgorithm.es256),
        signer: signer,
      );

      expect(
        () => validator.execute(input),
        throwsA(predicate(
            (e) => e.toString().contains('`cnf` is invalid or missing'))),
      );
    });
  });
}
