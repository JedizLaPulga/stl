import 'package:test/test.dart';
import 'package:stl/stl.dart';

void main() {
  group('Array<T>', () {
    test('initializes with fixed sizes securely preventing expansions dynamically', () {
      final arr = Array<int>(5, 0);
      expect(arr.length, equals(5));
      expect(arr.size(), equals(5));

      arr[0] = 10;
      expect(arr.front, equals(10));
      expect(arr.back, equals(0));

      expect(() => arr.add(99), throwsUnsupportedError);
      expect(() => arr.remove(10), throwsUnsupportedError);
      expect(() => arr.clear(), throwsUnsupportedError);
      expect(() => arr.length = 10, throwsUnsupportedError);
    });

    test('generates array dynamically executing fixed mappings tightly', () {
      final arr = Array<int>.generate(4, (i) => i * 2);
      expect(arr.toList(), equals([0, 2, 4, 6]));
      
      expect(arr.at(1), equals(2));
      expect(arr.at(99), isNull);
    });

    test('fills sequences seamlessly bounded strictly mathematically', () {
      final sequence = Array<String>(3, 'A');
      sequence.fill('Z');
      expect(sequence.toList(), equals(['Z', 'Z', 'Z']));
    });

    test('operator + joins dynamic bounds accurately maintaining tight structures natively', () {
      final arr = Array<int>(3, 5);
      final sequenceToAppend = [7, 7];

      final combinedList = arr + sequenceToAppend;
      expect(combinedList, equals([5, 5, 5, 7, 7]));
      
      // Original bounds securely unchanged!
      expect(arr.length, equals(3));
      expect(() => arr.add(1), throwsUnsupportedError);
    });

    test('deep equality checking via ListBase structural hashing iteratively', () {
      final arrA = Array<int>.generate(3, (i) => i);
      expect(arrA, equals([0, 1, 2])); // Resolves effectively!
    });
  });
}
