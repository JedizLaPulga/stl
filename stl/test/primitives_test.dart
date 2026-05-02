import 'package:test/test.dart';
import 'package:stl/stl.dart';

void main() {
  group('Primitive Integer Wrappers', () {
    test('I32 operations', () {
      expect(I32.max.value, equals(2147483647));
      expect((I32(2147483647) + I32(1)).value, equals(-2147483648));
      expect(() => I32(2147483647).addChecked(I32(1)), throwsStateError);
    });

    test('I64 operations', () {
      expect(
        (I64(9223372036854775807) + I64(1)).value,
        equals(-9223372036854775808),
      );
      expect(
        () => I64(9223372036854775807).addChecked(I64(1)),
        throwsStateError,
      );
      expect(
        (I64(-9223372036854775808) - I64(1)).value,
        equals(9223372036854775807),
      );
    });

    test('U8 operations', () {
      expect(U8.max.value, equals(255));
      expect((U8(255) + U8(1)).value, equals(0));
      expect(() => U8(255).addChecked(U8(1)), throwsStateError);
      expect((U8(0) - U8(1)).value, equals(255));
    });

    test('U16 operations', () {
      expect(U16.max.value, equals(65535));
      expect((U16(65535) + U16(1)).value, equals(0));
    });

    test('U32 operations', () {
      expect(U32.max.value, equals(4294967295));
      expect((U32(4294967295) + U32(1)).value, equals(0));
    });

    test('U64 operations', () {
      // Dart internally tests the max value of 64-bit safely
      expect((U64(-1) + U64(1)).value, equals(0));
      // Test comparison override
      expect(
        U64(-1) > U64(0),
        isTrue,
      ); // In signed logic, -1 > 0 is false. U64 makes it true!
      // Test Unsigned Division
      expect((U64(-1) ~/ U64(2)).value, equals(9223372036854775807));
    });
  });

  group('BigInt interop (zero-cost)', () {
    test('I8 toBigInt / fromBigInt', () {
      expect(I8(42).toBigInt(), equals(BigInt.from(42)));
      expect(I8(-128).toBigInt(), equals(BigInt.from(-128)));
      expect(I8.fromBigInt(BigInt.from(127)).value, equals(127));
      expect(I8.fromBigInt(BigInt.from(-128)).value, equals(-128));
      expect(() => I8.fromBigInt(BigInt.from(128)), throwsRangeError);
      expect(() => I8.fromBigInt(BigInt.from(-129)), throwsRangeError);
    });

    test('U8 toBigInt / fromBigInt', () {
      expect(U8(255).toBigInt(), equals(BigInt.from(255)));
      expect(U8(0).toBigInt(), equals(BigInt.zero));
      expect(U8.fromBigInt(BigInt.from(200)).value, equals(200));
      expect(() => U8.fromBigInt(BigInt.from(256)), throwsRangeError);
      expect(() => U8.fromBigInt(BigInt.from(-1)), throwsRangeError);
    });

    test('I64 toBigInt / fromBigInt', () {
      expect(I64(0).toBigInt(), equals(BigInt.zero));
      expect(
        I64(9223372036854775807).toBigInt(),
        equals(BigInt.parse('9223372036854775807')),
      );
      expect(I64.fromBigInt(BigInt.from(-1)).value, equals(-1));
      expect(
        () => I64.fromBigInt(BigInt.parse('9223372036854775808')),
        throwsRangeError,
      );
    });

    test('U64 toBigInt / fromBigInt round-trip', () {
      // U64(-1) is the max unsigned 64-bit value
      final maxU64 = BigInt.parse('18446744073709551615');
      expect(U64(-1).toBigInt(), equals(maxU64));
      expect(U64.fromBigInt(maxU64).value, equals(-1));
      expect(U64.fromBigInt(BigInt.zero).value, equals(0));
      expect(() => U64.fromBigInt(BigInt.from(-1)), throwsRangeError);
      expect(
        () => U64.fromBigInt(BigInt.parse('18446744073709551616')),
        throwsRangeError,
      );
    });
  });

  group('negChecked (zero-cost signed)', () {
    test('I8 negChecked', () {
      expect(I8(0).negChecked().value, equals(0));
      expect(I8(1).negChecked().value, equals(-1));
      expect(I8(127).negChecked().value, equals(-127));
      expect(I8(-127).negChecked().value, equals(127));
      expect(() => I8(-128).negChecked(), throwsStateError);
    });

    test('I64 negChecked', () {
      expect(I64(1).negChecked().value, equals(-1));
      expect(I64(-1).negChecked().value, equals(1));
      expect(
        I64(9223372036854775807).negChecked().value,
        equals(-9223372036854775807),
      );
      expect(() => I64(-9223372036854775808).negChecked(), throwsStateError);
    });
  });

  group('wideningMul (zero-cost)', () {
    test('I8 × I8 → I16', () {
      final result = I8(127).wideningMul(I8(2));
      expect(result, isA<I16>());
      expect(result.value, equals(254));
      // Verify no overflow — result exceeds I8.max
      expect(result.value > 127, isTrue);
    });

    test('U8 × U8 → U16', () {
      final result = U8(255).wideningMul(U8(255));
      expect(result, isA<U16>());
      expect(result.value, equals(65025));
    });

    test('I32 × I32 → I64', () {
      final result = I32(2147483647).wideningMul(I32(2));
      expect(result, isA<I64>());
      expect(result.value, equals(4294967294));
    });

    test('I64 × I64 → BigInt', () {
      final result = I64(9223372036854775807).wideningMul(I64(2));
      expect(result, isA<BigInt>());
      expect(result, equals(BigInt.parse('18446744073709551614')));
    });

    test('U64 × U64 → BigInt', () {
      // U64(-1) == max uint64
      final result = U64(-1).wideningMul(U64(2));
      expect(result, isA<BigInt>());
      expect(result, equals(BigInt.parse('36893488147419103230')));
    });
  });
}
