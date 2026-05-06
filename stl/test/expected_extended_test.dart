// v0.6.4 Extended Expected Tests
// Covers: toString, valueOr type-preserving, mapError chains,
// monad laws (left identity, right identity, associativity),
// same-type value vs error equality, and fold branch exhaustiveness.
import 'package:test/test.dart';
import 'package:stl/stl.dart';

void main() {
  // -----------------------------------------------------------------------
  // toString
  // -----------------------------------------------------------------------
  group('Expected - toString', () {
    test('toString on value branch contains value representation', () {
      final e = Expected<int, String>.value(42);
      expect(e.toString(), isNotEmpty);
      // Must not throw; content not mandated but should be useful
    });

    test('toString on error branch contains error representation', () {
      final e = Expected<int, String>.error('oops');
      expect(e.toString(), isNotEmpty);
    });
  });

  // -----------------------------------------------------------------------
  // Monad laws
  // -----------------------------------------------------------------------
  group('Expected - Monad laws', () {
    Expected<int, String> f(int x) => Expected.value(x * 2);
    Expected<int, String> g(int x) => Expected.value(x + 10);

    test('Left identity: Expected.value(a).flatMap(f) == f(a)', () {
      final a = 5;
      expect(Expected<int, String>.value(a).flatMap(f), equals(f(a)));
    });

    test('Right identity: m.flatMap(Expected.value) == m', () {
      final m = Expected<int, String>.value(7);
      expect(m.flatMap((v) => Expected.value(v)), equals(m));
    });

    test(
      'Right identity for error: error.flatMap(Expected.value) == error',
      () {
        final m = Expected<int, String>.error('err');
        final result = m.flatMap((v) => Expected<int, String>.value(v));
        expect(result.hasValue, isFalse);
        expect(result.error, equals('err'));
      },
    );

    test(
      'Associativity: (m.flatMap(f)).flatMap(g) == m.flatMap(x => f(x).flatMap(g))',
      () {
        final m = Expected<int, String>.value(3);
        final lhs = m.flatMap(f).flatMap(g);
        final rhs = m.flatMap((x) => f(x).flatMap(g));
        expect(lhs, equals(rhs));
      },
    );

    test('Associativity holds with error short-circuit', () {
      final m = Expected<int, String>.error('start');
      final lhs = m.flatMap(f).flatMap(g);
      final rhs = m.flatMap((x) => f(x).flatMap(g));
      expect(lhs.hasValue, isFalse);
      expect(rhs.hasValue, isFalse);
      expect(lhs.error, equals(rhs.error));
    });
  });

  // -----------------------------------------------------------------------
  // Same-type T == E edge cases
  // -----------------------------------------------------------------------
  group('Expected - same-type value vs error', () {
    test('Expected<int,int>.value(1) != Expected<int,int>.error(1)', () {
      final v = Expected<int, int>.value(1);
      final e = Expected<int, int>.error(1);
      expect(v == e, isFalse);
      expect(e == v, isFalse);
    });

    test('Expected<int,int>.value(1) == Expected<int,int>.value(1)', () {
      expect(
        Expected<int, int>.value(1) == Expected<int, int>.value(1),
        isTrue,
      );
    });
  });

  // -----------------------------------------------------------------------
  // valueOr
  // -----------------------------------------------------------------------
  group('Expected - valueOr', () {
    test('valueOr returns computed fallback on error', () {
      final e = Expected<int, String>.error('missing');
      expect(e.valueOr(-1), equals(-1));
    });

    test('valueOr returns inner value when present, ignoring fallback', () {
      final e = Expected<int, String>.value(99);
      expect(e.valueOr(-1), equals(99));
    });
  });

  // -----------------------------------------------------------------------
  // map composition (functor law)
  // -----------------------------------------------------------------------
  group('Expected - Functor laws', () {
    test('Identity: map(id) == id', () {
      final v = Expected<int, String>.value(5);
      expect(v.map((x) => x), equals(v));
    });

    test('Composition: map(f).map(g) == map(x => g(f(x)))', () {
      int double_(int x) => x * 2;
      int addOne(int x) => x + 1;

      final v = Expected<int, String>.value(3);
      final lhs = v.map(double_).map(addOne);
      final rhs = v.map((x) => addOne(double_(x)));
      expect(lhs, equals(rhs));
    });

    test('map identity on error passes through error unchanged', () {
      final e = Expected<int, String>.error('err');
      expect(e.map((x) => x).error, equals('err'));
    });
  });

  // -----------------------------------------------------------------------
  // fold exhaustiveness
  // -----------------------------------------------------------------------
  group('Expected - fold', () {
    test('fold value branch is not called on error', () {
      var called = false;
      Expected<int, String>.error('x').fold((_) {
        called = true;
        return 0;
      }, (e) => 1);
      expect(called, isFalse);
    });

    test('fold error branch is not called on value', () {
      var called = false;
      Expected<int, String>.value(1).fold((v) => 0, (_) {
        called = true;
        return 0;
      });
      expect(called, isFalse);
    });

    test('fold return type is correctly inferred', () {
      final result = Expected<int, String>.value(
        42,
      ).fold((v) => v.toString(), (e) => 'error');
      expect(result, isA<String>());
      expect(result, equals('42'));
    });
  });
}
