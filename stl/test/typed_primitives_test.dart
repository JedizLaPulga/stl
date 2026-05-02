import 'package:test/test.dart';
import 'package:stl/stl.dart';

void main() {
  group('TypedData Primitives Tests', () {
    test('Int8 bounds and operations', () {
      final a = Int8.from(120);
      final b = Int8.from(10);
      final c = a + b;

      // Native Int8List auto-wraps (130 wraps to -126 in 8-bit signed)
      expect(c.value, equals(-126));

      expect(() => a.addChecked(b), throwsStateError);

      final d = Int8.from(5) * Int8.from(3);
      expect(d.value, equals(15));
    });

    test('Uint8 bounds and operations', () {
      final a = Uint8.from(255);
      final b = Uint8.from(2);
      final c = a + b; // 257 wraps to 1 in 8-bit unsigned

      expect(c.value, equals(1));
      expect(() => a.addChecked(b), throwsStateError);
    });

    test('Int64 specific boundaries and wrap handling', () {
      final a = Int64.max;
      final b = Int64.from(1);

      final c = a + b;
      expect(c.value, equals(-9223372036854775808)); // Wrap around

      expect(() => a.addChecked(b), throwsStateError);

      final d = Int64.min - Int64.from(1);
      expect(d.value, equals(9223372036854775807));
      expect(() => Int64.min.subChecked(Int64.from(1)), throwsStateError);
    });

    test('Uint64 logic tracking', () {
      final a = Uint64.max; // Should be -1 natively in Dart Int representation
      expect(a.value, equals(-1));

      final b = Uint64.from(1);
      expect((a + b).value, equals(0));
      expect(() => a.addChecked(b), throwsStateError);

      final c = Uint64.from(0);
      expect((c - b).value, equals(-1));
      expect(() => c.subChecked(b), throwsStateError);

      expect(a > c, isTrue); // Unsigned comparison treats -1 as strictly > 0
    });
  });

  group('BigInt interop (heap-allocated)', () {
    test('Int8 toBigInt / fromBigInt', () {
      expect(Int8.from(42).toBigInt(), equals(BigInt.from(42)));
      expect(Int8.from(-128).toBigInt(), equals(BigInt.from(-128)));
      expect(Int8.fromBigInt(BigInt.from(127)).value, equals(127));
      expect(Int8.fromBigInt(BigInt.from(-128)).value, equals(-128));
      expect(() => Int8.fromBigInt(BigInt.from(128)), throwsRangeError);
      expect(() => Int8.fromBigInt(BigInt.from(-129)), throwsRangeError);
    });

    test('Uint8 toBigInt / fromBigInt', () {
      expect(Uint8.from(255).toBigInt(), equals(BigInt.from(255)));
      expect(Uint8.from(0).toBigInt(), equals(BigInt.zero));
      expect(Uint8.fromBigInt(BigInt.from(200)).value, equals(200));
      expect(() => Uint8.fromBigInt(BigInt.from(256)), throwsRangeError);
      expect(() => Uint8.fromBigInt(BigInt.from(-1)), throwsRangeError);
    });

    test('Int64 toBigInt / fromBigInt', () {
      expect(Int64.from(0).toBigInt(), equals(BigInt.zero));
      expect(Int64.from(-1).toBigInt(), equals(BigInt.from(-1)));
      expect(Int64.fromBigInt(BigInt.from(-1)).value, equals(-1));
      expect(
        () => Int64.fromBigInt(BigInt.parse('9223372036854775808')),
        throwsRangeError,
      );
    });

    test('Uint64 toBigInt / fromBigInt round-trip', () {
      final maxU64 = BigInt.parse('18446744073709551615');
      expect(Uint64.max.toBigInt(), equals(maxU64));
      expect(Uint64.fromBigInt(maxU64).value, equals(-1));
      expect(Uint64.fromBigInt(BigInt.zero).value, equals(0));
      expect(() => Uint64.fromBigInt(BigInt.from(-1)), throwsRangeError);
      expect(
        () => Uint64.fromBigInt(BigInt.parse('18446744073709551616')),
        throwsRangeError,
      );
    });
  });

  group('negChecked (heap-allocated signed)', () {
    test('Int8 negChecked', () {
      expect(Int8.from(0).negChecked().value, equals(0));
      expect(Int8.from(1).negChecked().value, equals(-1));
      expect(Int8.from(127).negChecked().value, equals(-127));
      expect(Int8.from(-127).negChecked().value, equals(127));
      expect(() => Int8.from(-128).negChecked(), throwsStateError);
    });

    test('Int64 negChecked', () {
      expect(Int64.from(1).negChecked().value, equals(-1));
      expect(Int64.from(-1).negChecked().value, equals(1));
      expect(
        Int64.from(9223372036854775807).negChecked().value,
        equals(-9223372036854775807),
      );
      expect(() => Int64.min.negChecked(), throwsStateError);
    });
  });

  group('wideningMul (heap-allocated)', () {
    test('Int8 × Int8 → Int16', () {
      final result = Int8.from(127).wideningMul(Int8.from(2));
      expect(result, isA<Int16>());
      expect(result.value, equals(254));
    });

    test('Uint8 × Uint8 → Uint16', () {
      final result = Uint8.from(255).wideningMul(Uint8.from(255));
      expect(result, isA<Uint16>());
      expect(result.value, equals(65025));
    });

    test('Int32 × Int32 → Int64', () {
      final result = Int32.from(2147483647).wideningMul(Int32.from(2));
      expect(result, isA<Int64>());
      expect(result.value, equals(4294967294));
    });

    test('Int64 × Int64 → BigInt', () {
      final result = Int64.from(9223372036854775807).wideningMul(Int64.from(2));
      expect(result, isA<BigInt>());
      expect(result, equals(BigInt.parse('18446744073709551614')));
    });

    test('Uint32 × Uint32 → Uint64', () {
      final result = Uint32.from(4294967295).wideningMul(Uint32.from(2));
      expect(result, isA<Uint64>());
      expect(result.toBigInt(), equals(BigInt.parse('8589934590')));
    });

    test('Uint64 × Uint64 → BigInt', () {
      final result = Uint64.max.wideningMul(Uint64.from(2));
      expect(result, isA<BigInt>());
      expect(result, equals(BigInt.parse('36893488147419103230')));
    });
  });
}
