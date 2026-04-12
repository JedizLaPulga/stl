import 'package:test/test.dart';
import 'package:stl/stl.dart';

void main() {
  group('RepeatRange', () {
    test('repeats value exactly N times', () {
      final repeat = RepeatRange('abc', 3).toList();
      expect(repeat.length, 3);
      expect(repeat, ['abc', 'abc', 'abc']);
    });

    test('bound of 0 yields empty iterable', () {
      final repeat = RepeatRange(5, 0).toList();
      expect(repeat.isEmpty, isTrue);
    });

    test('infinite repeat (no bounds)', () {
      final repeat = RepeatRange(42);
      // Ensure we can iterate it at least a bunch of times without it stopping itself
      int count = 0;
      for (final val in repeat) {
        expect(val, 42);
        count++;
        if (count == 100) break;
      }
      expect(count, 100);

      // we can also use `.take()` standard iterable method!
      final taken = repeat.take(5).toList();
      expect(taken.length, 5);
      expect(taken, [42, 42, 42, 42, 42]);
    });

    test('throws ArgumentError on negative bounds', () {
      expect(() => RepeatRange(10, -1), throwsArgumentError);
    });
  });
}
