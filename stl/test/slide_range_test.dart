import 'package:test/test.dart';
import 'package:stl/stl.dart';

void main() {
  group('SlideRange', () {
    test('sliding window of size 3 over 5 elements', () {
      final result = SlideRange([1, 2, 3, 4, 5], 3).toList();
      expect(result.length, 3);
      expect(result[0], [1, 2, 3]);
      expect(result[1], [2, 3, 4]);
      expect(result[2], [3, 4, 5]);
    });

    test('window size equal to list length yields one window', () {
      final result = SlideRange([1, 2, 3], 3).toList();
      expect(result.length, 1);
      expect(result[0], [1, 2, 3]);
    });

    test('window size larger than list yields nothing', () {
      final result = SlideRange([1, 2], 5).toList();
      expect(result.isEmpty, isTrue);
    });

    test('window size 1 yields each element wrapped in a list', () {
      final result = SlideRange([1, 2, 3], 1).toList();
      expect(result, [
        [1],
        [2],
        [3],
      ]);
    });

    test('throws ArgumentError on window size of 0', () {
      expect(() => SlideRange([1, 2, 3], 0), throwsArgumentError);
    });

    test('throws ArgumentError on negative window size', () {
      expect(() => SlideRange([1, 2, 3], -2), throwsArgumentError);
    });

    test('empty iterable yields nothing', () {
      expect(SlideRange([], 2).isEmpty, isTrue);
    });

    test('is re-iterable', () {
      final range = SlideRange([1, 2, 3, 4], 2);
      expect(range.length, 3);
      expect(range.first, [1, 2]);
    });
  });
}
