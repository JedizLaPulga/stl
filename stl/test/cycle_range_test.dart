import 'package:test/test.dart';
import 'package:stl/stl.dart';

void main() {
  group('CycleRange', () {
    test('2 full cycles produce correct sequence', () {
      final result = CycleRange([1, 2, 3], 2).toList();
      expect(result, [1, 2, 3, 1, 2, 3]);
    });

    test('1 cycle is equivalent to the source iterable', () {
      final result = CycleRange([10, 20, 30], 1).toList();
      expect(result, [10, 20, 30]);
    });

    test('0 cycles yields nothing', () {
      final result = CycleRange([1, 2, 3], 0).toList();
      expect(result.isEmpty, isTrue);
    });

    test('infinite cycle limited by TakeRange', () {
      final result = TakeRange(CycleRange([1, 2]), 7).toList();
      expect(result, [1, 2, 1, 2, 1, 2, 1]);
    });

    test('throws ArgumentError for empty iterable', () {
      expect(() => CycleRange([]), throwsArgumentError);
    });

    test('throws ArgumentError for negative bound', () {
      expect(() => CycleRange([1, 2], -1), throwsArgumentError);
    });

    test('is re-iterable', () {
      final range = CycleRange(['a', 'b'], 2);
      expect(range.toList(), ['a', 'b', 'a', 'b']);
      expect(range.toList(), ['a', 'b', 'a', 'b']);
    });

    test('works with single-element source', () {
      final result = CycleRange([42], 4).toList();
      expect(result, [42, 42, 42, 42]);
    });
  });
}
