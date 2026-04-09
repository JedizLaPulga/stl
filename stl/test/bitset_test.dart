import 'package:test/test.dart';
import 'package:stl/stl.dart';

void main() {
  group('BitSet', () {
    test('initializes with all bits set to false', () {
      final bits = BitSet(10);
      expect(bits.size(), equals(10));
      expect(bits.none(), isTrue);
      expect(bits.any(), isFalse);
      expect(bits.all(), isFalse);
      expect(bits.count(), equals(0));
      for (int i = 0; i < 10; i++) {
        expect(bits[i], isFalse);
      }
    });

    test('sets and resets specific bits', () {
      final bits = BitSet(16);
      bits.set(3);
      bits[5] = true;

      expect(bits[3], isTrue);
      expect(bits[5], isTrue);
      expect(bits[0], isFalse);
      expect(bits.count(), equals(2));

      bits.reset(3);
      expect(bits[3], isFalse);
      expect(bits.count(), equals(1));
    });

    test('flips bits correctly', () {
      final bits = BitSet(8);
      bits.set(0);
      bits.set(7);

      bits.flip(7); // Flips 7 to false
      expect(bits[7], isFalse);
      expect(bits.count(), equals(1));

      bits.flip(); // Flips ALL bits
      // 0 was true (now false). Everything else was false (now true). Length is 8.
      expect(bits[0], isFalse);
      expect(bits[7], isTrue);
      expect(bits[1], isTrue);
      expect(bits.count(), equals(7)); // 8 total - 1 that is false
    });

    test('any, all, none work correctly with boundaries', () {
      final bits = BitSet(35); // tests multi-word boundary
      expect(bits.none(), isTrue);

      bits.set(34); // Set the very last bit
      expect(bits.any(), isTrue);
      expect(bits.count(), equals(1));

      bits.flip(); // Flip all 35 bits
      expect(bits.all(), isFalse); // Wait, flip() makes all 35 bits true?
      // actually, if it was empty, and we set 1 bit, flip will make 34 true.
      bits.flip();
      
      // Let's manually set all bits to true
      for (int i = 0; i < 35; i++) bits.set(i);
      expect(bits.all(), isTrue);
    });

    test('checking bitset string visualization', () {
      final bits = BitSet(4);
      bits[0] = true;
      bits[2] = true;
      // Index runs right to left usually in bits visualization: 3, 2, 1, 0
      // So indices: 3:0, 2:1, 1:0, 0:1 => '0101'
      expect(bits.toString(), equals('0101'));
    });

    test('bounds checking', () {
      final bits = BitSet(5);
      expect(() => bits.set(5), throwsRangeError);
      expect(() => bits.set(-1), throwsRangeError);
      expect(() => bits.test(6), throwsRangeError);
    });
  });
}
