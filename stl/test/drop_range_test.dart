import 'package:test/test.dart';
import 'package:stl/src/ranges/drop_range.dart';

void main() {
  group('DropRange', () {
    test('drops the first N elements', () {
      final list = [1, 2, 3, 4, 5];
      final range = DropRange(list, 2);
      expect(range.toList(), equals([3, 4, 5]));
    });

    test('returns empty iterable if N is greater than length', () {
      final list = [1, 2, 3];
      final range = DropRange(list, 5);
      expect(range.toList(), isEmpty);
    });

    test('returns all elements if N is 0', () {
      final list = [1, 2, 3];
      final range = DropRange(list, 0);
      expect(range.toList(), equals([1, 2, 3]));
    });

    test('throws ArgumentError if N is negative', () {
      final list = [1, 2, 3];
      expect(() => DropRange(list, -1), throwsArgumentError);
    });

    test('handles empty underlying iterable', () {
      final list = <int>[];
      final range = DropRange(list, 3);
      expect(range.toList(), isEmpty);
    });

    test('iterator skips elements correctly on first moveNext', () {
      final list = [1, 2, 3, 4];
      final range = DropRange(list, 2);
      final it = range.iterator;
      expect(it.moveNext(), isTrue);
      expect(it.current, equals(3));
      expect(it.moveNext(), isTrue);
      expect(it.current, equals(4));
      expect(it.moveNext(), isFalse);
    });
  });
}
