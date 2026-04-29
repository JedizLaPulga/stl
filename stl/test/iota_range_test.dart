import 'package:test/test.dart';
import 'package:stl/stl.dart';

void main() {
  group('IotaRange', () {
    test('yields [start, end) for bounded range', () {
      expect(IotaRange(0, 5).toList(), [0, 1, 2, 3, 4]);
    });

    test('yields empty list when start == end', () {
      expect(IotaRange(3, 3).toList(), isEmpty);
    });

    test('yields single element when end == start + 1', () {
      expect(IotaRange(7, 8).toList(), [7]);
    });

    test('yields correct sequence with negative start', () {
      expect(IotaRange(-3, 3).toList(), [-3, -2, -1, 0, 1, 2]);
    });

    test('infinite range yields correct prefix via take()', () {
      expect(IotaRange(0).take(5).toList(), [0, 1, 2, 3, 4]);
    });

    test('infinite range starting at positive value', () {
      expect(IotaRange(10).take(4).toList(), [10, 11, 12, 13]);
    });

    test('throws ArgumentError when end < start', () {
      expect(() => IotaRange(5, 3), throwsArgumentError);
    });

    test('is re-iterable', () {
      final range = IotaRange(1, 4);
      expect(range.toList(), [1, 2, 3]);
      expect(range.toList(), [1, 2, 3]);
    });

    test('composes with FilterRange to yield even numbers', () {
      final evens = FilterRange(IotaRange(0, 10), (n) => n % 2 == 0);
      expect(evens.toList(), [0, 2, 4, 6, 8]);
    });

    test('composes with TransformRange', () {
      final squares = TransformRange<int, int>(IotaRange(1, 5), (n) => n * n);
      expect(squares.toList(), [1, 4, 9, 16]);
    });
  });
}
