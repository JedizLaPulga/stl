import 'package:test/test.dart';
import 'package:stl/stl.dart';

void main() {
  group('ChunkByRange', () {
    test('groups consecutive equal elements', () {
      final result = ChunkByRange([
        1,
        1,
        2,
        2,
        2,
        3,
      ], (a, b) => a == b).toList();
      expect(result, [
        [1, 1],
        [2, 2, 2],
        [3],
      ]);
    });

    test('groups ascending runs', () {
      final result = ChunkByRange([1, 2, 3, 1, 2], (a, b) => b >= a).toList();
      expect(result, [
        [1, 2, 3],
        [1, 2],
      ]);
    });

    test('every element different yields single-element chunks', () {
      final result = ChunkByRange([1, 2, 3], (a, b) => a == b).toList();
      expect(result, [
        [1],
        [2],
        [3],
      ]);
    });

    test('all elements same yields one chunk', () {
      final result = ChunkByRange([5, 5, 5, 5], (a, b) => a == b).toList();
      expect(result, [
        [5, 5, 5, 5],
      ]);
    });

    test('single element yields one chunk', () {
      expect(ChunkByRange([42], (a, b) => a == b).toList(), [
        [42],
      ]);
    });

    test('empty source yields no chunks', () {
      expect(ChunkByRange(<int>[], (a, b) => a == b).isEmpty, isTrue);
    });

    test('is re-iterable', () {
      final range = ChunkByRange([1, 1, 2], (a, b) => a == b);
      expect(range.toList(), range.toList());
    });

    test('works with strings grouped by first character', () {
      final words = ['ant', 'ape', 'bee', 'cat', 'cow'];
      final result = ChunkByRange(words, (a, b) => a[0] == b[0]).toList();
      expect(result, [
        ['ant', 'ape'],
        ['bee'],
        ['cat', 'cow'],
      ]);
    });
  });
}
