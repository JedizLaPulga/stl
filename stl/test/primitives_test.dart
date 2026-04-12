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
    test('i32 operations', () {
      expect(i32.max.value, equals(2147483647));
      expect((i32(2147483647) + i32(1)).value, equals(-2147483648));
      expect(() => i32(2147483647).addChecked(i32(1)), throwsStateError);
    });

    test('i64 operations', () {
      expect((i64(9223372036854775807) + i64(1)).value, equals(-9223372036854775808));
      expect(() => i64(9223372036854775807).addChecked(i64(1)), throwsStateError);
      expect((i64(-9223372036854775808) - i64(1)).value, equals(9223372036854775807));
    });

    test('u8 operations', () {
      expect(u8.max.value, equals(255));
      expect((u8(255) + u8(1)).value, equals(0));
      expect(() => u8(255).addChecked(u8(1)), throwsStateError);
      expect((u8(0) - u8(1)).value, equals(255));
    });

    test('u16 operations', () {
      expect(u16.max.value, equals(65535));
      expect((u16(65535) + u16(1)).value, equals(0));
    });

    test('u32 operations', () {
      expect(u32.max.value, equals(4294967295));
      expect((u32(4294967295) + u32(1)).value, equals(0));
    });

    test('u64 operations', () {
      // Dart internally tests the max value of 64-bit safely
      expect((u64(-1) + u64(1)).value, equals(0));
      // Test comparison override
      expect(u64(-1) > u64(0), isTrue); // In signed logic, -1 > 0 is false. u64 makes it true!
      // Test Unsigned Division
      expect((u64(-1) ~/ u64(2)).value, equals(9223372036854775807)); 
    });
  });
}
