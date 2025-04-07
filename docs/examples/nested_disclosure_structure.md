## Creating a Nested Disclosure Structure

```dart
final claims = {
  'address': {
    'street': '123 Main St',
    'city': 'Anytown',
    'state': 'CA',
    'postal_code': '12345',
    'country': 'US'
  },
  'email': 'john.doe@example.com',
};

// Make email and specific address fields selectively disclosable
final disclosureFrame = {
  '_sd': ['email'],
  'address': {
    '_sd': ['street', 'postal_code']
  }
};

final sdJwt = handler.sign(
  claims: claims,
  disclosureFrame: disclosureFrame,
  signer: signer,
);

print("SD-JWT with nested disclosures: ${sdJwt.serialized}");
```

## Array Element Disclosures

```dart
final claims = {
  'phones': [
    {'type': 'home', 'number': '555-1234'},
    {'type': 'work', 'number': '555-5678'},
  ],
};

// Make the phone numbers selectively disclosable while keeping types visible
final disclosureFrame = {
  'phones': [
    {'_sd': ['number']},
    {'_sd': ['number']}
  ]
};

final sdJwt = handler.sign(
  claims: claims,
  disclosureFrame: disclosureFrame,
  signer: signer,
);

print("SD-JWT with array disclosures: ${sdJwt.serialized}");
```