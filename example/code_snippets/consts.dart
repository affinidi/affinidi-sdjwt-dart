// ⚠️ CAUTION: The following keys are for quickstart and testing purposes only.
// These keys are publicly exposed and MUST NOT be used in any production or real project.
// Always generate and use your own secure keys for real-world use.
const privateKeyPem = r'''
-----BEGIN PRIVATE KEY-----
MIGHAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBG0wawIBAQQgRfYYQILHnIkhWOz2
gUl+dfvtkTQDx9OEJaqvKgZaIDuhRANCAATJZsFS61jqyM1ST6riibMlnnA5sTbv
5L1uGdTg7vBADB6xz9AnEMyHnWolqtqXD5n63dw7uDWC1E7jlqzVUOq1
-----END PRIVATE KEY-----
''';

const publicKeyPem = r'''
-----BEGIN PUBLIC KEY-----
MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEyWbBUutY6sjNUk+q4omzJZ5wObE2
7+S9bhnU4O7wQAwesc/QJxDMh51qJaralw+Z+t3cO7g1gtRO45as1VDqtQ==
-----END PUBLIC KEY-----
''';

const serializedSdJwt =
    r'eyJhbGciOiJFUzI1NksiLCJ0eXAiOiJzZCtqd3QifQ.eyJsYXN0X25hbWUiOiJCb3ciLCJfc2QiOlsicTdKeTRkVzVObEs3NXNiZzVNYzdUVzVzTEx3YktidVgxRHlxcGFsNHM2USJdLCJfc2RfYWxnIjoic2hhLTI1NiIsImNuZiI6eyJqd2siOnsia3R5IjoiRUMiLCJjcnYiOiJQLTI1NiIsIngiOiJ5V2JCVXV0WTZzak5Vay1xNG9tekpaNXdPYkUyNy1TOWJoblU0Tzd3UUF3IiwieSI6IkhySFAwQ2NRekllZGFpV3EycGNQbWZyZDNEdTROWUxVVHVPV3JOVlE2clUifX19.bGCJst5PfNV2rLsHaLwE6dTXbXkngycrdDpsKtaoqIf3xedfcgX80oZlcujlUY4cq4xE1C98hcie503-Fj2CtQ~WyJFZ1BHek9kSGY3dmNVRlhkNGRaTV93IiwiZmlyc3RfbmFtZSIsIlJhaW4iXQ==~';
