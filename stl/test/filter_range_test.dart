import 'package:test/test.dart';
import 'package:stl/src/ranges/filter_range.dart';

void main() {
  group('FilterRange', () {
    test('filters elements based on predicate', () {
      final list = [1, 2, 3, 4, 5, 6];
      final range = FilterRange(list, (int x) => x % 2 == 0);
      expect(range.toList(), equals([2, 4, 6]));
    });

    test('returns empty if no elements match', () {
      final list = [1, 3, 5];
      final range = FilterRange(list, (int x) => x % 2 == 0);
      expect(range.toList(), isEmpty);
    });

    test('returns all elements if all match', () {
      final list = [2, 4, 6];
      final range = FilterRange(list, (int x) => x % 2 == 0);
      expect(range.toList(), equals([2, 4, 6]));
    });

    test('handles empty iterable', () {
      final list = <int>[];
      final range = FilterRange(list, (int x) => x % 2 == 0);
      expect(range.toList(), isEmpty);
    });

    test(
      'iterator throws StateError when current is accessed before moveNext',
      () {
        final list = [1, 2, 3];
        final range = FilterRange(list, (int x) => true);
        final it = range.iterator;
        expect(() => it.current, throwsStateError);
      },
    );
  });
}
