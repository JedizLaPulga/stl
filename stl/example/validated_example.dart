import 'package:stl/stl.dart';

// A simplified form validator to demonstrate Validated's error accumulation.
Validated<String, int> validateAge(int? age) {
  if (age == null) return Validated.invalid('Age is required.');
  if (age < 0) return Validated.invalid('Age must be non-negative.');
  if (age > 150) return Validated.invalid('Age seems unrealistically large.');
  return Validated.valid(age);
}

Validated<String, String> validateName(String? name) {
  if (name == null || name.isEmpty) {
    return Validated.invalid('Name is required.');
  }
  if (name.length < 2) return Validated.invalid('Name is too short.');
  return Validated.valid(name);
}

Validated<String, String> validateEmail(String? email) {
  if (email == null || email.isEmpty) {
    return Validated.invalid('Email is required.');
  }
  if (!email.contains('@')) return Validated.invalid('Email must contain @.');
  return Validated.valid(email);
}

void main() {
  print('--- Validated<E, A> Demonstration ---\n');

  // -----------------------------------------------------------------------
  // Happy path — all valid inputs
  // -----------------------------------------------------------------------
  final age = validateAge(25);
  final name = validateName('Alice');
  final email = validateEmail('alice@example.com');

  print('Happy path:');
  print('  age:   $age');
  print('  name:  $name');
  print('  email: $email');

  // Combine all three fields simultaneously with zip
  final combined = age.zip(name).zip(email);
  switch (combined) {
    case Valid(:final value):
      print('  Combined: $value');
    case Invalid(:final errors):
      print('  Errors: $errors');
  }

  // -----------------------------------------------------------------------
  // All fields invalid — every error is accumulated
  // -----------------------------------------------------------------------
  print('\nAll invalid inputs:');
  final badAge = validateAge(-5);
  final badName = validateName('');
  final badEmail = validateEmail('not-an-email');

  print('  badAge:   $badAge');
  print('  badName:  $badName');
  print('  badEmail: $badEmail');

  final allBad = badAge.zip(badName).zip(badEmail);
  switch (allBad) {
    case Valid(:final value):
      print('  Combined: $value');
    case Invalid(:final errors):
      // All errors are present — not just the first one!
      print('  All errors collected:');
      for (final e in errors) {
        print('    - $e');
      }
  }

  // -----------------------------------------------------------------------
  // map and mapError
  // -----------------------------------------------------------------------
  print('\nmap / mapError:');
  final mapped = validateAge(30).map((age) => 'Age is $age');
  print('  map:      $mapped');

  final errMapped = validateAge(-1).mapError((e) => 'VALIDATION FAILURE: $e');
  print('  mapError: $errMapped');

  // -----------------------------------------------------------------------
  // andThen — sequential chaining (short-circuits on first error)
  // -----------------------------------------------------------------------
  print('\nandThen chain:');
  final result = validateAge(20).andThen(
    (age) => age > 18
        ? Validated.valid('Adult (age $age)')
        : Validated.invalid('Must be over 18.'),
  );
  print('  andThen result: $result');

  // -----------------------------------------------------------------------
  // valueOr — safe extraction with fallback
  // -----------------------------------------------------------------------
  print('\nvalueOr:');
  print('  Valid.valueOr(0):   ${validateAge(42).valueOr(0)}');
  print('  Invalid.valueOr(0): ${validateAge(-1).valueOr(0)}');

  // -----------------------------------------------------------------------
  // invalidAll — multiple errors at once
  // -----------------------------------------------------------------------
  final multiError = Validated<String, int>.invalidAll([
    'Too short',
    'Too weak',
    'No digit',
  ]);
  print('\ninvalidAll: $multiError');
}
