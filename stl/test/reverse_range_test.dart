import 'package:test/test.dart';
import 'package:stl/stl.dart';

void main() {
  group('ReverseRange', () {
    test('reverses a list of integers', () {
      final result = ReverseRange([1, 2, 3, 4, 5]).toList();
      expect(result, [5, 4, 3, 2, 1]);
    });

    test('reverses a list of strings', () {
      final result = ReverseRange(['a', 'b', 'c']).toList();
      expect(result, ['c', 'b', 'a']);
    });

    test('single element reversal is the same element', () {
      final result = ReverseRange([42]).toList();
      expect(result, [42]);
    });

    test('empty iterable reverses to empty', () {
      expect(ReverseRange([]).isEmpty, isTrue);
    });

    test('is re-iterable and consistent', () {
      final range = ReverseRange([10, 20, 30]);
      expect(range.toList(), [30, 20, 10]);
      expect(range.toList(), [30, 20, 10]);
    });

    test('first element is the last of source', () {
      expect(ReverseRange([1, 2, 3, 4]).first, 4);
    });

    test('last element is the first of source', () {
      expect(ReverseRange([1, 2, 3, 4]).last, 1);
    });
  });
}
