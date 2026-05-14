import 'package:test/test.dart';
import 'package:stl/stl.dart';

void main() {
  // ---------------------------------------------------------------------------
  // TakeWhileRange
  // ---------------------------------------------------------------------------
  group('TakeWhileRange', () {
    test('yields elements while predicate holds', () {
      final data = [2, 4, 6, 7, 8, 10];
      final result = TakeWhileRange(data, (n) => n.isEven);
      expect(result.toList(), [2, 4, 6]);
    });

    test('empty source yields empty', () {
      final result = TakeWhileRange<int>([], (n) => n > 0);
      expect(result.toList(), isEmpty);
    });

    test('all elements match — yields all', () {
      final data = [2, 4, 6, 8];
      final result = TakeWhileRange(data, (n) => n.isEven);
      expect(result.toList(), [2, 4, 6, 8]);
    });

    test('first element fails — yields nothing', () {
      final data = [1, 2, 3, 4];
      final result = TakeWhileRange(data, (n) => n.isEven);
      expect(result.toList(), isEmpty);
    });

    test('halts at first failure, ignores later matching elements', () {
      // 8 and 10 are even but come after 7 (odd), so they are NOT emitted
      final data = [2, 4, 7, 8, 10];
      final result = TakeWhileRange(data, (n) => n.isEven);
      expect(result.toList(), [2, 4]);
    });

    test('single element — predicate true', () {
      final result = TakeWhileRange([42], (n) => n > 0);
      expect(result.toList(), [42]);
    });

    test('single element — predicate false', () {
      final result = TakeWhileRange([0], (n) => n > 0);
      expect(result.toList(), isEmpty);
    });

    test('reusable across multiple iterations', () {
      final view = TakeWhileRange([1, 2, 3, 10, 4], (n) => n < 5);
      expect(view.toList(), [1, 2, 3]);
      expect(view.toList(), [1, 2, 3]); // second pass
    });

    test('works on infinite IotaRange', () {
      final result = TakeWhileRange(IotaRange(0), (n) => n < 5);
      expect(result.toList(), [0, 1, 2, 3, 4]);
    });

    test('isEmpty is true when nothing matches', () {
      final result = TakeWhileRange([1, 2, 3], (n) => n > 100);
      expect(result.isEmpty, isTrue);
    });

    test('isNotEmpty is true when something matches', () {
      final result = TakeWhileRange([1, 2, 3], (n) => n < 10);
      expect(result.isNotEmpty, isTrue);
    });

    test('length counts correctly', () {
      final result = TakeWhileRange([1, 2, 3, 10, 5], (n) => n < 5);
      expect(result.length, 3);
    });

    test('first returns first matched element', () {
      final result = TakeWhileRange([10, 20, 30, 0], (n) => n > 0);
      expect(result.first, 10);
    });

    test('last returns last matched element', () {
      final result = TakeWhileRange([10, 20, 30, 0], (n) => n > 0);
      expect(result.last, 30);
    });

    test('composition with FilterRange — filter inside take-while', () {
      final data = [1, 2, 3, 4, 5, 20, 6];
      // Take while < 10, then keep only evens
      final result = FilterRange(
        TakeWhileRange(data, (n) => n < 10),
        (n) => n.isEven,
      );
      expect(result.toList(), [2, 4]);
    });

    test('composition: TakeRange on TakeWhileRange', () {
      final data = [1, 2, 3, 4, 5, 99];
      final result = TakeRange(TakeWhileRange(data, (n) => n < 10), 3);
      expect(result.toList(), [1, 2, 3]);
    });

    test('works with strings', () {
      final words = ['alpha', 'beta', 'STOP', 'gamma'];
      final result = TakeWhileRange(words, (w) => w == w.toLowerCase());
      expect(result.toList(), ['alpha', 'beta']);
    });
  });

  // ---------------------------------------------------------------------------
  // DropWhileRange
  // ---------------------------------------------------------------------------
  group('DropWhileRange', () {
    test('skips leading elements while predicate holds', () {
      final data = [2, 4, 6, 7, 8, 10];
      final result = DropWhileRange(data, (n) => n.isEven);
      expect(result.toList(), [7, 8, 10]);
    });

    test('empty source yields empty', () {
      final result = DropWhileRange<int>([], (n) => n > 0);
      expect(result.toList(), isEmpty);
    });

    test('all elements match — yields nothing', () {
      final data = [2, 4, 6, 8];
      final result = DropWhileRange(data, (n) => n.isEven);
      expect(result.toList(), isEmpty);
    });

    test('first element fails — yields all', () {
      final data = [1, 2, 3, 4];
      final result = DropWhileRange(data, (n) => n.isEven);
      expect(result.toList(), [1, 2, 3, 4]);
    });

    test('emits re-matching elements after skip phase ends', () {
      // 8 and 10 are even but come after 7 (odd), so they ARE emitted
      final data = [2, 4, 7, 8, 10];
      final result = DropWhileRange(data, (n) => n.isEven);
      expect(result.toList(), [7, 8, 10]);
    });

    test('single element — predicate true (drop it)', () {
      final result = DropWhileRange([42], (n) => n > 0);
      expect(result.toList(), isEmpty);
    });

    test('single element — predicate false (keep it)', () {
      final result = DropWhileRange([0], (n) => n > 0);
      expect(result.toList(), [0]);
    });

    test('reusable across multiple iterations', () {
      final view = DropWhileRange([2, 4, 5, 6, 7], (n) => n.isEven);
      expect(view.toList(), [5, 6, 7]);
      expect(view.toList(), [5, 6, 7]); // second pass
    });

    test('isEmpty when all elements are skipped', () {
      final result = DropWhileRange([1, 2, 3], (n) => n < 100);
      expect(result.isEmpty, isTrue);
    });

    test('isNotEmpty when something remains', () {
      final result = DropWhileRange([1, 2, 10, 3], (n) => n < 5);
      expect(result.isNotEmpty, isTrue);
    });

    test('length counts remaining elements', () {
      final result = DropWhileRange([0, 0, 1, 2, 3], (n) => n == 0);
      expect(result.length, 3);
    });

    test('first returns first non-skipped element', () {
      final result = DropWhileRange([0, 0, 5, 6], (n) => n == 0);
      expect(result.first, 5);
    });

    test('last returns last element', () {
      final result = DropWhileRange([0, 0, 5, 6], (n) => n == 0);
      expect(result.last, 6);
    });

    test('composition: TakeRange on DropWhileRange', () {
      final data = [0, 0, 1, 2, 3, 4, 5];
      final result = TakeRange(DropWhileRange(data, (n) => n == 0), 3);
      expect(result.toList(), [1, 2, 3]);
    });

    test(
      'composition: TakeWhileRange + DropWhileRange extracts inner span',
      () {
        final signal = [0, 0, 1, 3, 5, 0, 0];
        final inner = TakeWhileRange(
          DropWhileRange(signal, (n) => n == 0),
          (n) => n != 0,
        );
        expect(inner.toList(), [1, 3, 5]);
      },
    );

    test('works with strings — trim leading empty strings', () {
      final lines = ['', '', 'hello', 'world', ''];
      final result = DropWhileRange(lines, (s) => s.isEmpty);
      expect(result.toList(), ['hello', 'world', '']);
    });
  });
}
