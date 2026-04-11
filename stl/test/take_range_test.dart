import 'package:test/test.dart';
import 'package:stl/src/ranges/take_range.dart';

void main() {
  group('TakeRange', () {
    test('takes the first N elements', () {
      final list = [1, 2, 3, 4, 5];
      final range = TakeRange(list, 3);
      expect(range.toList(), equals([1, 2, 3]));
    });

    test('returns all elements if N is greater than length', () {
      final list = [1, 2, 3];
      final range = TakeRange(list, 5);
      expect(range.toList(), equals([1, 2, 3]));
    });

    test('returns empty iterable if N is 0', () {
      final list = [1, 2, 3];
      final range = TakeRange(list, 0);
      expect(range.toList(), isEmpty);
    });

    test('throws ArgumentError if N is negative', () {
      final list = [1, 2, 3];
      expect(() => TakeRange(list, -1), throwsArgumentError);
    });

    test('handles empty underlying iterable', () {
      final list = <int>[];
      final range = TakeRange(list, 3);
      expect(range.toList(), isEmpty);
    });

    test('iterator throws StateError when current is accessed before moveNext', () {
      final list = [1, 2, 3];
      final range = TakeRange(list, 2);
      final it = range.iterator;
      expect(() => it.current, throwsStateError);
    });
  });
}
