import 'package:stl/stl.dart';
import 'package:test/test.dart';

void main() {
  group('Zipper<T>', () {
    // -------------------------------------------------------------------------
    // Construction
    // -------------------------------------------------------------------------
    group('fromList', () {
      test('positions at index 0', () {
        final z = Zipper.fromList([1, 2, 3]);
        expect(z.focus, 1);
        expect(z.index, 0);
        expect(z.length, 3);
      });

      test('throws on empty list', () {
        expect(() => Zipper.fromList([]), throwsA(isA<InvalidArgument>()));
      });
    });

    group('fromListAt', () {
      test('positions at given index', () {
        final z = Zipper.fromListAt([10, 20, 30, 40], 2);
        expect(z.focus, 30);
        expect(z.index, 2);
      });

      test('throws on empty list', () {
        expect(() => Zipper.fromListAt([], 0), throwsA(isA<InvalidArgument>()));
      });

      test('throws on out-of-bounds index', () {
        expect(() => Zipper.fromListAt([1, 2, 3], 5), throwsRangeError);
      });
    });

    // -------------------------------------------------------------------------
    // Navigation
    // -------------------------------------------------------------------------
    group('moveRight', () {
      test('moves focus to next element', () {
        final z = Zipper.fromList([1, 2, 3]);
        final z2 = z.moveRight();
        expect(z2.focus, 2);
        expect(z2.index, 1);
      });

      test('original zipper unchanged', () {
        final z = Zipper.fromList([1, 2, 3]);
        z.moveRight();
        expect(z.focus, 1); // immutable
      });

      test('throws at rightmost position', () {
        final z = Zipper.fromListAt([1, 2, 3], 2);
        expect(() => z.moveRight(), throwsStateError);
      });

      test('canMoveRight is correct', () {
        final z = Zipper.fromList([1, 2]);
        expect(z.canMoveRight, isTrue);
        expect(z.moveRight().canMoveRight, isFalse);
      });
    });

    group('moveLeft', () {
      test('moves focus to previous element', () {
        final z = Zipper.fromListAt([1, 2, 3], 2);
        final z2 = z.moveLeft();
        expect(z2.focus, 2);
        expect(z2.index, 1);
      });

      test('throws at leftmost position', () {
        final z = Zipper.fromList([1, 2, 3]);
        expect(() => z.moveLeft(), throwsStateError);
      });

      test('canMoveLeft is correct', () {
        final z = Zipper.fromListAt([1, 2], 1);
        expect(z.canMoveLeft, isTrue);
        expect(z.moveLeft().canMoveLeft, isFalse);
      });
    });

    group('round-trip navigation', () {
      test('move right then left returns to original position', () {
        final z = Zipper.fromList([1, 2, 3]);
        final z2 = z.moveRight().moveLeft();
        expect(z2.focus, z.focus);
        expect(z2.index, z.index);
      });
    });

    // -------------------------------------------------------------------------
    // Modifications
    // -------------------------------------------------------------------------
    group('replace', () {
      test('replaces focus without changing position', () {
        final z = Zipper.fromListAt([1, 2, 3], 1);
        final z2 = z.replace(99);
        expect(z2.focus, 99);
        expect(z2.index, 1);
        expect(z2.toList(), [1, 99, 3]);
      });

      test('original zipper unchanged', () {
        final z = Zipper.fromList([1, 2]);
        z.replace(99);
        expect(z.toList(), [1, 2]);
      });
    });

    group('insert', () {
      test('inserts before focus', () {
        final z = Zipper.fromListAt([1, 3], 1);
        final z2 = z.insert(2);
        expect(z2.focus, 3);
        expect(z2.toList(), [1, 2, 3]);
      });
    });

    group('delete', () {
      test('deletes focus and moves to right element', () {
        final z = Zipper.fromListAt([1, 2, 3], 1);
        final z2 = z.delete();
        expect(z2.focus, 3);
        expect(z2.toList(), [1, 3]);
      });

      test('deletes focus and moves to left when no right', () {
        final z = Zipper.fromListAt([1, 2, 3], 2);
        final z2 = z.delete();
        expect(z2.focus, 2);
        expect(z2.toList(), [1, 2]);
      });

      test('throws when deleting only element', () {
        final z = Zipper.fromList([42]);
        expect(() => z.delete(), throwsStateError);
      });
    });

    // -------------------------------------------------------------------------
    // toList
    // -------------------------------------------------------------------------
    group('toList', () {
      test('reconstructs original order', () {
        final z = Zipper.fromListAt([1, 2, 3, 4, 5], 3);
        expect(z.toList(), [1, 2, 3, 4, 5]);
      });
    });

    // -------------------------------------------------------------------------
    // left / right getters
    // -------------------------------------------------------------------------
    group('left and right context', () {
      test('left returns elements in natural order', () {
        final z = Zipper.fromListAt([1, 2, 3, 4], 3);
        expect(z.left, [1, 2, 3]);
      });

      test('right returns elements in natural order', () {
        final z = Zipper.fromList([1, 2, 3, 4]);
        expect(z.right, [2, 3, 4]);
      });
    });

    // -------------------------------------------------------------------------
    // Equality
    // -------------------------------------------------------------------------
    group('equality', () {
      test('equal zippers are equal', () {
        final a = Zipper.fromListAt([1, 2, 3], 1);
        final b = Zipper.fromListAt([1, 2, 3], 1);
        expect(a, equals(b));
        expect(a.hashCode, equals(b.hashCode));
      });

      test('different focus position means not equal', () {
        final a = Zipper.fromListAt([1, 2, 3], 0);
        final b = Zipper.fromListAt([1, 2, 3], 1);
        expect(a, isNot(equals(b)));
      });
    });

    // -------------------------------------------------------------------------
    // moveTo
    // -------------------------------------------------------------------------
    group('moveTo', () {
      test('moves to the specified absolute index', () {
        final z = Zipper.fromList([10, 20, 30, 40, 50]);
        final z2 = z.moveTo(3);
        expect(z2.focus, equals(40));
        expect(z2.index, equals(3));
        expect(z2.toList(), equals([10, 20, 30, 40, 50]));
      });

      test('moveTo(0) positions at the beginning', () {
        final z = Zipper.fromListAt([1, 2, 3], 2);
        final z2 = z.moveTo(0);
        expect(z2.focus, equals(1));
        expect(z2.index, equals(0));
      });

      test('moveTo last index', () {
        final z = Zipper.fromList([1, 2, 3]);
        final z2 = z.moveTo(2);
        expect(z2.focus, equals(3));
        expect(z2.canMoveRight, isFalse);
      });

      test('moveTo throws RangeError on out-of-bounds index', () {
        final z = Zipper.fromList([1, 2, 3]);
        expect(() => z.moveTo(3), throwsRangeError);
        expect(() => z.moveTo(-1), throwsRangeError);
      });
    });

    // -------------------------------------------------------------------------
    // find
    // -------------------------------------------------------------------------
    group('find', () {
      test('finds the first matching element from the current focus', () {
        final z = Zipper.fromList([1, 2, 3, 4, 5]);
        final result = z.find((e) => e > 3);
        expect(result, isNotNull);
        expect(result!.focus, equals(4));
        expect(result.index, equals(3));
      });

      test('find matches the current focus', () {
        final z = Zipper.fromListAt([1, 2, 3], 1);
        final result = z.find((e) => e == 2);
        expect(result, isNotNull);
        expect(result!.focus, equals(2));
        expect(result.index, equals(1));
      });

      test('find returns null when no element matches', () {
        final z = Zipper.fromList([1, 2, 3]);
        final result = z.find((e) => e > 10);
        expect(result, isNull);
      });

      test(
        'find does not scan elements to the left of the current position',
        () {
          final z = Zipper.fromListAt([5, 1, 2, 3], 1);
          // 5 is to the left; find should not see it
          final result = z.find((e) => e == 5);
          expect(result, isNull);
        },
      );
    });
  });
}
