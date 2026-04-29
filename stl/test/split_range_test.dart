import 'package:test/test.dart';
import 'package:stl/stl.dart';

void main() {
  group('SplitRange', () {
    test('splits a list on a delimiter into correct segments', () {
      expect(SplitRange([1, 0, 2, 3, 0, 4], 0).toList(), [
        [1],
        [2, 3],
        [4],
      ]);
    });

    test('leading delimiter produces an empty first segment', () {
      expect(SplitRange([0, 1, 2], 0).toList(), [
        <int>[],
        [1, 2],
      ]);
    });

    test('trailing delimiter produces an empty last segment', () {
      expect(SplitRange([1, 2, 0], 0).toList(), [
        [1, 2],
        <int>[],
      ]);
    });

    test('consecutive delimiters produce empty segments between them', () {
      expect(SplitRange([1, 0, 0, 2], 0).toList(), [
        [1],
        <int>[],
        [2],
      ]);
    });

    test('empty source yields one empty segment', () {
      expect(SplitRange(<int>[], 0).toList(), [<int>[]]);
    });

    test('no delimiter in source yields one segment equal to source', () {
      expect(SplitRange([1, 2, 3], 0).toList(), [
        [1, 2, 3],
      ]);
    });

    test('source is entirely one delimiter yields two empty segments', () {
      expect(SplitRange([0], 0).toList(), [<int>[], <int>[]]);
    });

    test('works with string characters', () {
      final result = SplitRange('a,b,c'.split(''), ',');
      expect(result.toList(), [
        ['a'],
        ['b'],
        ['c'],
      ]);
    });

    test('is re-iterable', () {
      final range = SplitRange([1, 0, 2], 0);
      expect(range.toList(), range.toList());
    });
  });
}
