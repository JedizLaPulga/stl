import 'package:test/test.dart';
import 'package:stl/src/ranges/join_range.dart';

void main() {
  group('JoinRange', () {
    test('flattens list of lists', () {
      final list = [[1, 2], [3, 4], [5]];
      final range = JoinRange(list);
      expect(range.toList(), equals([1, 2, 3, 4, 5]));
    });

    test('handles empty sublists', () {
      final list = [[1, 2], [], [3, 4], [], [5]];
      final range = JoinRange(list);
      expect(range.toList(), equals([1, 2, 3, 4, 5]));
    });

    test('handles empty main list', () {
      final list = <List<int>>[];
      final range = JoinRange(list);
      expect(range.toList(), isEmpty);
    });

    test('handles all empty sublists', () {
      final list = <List<int>>[[], [], []];
      final range = JoinRange(list);
      expect(range.toList(), isEmpty);
    });

    test('iterator throws StateError when current is accessed before moveNext', () {
      final list = [[1, 2]];
      final range = JoinRange(list);
      final it = range.iterator;
      expect(() => it.current, throwsStateError);
    });
  });
}
