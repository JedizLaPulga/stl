import 'package:test/test.dart';
import 'package:stl/stl.dart';

void main() {
  group('PairwiseRange', () {
    test('yields consecutive pairs for 4 elements', () {
      final result = PairwiseRange([1, 2, 3, 4]).toList();
      expect(result.length, 3);
      expect(result[0], Pair(1, 2));
      expect(result[1], Pair(2, 3));
      expect(result[2], Pair(3, 4));
    });

    test('single element yields nothing', () {
      expect(PairwiseRange([42]).isEmpty, isTrue);
    });

    test('empty iterable yields nothing', () {
      expect(PairwiseRange([]).isEmpty, isTrue);
    });

    test('two elements yields exactly one pair', () {
      final result = PairwiseRange(['x', 'y']).toList();
      expect(result.length, 1);
      expect(result[0], Pair('x', 'y'));
    });

    test('pairs share elements correctly (sliding)', () {
      final result = PairwiseRange([10, 20, 30]).toList();
      expect(result[0].second, result[1].first);
    });

    test('is re-iterable', () {
      final range = PairwiseRange([1, 2, 3]);
      expect(range.length, 2);
      expect(range.first, Pair(1, 2));
    });
  });
}
