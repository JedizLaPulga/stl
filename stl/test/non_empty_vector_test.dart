import 'package:stl/stl.dart';
import 'package:test/test.dart';

void main() {
  group('NonEmptyVector<T>', () {
    // -------------------------------------------------------------------------
    // Construction
    // -------------------------------------------------------------------------
    group('construction', () {
      test('of() with single element', () {
        final nev = NonEmptyVector.of(1);
        expect(nev.length, 1);
        expect(nev.first, 1);
        expect(nev.last, 1);
      });

      test('of() with rest elements', () {
        final nev = NonEmptyVector.of(1, [2, 3, 4]);
        expect(nev.length, 4);
        expect(nev.first, 1);
        expect(nev.last, 4);
      });

      test('fromIterable() with non-empty iterable', () {
        final nev = NonEmptyVector.fromIterable([10, 20, 30]);
        expect(nev.length, 3);
        expect(nev.first, 10);
      });

      test('fromIterable() throws on empty', () {
        expect(
          () => NonEmptyVector.fromIterable(<int>[]),
          throwsA(isA<InvalidArgument>()),
        );
      });

      test('fromVector() with non-empty vector', () {
        final v = Vector<int>([1, 2, 3]);
        final nev = NonEmptyVector.fromVector(v);
        expect(nev.toList(), [1, 2, 3]);
      });

      test('fromVector() throws on empty vector', () {
        expect(
          () => NonEmptyVector.fromVector(Vector<int>([])),
          throwsA(isA<InvalidArgument>()),
        );
      });
    });

    // -------------------------------------------------------------------------
    // Element access
    // -------------------------------------------------------------------------
    group('element access', () {
      test('operator[] returns correct element', () {
        final nev = NonEmptyVector.of(10, [20, 30]);
        expect(nev[0], 10);
        expect(nev[1], 20);
        expect(nev[2], 30);
      });

      test('operator[]= sets element', () {
        final nev = NonEmptyVector.of(1, [2, 3]);
        nev[1] = 99;
        expect(nev[1], 99);
      });
    });

    // -------------------------------------------------------------------------
    // Mutation
    // -------------------------------------------------------------------------
    group('add', () {
      test('increases length and appends value', () {
        final nev = NonEmptyVector.of(1);
        nev.add(2);
        expect(nev.length, 2);
        expect(nev.last, 2);
      });
    });

    group('addAll', () {
      test('appends multiple values', () {
        final nev = NonEmptyVector.of(1);
        nev.addAll([2, 3, 4]);
        expect(nev.toList(), [1, 2, 3, 4]);
      });
    });

    group('removeAt', () {
      test('removes element at index', () {
        final nev = NonEmptyVector.of(1, [2, 3]);
        nev.removeAt(1);
        expect(nev.toList(), [1, 3]);
      });

      test('removes first element', () {
        final nev = NonEmptyVector.of(1, [2, 3]);
        nev.removeAt(0);
        expect(nev.first, 2);
      });

      test('throws when removing last remaining element', () {
        final nev = NonEmptyVector.of(42);
        expect(() => nev.removeAt(0), throwsA(isA<InvalidArgument>()));
      });

      test('throws on out-of-bounds index', () {
        final nev = NonEmptyVector.of(1, [2, 3]);
        expect(() => nev.removeAt(5), throwsRangeError);
      });
    });

    group('removeLast', () {
      test('removes last element', () {
        final nev = NonEmptyVector.of(1, [2, 3]);
        nev.removeLast();
        expect(nev.toList(), [1, 2]);
      });

      test('throws when removing last remaining element', () {
        final nev = NonEmptyVector.of(5);
        expect(() => nev.removeLast(), throwsA(isA<InvalidArgument>()));
      });
    });

    group('insert', () {
      test('inserts at given index', () {
        final nev = NonEmptyVector.of(1, [3]);
        nev.insert(1, 2);
        expect(nev.toList(), [1, 2, 3]);
      });
    });

    // -------------------------------------------------------------------------
    // Iteration
    // -------------------------------------------------------------------------
    group('iteration', () {
      test('iterates in order', () {
        final nev = NonEmptyVector.of(1, [2, 3]);
        expect(nev.toList(), [1, 2, 3]);
      });
    });

    // -------------------------------------------------------------------------
    // Equality
    // -------------------------------------------------------------------------
    group('equality', () {
      test('equal vectors are equal', () {
        final a = NonEmptyVector.of(1, [2, 3]);
        final b = NonEmptyVector.of(1, [2, 3]);
        expect(a, equals(b));
      });

      test('different vectors are not equal', () {
        final a = NonEmptyVector.of(1, [2]);
        final b = NonEmptyVector.of(1, [3]);
        expect(a, isNot(equals(b)));
      });
    });
  });
}
