import 'package:stl/stl.dart';
import 'package:test/test.dart';

void main() {
  group('NonEmptyList<T>', () {
    // -------------------------------------------------------------------------
    // Construction
    // -------------------------------------------------------------------------
    group('construction', () {
      test('of() with head only', () {
        final nel = NonEmptyList.of(42);
        expect(nel.head, 42);
        expect(nel.tail, isEmpty);
        expect(nel.length, 1);
      });

      test('of() with head and tail', () {
        final nel = NonEmptyList.of(1, [2, 3, 4]);
        expect(nel.head, 1);
        expect(nel.tail, [2, 3, 4]);
        expect(nel.length, 4);
      });

      test('fromIterable() with non-empty iterable', () {
        final nel = NonEmptyList.fromIterable([10, 20, 30]);
        expect(nel.head, 10);
        expect(nel.last, 30);
        expect(nel.length, 3);
      });

      test('fromIterable() throws on empty iterable', () {
        expect(
          () => NonEmptyList.fromIterable([]),
          throwsA(isA<InvalidArgument>()),
        );
      });

      test('tail is unmodifiable', () {
        final nel = NonEmptyList.of(1, [2, 3]);
        expect(() => (nel.tail as List).add(4), throwsUnsupportedError);
      });
    });

    // -------------------------------------------------------------------------
    // Accessors
    // -------------------------------------------------------------------------
    group('accessors', () {
      test('first equals head', () {
        final nel = NonEmptyList.of(7, [8, 9]);
        expect(nel.first, nel.head);
        expect(nel.first, 7);
      });

      test('last on single element', () {
        final nel = NonEmptyList.of(99);
        expect(nel.last, 99);
      });

      test('last on multi-element', () {
        final nel = NonEmptyList.of(1, [2, 3, 4]);
        expect(nel.last, 4);
      });
    });

    // -------------------------------------------------------------------------
    // Iteration
    // -------------------------------------------------------------------------
    group('iteration', () {
      test('iterates all elements in order', () {
        final nel = NonEmptyList.of(1, [2, 3]);
        expect(nel.toList(), [1, 2, 3]);
      });

      test('for-in loop works', () {
        final nel = NonEmptyList.of('a', ['b', 'c']);
        final result = <String>[];
        for (final e in nel) {
          result.add(e);
        }
        expect(result, ['a', 'b', 'c']);
      });
    });

    // -------------------------------------------------------------------------
    // Transformations
    // -------------------------------------------------------------------------
    group('map', () {
      test('transforms all elements', () {
        final nel = NonEmptyList.of(1, [2, 3]);
        final doubled = nel.map((x) => x * 2);
        expect(doubled.toList(), [2, 4, 6]);
      });

      test('preserves type safety', () {
        final nel = NonEmptyList.of(1, [2, 3]);
        final asString = nel.map((x) => x.toString());
        expect(asString.head, '1');
      });
    });

    group('flatMap', () {
      test('flattens one level', () {
        final nel = NonEmptyList.of(1, [2, 3]);
        final result = nel.flatMap((x) => NonEmptyList.of(x, [x * 10]));
        expect(result.toList(), [1, 10, 2, 20, 3, 30]);
      });
    });

    group('reduce', () {
      test('reduces with combiner', () {
        final nel = NonEmptyList.of(1, [2, 3, 4]);
        expect(nel.reduce((a, b) => a + b), 10);
      });

      test('single element returns head', () {
        final nel = NonEmptyList.of(42);
        expect(nel.reduce((a, b) => a + b), 42);
      });
    });

    group('fold', () {
      test('folds with initial value', () {
        final nel = NonEmptyList.of(1, [2, 3]);
        expect(nel.fold(10, (acc, e) => acc + e), 16);
      });
    });

    // -------------------------------------------------------------------------
    // Structural operations
    // -------------------------------------------------------------------------
    group('prepend', () {
      test('adds element before head', () {
        final nel = NonEmptyList.of(2, [3]);
        final result = nel.prepend(1);
        expect(result.toList(), [1, 2, 3]);
        expect(nel.toList(), [2, 3]); // original unchanged
      });
    });

    group('append', () {
      test('adds element after last', () {
        final nel = NonEmptyList.of(1, [2]);
        final result = nel.append(3);
        expect(result.toList(), [1, 2, 3]);
        expect(nel.toList(), [1, 2]); // original unchanged
      });
    });

    group('concat', () {
      test('concatenates two lists', () {
        final a = NonEmptyList.of(1, [2]);
        final b = NonEmptyList.of(3, [4]);
        expect(a.concat(b).toList(), [1, 2, 3, 4]);
      });
    });

    // -------------------------------------------------------------------------
    // Equality
    // -------------------------------------------------------------------------
    group('equality', () {
      test('equal lists are equal', () {
        final a = NonEmptyList.of(1, [2, 3]);
        final b = NonEmptyList.of(1, [2, 3]);
        expect(a, equals(b));
        expect(a.hashCode, equals(b.hashCode));
      });

      test('different lists are not equal', () {
        final a = NonEmptyList.of(1, [2]);
        final b = NonEmptyList.of(1, [3]);
        expect(a, isNot(equals(b)));
      });
    });

    group('toString', () {
      test('produces readable output', () {
        final nel = NonEmptyList.of(1, [2, 3]);
        expect(nel.toString(), 'NonEmptyList(1, [2, 3])');
      });
    });
  });
}
