import 'package:stl/stl.dart';
import 'package:test/test.dart';

void main() {
  group('FingerTree<T>', () {
    // -------------------------------------------------------------------------
    // Construction
    // -------------------------------------------------------------------------
    group('construction', () {
      test('empty() has length 0', () {
        final ft = FingerTree<int>.empty();
        expect(ft.isEmpty, isTrue);
        expect(ft.length, 0);
      });

      test('single() has length 1', () {
        final ft = FingerTree.single(42);
        expect(ft.length, 1);
        expect(ft.first, 42);
        expect(ft.last, 42);
      });

      test('fromIterable() produces correct tree', () {
        final ft = FingerTree.fromIterable([1, 2, 3, 4, 5]);
        expect(ft.length, 5);
        expect(ft.toList(), [1, 2, 3, 4, 5]);
      });

      test('fromIterable() with empty iterable produces empty tree', () {
        final ft = FingerTree<int>.fromIterable([]);
        expect(ft.isEmpty, isTrue);
      });
    });

    // -------------------------------------------------------------------------
    // first / last
    // -------------------------------------------------------------------------
    group('first / last', () {
      test('throws on empty', () {
        final ft = FingerTree<int>.empty();
        expect(() => ft.first, throwsStateError);
        expect(() => ft.last, throwsStateError);
      });

      test('single element', () {
        final ft = FingerTree.single(7);
        expect(ft.first, 7);
        expect(ft.last, 7);
      });

      test('multi-element', () {
        final ft = FingerTree.fromIterable([1, 2, 3, 4, 5]);
        expect(ft.first, 1);
        expect(ft.last, 5);
      });
    });

    // -------------------------------------------------------------------------
    // prepend / append
    // -------------------------------------------------------------------------
    group('prepend', () {
      test('prepend to empty', () {
        final ft = FingerTree<int>.empty().prepend(1);
        expect(ft.toList(), [1]);
      });

      test('prepend to single', () {
        final ft = FingerTree.single(2).prepend(1);
        expect(ft.toList(), [1, 2]);
      });

      test('prepend many elements preserves order', () {
        FingerTree<int> ft = FingerTree<int>.empty();
        for (int i = 10; i >= 1; i--) {
          ft = ft.prepend(i);
        }
        expect(ft.toList(), List.generate(10, (i) => i + 1));
      });
    });

    group('append', () {
      test('append to empty', () {
        final ft = FingerTree<int>.empty().append(1);
        expect(ft.toList(), [1]);
      });

      test('append to single', () {
        final ft = FingerTree.single(1).append(2);
        expect(ft.toList(), [1, 2]);
      });

      test('append many elements preserves order', () {
        FingerTree<int> ft = FingerTree<int>.empty();
        for (int i = 1; i <= 20; i++) {
          ft = ft.append(i);
        }
        expect(ft.toList(), List.generate(20, (i) => i + 1));
      });
    });

    // -------------------------------------------------------------------------
    // removeFirst / removeLast
    // -------------------------------------------------------------------------
    group('removeFirst', () {
      test('from single becomes empty', () {
        expect(FingerTree.single(1).removeFirst().isEmpty, isTrue);
      });

      test('removes first element correctly', () {
        final ft = FingerTree.fromIterable([1, 2, 3]);
        expect(ft.removeFirst().toList(), [2, 3]);
      });

      test('throws on empty', () {
        expect(() => FingerTree<int>.empty().removeFirst(), throwsStateError);
      });
    });

    group('removeLast', () {
      test('from single becomes empty', () {
        expect(FingerTree.single(1).removeLast().isEmpty, isTrue);
      });

      test('removes last element correctly', () {
        final ft = FingerTree.fromIterable([1, 2, 3]);
        expect(ft.removeLast().toList(), [1, 2]);
      });

      test('throws on empty', () {
        expect(() => FingerTree<int>.empty().removeLast(), throwsStateError);
      });
    });

    // -------------------------------------------------------------------------
    // concat
    // -------------------------------------------------------------------------
    group('concat', () {
      test('empty + empty = empty', () {
        final ft = FingerTree<int>.empty().concat(FingerTree<int>.empty());
        expect(ft.isEmpty, isTrue);
      });

      test('empty + tree = tree', () {
        final right = FingerTree.fromIterable([1, 2, 3]);
        expect(FingerTree<int>.empty().concat(right).toList(), [1, 2, 3]);
      });

      test('tree + empty = tree', () {
        final left = FingerTree.fromIterable([1, 2, 3]);
        expect(left.concat(FingerTree<int>.empty()).toList(), [1, 2, 3]);
      });

      test('two non-empty trees', () {
        final left = FingerTree.fromIterable([1, 2, 3]);
        final right = FingerTree.fromIterable([4, 5, 6]);
        expect(left.concat(right).toList(), [1, 2, 3, 4, 5, 6]);
      });

      test('large concat preserves all elements', () {
        final left = FingerTree.fromIterable(List.generate(50, (i) => i));
        final right = FingerTree.fromIterable(List.generate(50, (i) => i + 50));
        final result = left.concat(right);
        expect(result.length, 100);
        expect(result.toList(), List.generate(100, (i) => i));
      });
    });

    // -------------------------------------------------------------------------
    // splitAt
    // -------------------------------------------------------------------------
    group('splitAt', () {
      test('split at 0', () {
        final ft = FingerTree.fromIterable([1, 2, 3]);
        final (l, r) = ft.splitAt(0);
        expect(l.isEmpty, isTrue);
        expect(r.toList(), [1, 2, 3]);
      });

      test('split at length', () {
        final ft = FingerTree.fromIterable([1, 2, 3]);
        final (l, r) = ft.splitAt(3);
        expect(l.toList(), [1, 2, 3]);
        expect(r.isEmpty, isTrue);
      });

      test('split in middle', () {
        final ft = FingerTree.fromIterable([1, 2, 3, 4, 5]);
        final (l, r) = ft.splitAt(3);
        expect(l.toList(), [1, 2, 3]);
        expect(r.toList(), [4, 5]);
      });

      test('throws on out-of-range index', () {
        final ft = FingerTree.fromIterable([1, 2, 3]);
        expect(() => ft.splitAt(-1), throwsRangeError);
        expect(() => ft.splitAt(4), throwsRangeError);
      });
    });

    // -------------------------------------------------------------------------
    // Immutability
    // -------------------------------------------------------------------------
    group('immutability', () {
      test('original tree unaffected by prepend', () {
        final original = FingerTree.fromIterable([2, 3]);
        final modified = original.prepend(1);
        expect(original.toList(), [2, 3]);
        expect(modified.toList(), [1, 2, 3]);
      });

      test('original tree unaffected by append', () {
        final original = FingerTree.fromIterable([1, 2]);
        final modified = original.append(3);
        expect(original.toList(), [1, 2]);
        expect(modified.toList(), [1, 2, 3]);
      });
    });

    // -------------------------------------------------------------------------
    // Equality
    // -------------------------------------------------------------------------
    group('equality', () {
      test('equal trees are equal', () {
        final a = FingerTree.fromIterable([1, 2, 3]);
        final b = FingerTree.fromIterable([1, 2, 3]);
        expect(a, equals(b));
        expect(a.hashCode, equals(b.hashCode));
      });

      test('different trees are not equal', () {
        final a = FingerTree.fromIterable([1, 2]);
        final b = FingerTree.fromIterable([1, 3]);
        expect(a, isNot(equals(b)));
      });

      test('empty trees are equal', () {
        expect(FingerTree<int>.empty(), equals(FingerTree<int>.empty()));
      });
    });

    // -------------------------------------------------------------------------
    // Iterator
    // -------------------------------------------------------------------------
    group('iterator', () {
      test('iterates all elements via for-in', () {
        final ft = FingerTree.fromIterable([10, 20, 30]);
        final result = <int>[];
        for (final e in ft) {
          result.add(e);
        }
        expect(result, [10, 20, 30]);
      });
    });
  });
}
