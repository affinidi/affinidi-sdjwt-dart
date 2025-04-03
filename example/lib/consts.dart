const claimsText =
    '{\n  "name": "John Doe",\n  "email": "john@example.com",\n  "age": 30\n}';

const basicProfileClaims = {
  'name': 'John Doe',
  'email': 'john@example.com',
  'age': 30,
};

const multipleContactPointsClaims = {
  'name': 'Jane Smith',
  'emails': ['jane@example.com', 'jane.smith@work.com'],
  'roles': ['admin', 'user'],
};

const complexIdentityClaims = {
  'name': 'Alice Wonderland',
  'address': {
    'street': '123 Main St',
    'city': 'Wonderland',
    'zip': '12345',
  },
  'preferences': {
    'newsletter': true,
    'notifications': {
      'email': true,
      'sms': false,
    },
  },
};

const privateRsaKeyText = """
-----BEGIN PRIVATE KEY-----
MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCbAZ4FPjHPNOlf
PTnMwdgwaSWmLkQdSSfPB8OrL8dAkWJEVrA3mLcQCkZ1yWNayKsE2S/G4mRODJHa
cQKOVvcBYGue0ZeJRJe/u62MwYbYnPcs3mJF2sZt4uKzuwmBWpSBBlypZh8wNGGf
0gP1WevudXCy2qUs2ONGIm0kd8AgsEitDxK4R6BTg8fjPQ2SgyFddEkFAqfQWtcj
gdIA5cY2FF2lAarRtkBf9WkBSjLJnx5z1cHbpsaq35gAuU+T4rZdojApS3HhO7mL
SVbAkOsdBKLAkOn9fZykcJy0zrQftcKMQ//vCvcIy04ScwoB4wI3yYN0JKlP3iqq
WxHbMjAbAgMBAAECggEALm/GGNkAkAxQa8VKVxKtgxdE/at3oXRklivDzTmTjj7f
uwxjX0yDby083ZWXC7/5KAsuunzhQtaWLWRUuTLJbeKmax5sMOXZNknx3Kyvip4/
mHQI6dd4QbxKYUDDwLpTqfGvedpLtqPCqV//6pVlTntlZ1eES1Kwh7bRjq7HYqMl
YXNWRqqzhIdaHftH1rGq9GUuFt1ITBIFl8Ey0K0lnW39Tyt3YqTeKdV5yoDMKM0w
juDwn2aIq0AuYCIeRg45ni4mXpxlem92Lm6+AXFqdrM2bYBsvufkppE7s3gqkZ2i
tjS+NsW2U7k7C7OmnUyrSFLWMfOWbUsjZz38wrFocQKBgQDY2eoKVp883YcbvZ8Y
MJs2658KPnz0Yu6JvhDo3i4fiMWn5gTT2I3cq53j3FzC3p8P1uK18gE8O32uIK6W
0HxWTx4VtdfvmM+osqOEkpUYgc25HlE1gG7LKI0wTbYcvbKbFfkBZx3L5xGlUEQ8
F0o9qlIiUNaMolHUXDwXtuJLkQKBgQC2/XQDXjI72HjIHHIKCVUTazAZyjocr6nJ
CniaTcdq+ioD5+giGH5Z5y92fR8ot7Gn4N6HnXvyFZyAnT5UwJpiohSqVrq++Y6Q
uHSh5omwAzKfBAKdSAos+osqd/uz/JK/adW3cUWx74ZJ7wjCVqWQfqcMr/3YjQ+S
TIMaZCyy6wKBgQDYpWV4LLBsO5oW8ev3W+BGD0LWFjX6ZriQLq5wKEEGSjvGkTxz
dZ/NPjvBAVA/c/CP/4yCYCQxy/G1PHuQuvvtsp+I6yKwAgg9LzPEaDnCwTQJ5SsW
+5g1Ke9cudbegfrljB848o9HPjRX54g0TMRkNTxXglHHMQf11KxIuPL+sQKBgQCt
i04da5Zkn3ZdAm09C4C9++gQbXQThJ2XZvDeFmnMERkLv0KuI2ChTtn6m8uTSDOa
rW8eWsMT4l8cswRMSKWiaWkD62EMgY0tv2INsaBfZ4j4ukroc0wDQFH/ou750c4y
7uKbKTgZ+rn3IFXESXyXvyYaqEYsvAtKinnD68FgpQKBgFZHSxJrP/4X3T+dn4p9
8MtA9XPIPC7xgw+7LEsCmvXCngH/dMtWMOQgJbP1G/7x7cZi/kUqaUcsVkz+3Nne
b6zUMe/FXnxiU7BSLxOgHTQUBxDbsf3tLPJRWzHqiz4hpcAL+EckTcle+pfx6fZu
y3hC/MV7oC0ifrALGqHlRLv8
-----END PRIVATE KEY-----

""";

const publicRsaKeyText = """
-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAmwGeBT4xzzTpXz05zMHY
MGklpi5EHUknzwfDqy/HQJFiRFawN5i3EApGdcljWsirBNkvxuJkTgyR2nECjlb3
AWBrntGXiUSXv7utjMGG2Jz3LN5iRdrGbeLis7sJgVqUgQZcqWYfMDRhn9ID9Vnr
7nVwstqlLNjjRiJtJHfAILBIrQ8SuEegU4PH4z0NkoMhXXRJBQKn0FrXI4HSAOXG
NhRdpQGq0bZAX/VpAUoyyZ8ec9XB26bGqt+YALlPk+K2XaIwKUtx4Tu5i0lWwJDr
HQSiwJDp/X2cpHCctM60H7XCjEP/7wr3CMtOEnMKAeMCN8mDdCSpT94qqlsR2zIw
GwIDAQAB
-----END PUBLIC KEY-----

""";

const privateEcdsaKeyText = """
-----BEGIN PRIVATE KEY-----
MIGHAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBG0wawIBAQQgRfYYQILHnIkhWOz2
gUl+dfvtkTQDx9OEJaqvKgZaIDuhRANCAATJZsFS61jqyM1ST6riibMlnnA5sTbv
5L1uGdTg7vBADB6xz9AnEMyHnWolqtqXD5n63dw7uDWC1E7jlqzVUOq1
-----END PRIVATE KEY-----

""";

const publicEcdsaKeyText = """
-----BEGIN PUBLIC KEY-----
MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEyWbBUutY6sjNUk+q4omzJZ5wObE2
7+S9bhnU4O7wQAwesc/QJxDMh51qJaralw+Z+t3cO7g1gtRO45as1VDqtQ==
-----END PUBLIC KEY-----

""";
