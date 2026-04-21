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
}
