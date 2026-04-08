import 'package:test/test.dart';
import 'package:stl/stl.dart';

void main() {
  group('CartesianRange', () {
    test('generates full cartesian product', () {
      final a = [1, 2];
      final b = ['x', 'y', 'z'];
      final cartesian = CartesianRange(a, b).toList();

      expect(cartesian.length, 6); // 2 * 3 = 6
      expect(cartesian[0], Pair(1, 'x'));
      expect(cartesian[1], Pair(1, 'y'));
      expect(cartesian[2], Pair(1, 'z'));
      expect(cartesian[3], Pair(2, 'x'));
      expect(cartesian[4], Pair(2, 'y'));
      expect(cartesian[5], Pair(2, 'z'));
    });

    test('empty first iterable results in empty range', () {
      final cartesian = CartesianRange([], ['a', 'b']).toList();
      expect(cartesian.isEmpty, isTrue);
    });

    test('empty second iterable results in empty range', () {
      final cartesian = CartesianRange([1, 2], []).toList();
      expect(cartesian.isEmpty, isTrue);
    });
    
    test('works with single element iterables', () {
        final cartesian = CartesianRange([1], ['a']).toList();
        expect(cartesian.length, 1);
        expect(cartesian.first, Pair(1, 'a'));
    });
  });
}
