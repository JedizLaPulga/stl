import 'package:test/test.dart';
import 'package:stl/stl.dart';

void main() {
  group('ZipRange', () {
    test('zips two iterables of same length', () {
      final a = [1, 2, 3];
      final b = ['a', 'b', 'c'];
      final zip = ZipRange(a, b).toList();

      expect(zip.length, 3);
      expect(zip[0].first, 1);
      expect(zip[0].second, 'a');
      expect(zip[1], Pair(2, 'b'));
      expect(zip[2], Pair(3, 'c'));
    });

    test('stops dynamically on shortest iterable (first shorter)', () {
      final a = [1, 2];
      final b = ['a', 'b', 'c', 'd'];
      final zip = ZipRange(a, b).toList();

      expect(zip.length, 2);
    });

    test('stops dynamically on shortest iterable (second shorter)', () {
      final a = [1, 2, 3, 4];
      final b = ['a'];
      final zip = ZipRange(a, b).toList();

      expect(zip.length, 1);
    });

    test('empty iterable results in empty zip', () {
      final z1 = ZipRange([], [1, 2, 3]);
      expect(z1.isEmpty, isTrue);

      final z2 = ZipRange([1, 2, 3], []);
      expect(z2.isEmpty, isTrue);
    });

    test('re-iterable without consuming original lists strictly', () {
        final a = [10, 20];
        final b = [100, 200];
        final zip = ZipRange(a, b);
        expect(zip.length, 2);
        // Second iteration
        expect(zip.first.first, 10);
    });
  });
}
