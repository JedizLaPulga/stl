import 'package:test/test.dart';
import 'package:stl/src/ranges/transform_range.dart';

void main() {
  group('TransformRange', () {
    test('transforms elements based on function', () {
      final list = [1, 2, 3];
      final range = TransformRange<int, int>(list, (int x) => x * 2);
      expect(range.toList(), equals([2, 4, 6]));
    });

    test('changes type of elements', () {
      final list = [1, 2, 3];
      final range = TransformRange<int, String>(list, (int x) => x.toString());
      expect(range.toList(), equals(['1', '2', '3']));
    });

    test('handles empty iterable', () {
      final list = <int>[];
      final range = TransformRange<int, int>(list, (int x) => x * 2);
      expect(range.toList(), isEmpty);
    });

    test('iterator throws StateError when current is accessed before moveNext', () {
      final list = [1, 2, 3];
      final range = TransformRange<int, int>(list, (int x) => x * 2);
      final it = range.iterator;
      expect(() => it.current, throwsStateError);
    });
  });
}
