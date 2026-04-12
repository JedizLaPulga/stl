import 'package:test/test.dart';
import '../lib/src/primitives/i8.dart';
import '../lib/src/primitives/i16.dart';
import '../lib/src/primitives/i32.dart';
import '../lib/src/primitives/i64.dart';
import '../lib/src/primitives/u8.dart';
import '../lib/src/primitives/u16.dart';
import '../lib/src/primitives/u32.dart';
import '../lib/src/primitives/u64.dart';

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
}
