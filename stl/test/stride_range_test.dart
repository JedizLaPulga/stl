import 'package:test/test.dart';
import 'package:stl/stl.dart';

void main() {
  group('StrideRange', () {
    test('stride 2 picks every other element', () {
      final result = StrideRange([1, 2, 3, 4, 5, 6], 2).toList();
      expect(result, [1, 3, 5]);
    });

    test('stride 3 picks every third element', () {
      final result = StrideRange([1, 2, 3, 4, 5, 6], 3).toList();
      expect(result, [1, 4]);
    });

    test('stride 1 yields all elements', () {
      final result = StrideRange([1, 2, 3], 1).toList();
      expect(result, [1, 2, 3]);
    });

    test('stride larger than length yields first element only', () {
      final result = StrideRange([1, 2, 3], 10).toList();
      expect(result, [1]);
    });

    test('throws ArgumentError on stride of 0', () {
      expect(() => StrideRange([1, 2, 3], 0), throwsArgumentError);
    });

    test('throws ArgumentError on negative stride', () {
      expect(() => StrideRange([1, 2, 3], -1), throwsArgumentError);
    });

    test('empty iterable yields nothing', () {
      expect(StrideRange([], 2).isEmpty, isTrue);
    });

    test('is re-iterable', () {
      final range = StrideRange([10, 20, 30, 40], 2);
      expect(range.toList(), [10, 30]);
      expect(range.toList(), [10, 30]);
    });
  });
}
