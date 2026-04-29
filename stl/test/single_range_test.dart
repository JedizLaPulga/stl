import 'package:test/test.dart';
import 'package:stl/stl.dart';

void main() {
  group('SingleRange', () {
    test('yields exactly one integer element', () {
      expect(SingleRange(42).toList(), [42]);
    });

    test('yields exactly one string element', () {
      expect(SingleRange('hello').toList(), ['hello']);
    });

    test('length is always 1', () {
      expect(SingleRange(99).length, 1);
    });

    test('first returns the wrapped value', () {
      expect(SingleRange(7).first, 7);
    });

    test('isEmpty is false', () {
      expect(SingleRange(0).isEmpty, isFalse);
    });

    test('is re-iterable', () {
      final range = SingleRange('x');
      expect(range.toList(), ['x']);
      expect(range.toList(), ['x']);
    });

    test('iterator signals exhaustion after one element', () {
      final it = SingleRange(1).iterator;
      expect(it.moveNext(), isTrue);
      expect(it.current, 1);
      expect(it.moveNext(), isFalse);
    });

    test('composes with JoinRange to prepend a value', () {
      final result = JoinRange([SingleRange(0), IotaRange(1, 4)]);
      expect(result.toList(), [0, 1, 2, 3]);
    });

    test('works with nullable type', () {
      expect(SingleRange<int?>(null).toList(), [null]);
    });
  });
}
