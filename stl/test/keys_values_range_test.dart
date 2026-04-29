import 'package:test/test.dart';
import 'package:stl/stl.dart';

void main() {
  group('KeysRange', () {
    test('extracts keys from a list of Pairs', () {
      final pairs = [Pair('a', 1), Pair('b', 2), Pair('c', 3)];
      expect(KeysRange(pairs).toList(), ['a', 'b', 'c']);
    });

    test('empty source yields no keys', () {
      expect(KeysRange(<Pair<String, int>>[]).isEmpty, isTrue);
    });

    test('single pair yields one key', () {
      expect(KeysRange([Pair('x', 0)]).toList(), ['x']);
    });

    test('is re-iterable', () {
      final pairs = [Pair(1, 'one'), Pair(2, 'two')];
      final range = KeysRange(pairs);
      expect(range.toList(), range.toList());
    });

    test('composes with SortedMap iteration', () {
      final map = SortedMap<String, int>((a, b) => a.compareTo(b));
      map['alpha'] = 1;
      map['beta'] = 2;
      map['gamma'] = 3;
      expect(KeysRange(map).toList(), ['alpha', 'beta', 'gamma']);
    });
  });

  group('ValuesRange', () {
    test('extracts values from a list of Pairs', () {
      final pairs = [Pair('a', 10), Pair('b', 20), Pair('c', 30)];
      expect(ValuesRange(pairs).toList(), [10, 20, 30]);
    });

    test('empty source yields no values', () {
      expect(ValuesRange(<Pair<String, int>>[]).isEmpty, isTrue);
    });

    test('single pair yields one value', () {
      expect(ValuesRange([Pair('x', 99)]).toList(), [99]);
    });

    test('is re-iterable', () {
      final pairs = [Pair(1, 'one'), Pair(2, 'two')];
      final range = ValuesRange(pairs);
      expect(range.toList(), range.toList());
    });

    test('composes with SortedMap iteration', () {
      final map = SortedMap<String, int>((a, b) => a.compareTo(b));
      map['alpha'] = 1;
      map['beta'] = 2;
      map['gamma'] = 3;
      expect(ValuesRange(map).toList(), [1, 2, 3]);
    });

    test('KeysRange and ValuesRange are complementary', () {
      final pairs = [Pair('x', 10), Pair('y', 20), Pair('z', 30)];
      final keys = KeysRange(pairs).toList();
      final values = ValuesRange(pairs).toList();
      final restored = List.generate(
        keys.length,
        (i) => Pair(keys[i], values[i]),
      );
      expect(restored, pairs);
    });
  });
}
