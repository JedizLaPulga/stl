import 'package:test/test.dart';
import 'package:stl/stl.dart';

void main() {
  group('EnumerateRange', () {
    test('yields index-element pairs starting at 0', () {
      final result = EnumerateRange(['a', 'b', 'c']).toList();

      expect(result.length, 3);
      expect(result[0], Pair(0, 'a'));
      expect(result[1], Pair(1, 'b'));
      expect(result[2], Pair(2, 'c'));
    });

    test('indices are correct for integer elements', () {
      final result = EnumerateRange([10, 20, 30]).toList();

      expect(result[0].first, 0);
      expect(result[0].second, 10);
      expect(result[2].first, 2);
      expect(result[2].second, 30);
    });

    test('empty iterable yields nothing', () {
      final result = EnumerateRange([]).toList();
      expect(result.isEmpty, isTrue);
    });

    test('single element yields one pair at index 0', () {
      final result = EnumerateRange(['only']).toList();
      expect(result.length, 1);
      expect(result[0], Pair(0, 'only'));
    });

    test('is re-iterable', () {
      final range = EnumerateRange([1, 2, 3]);
      expect(range.length, 3);
      expect(range.first, Pair(0, 1));
    });

    test('works with generator iterables', () {
      final result = EnumerateRange(
        Iterable.generate(4, (i) => i * 2),
      ).toList();
      expect(result[3], Pair(3, 6));
    });
  });
}
