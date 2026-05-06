// v0.6.4 Extended Optional Tests
// Covers: monad laws, flatMap on None, zip None/None, map identity,
// filter on None, ofNullable with non-null, toString, and hashCode.
import 'package:test/test.dart';
import 'package:stl/stl.dart';

void main() {
  // -----------------------------------------------------------------------
  // Monad laws
  // -----------------------------------------------------------------------
  group('Optional - Monad laws', () {
    Optional<int> f(int x) => Optional.of(x * 2);
    Optional<int> g(int x) => Optional.of(x + 10);

    test('Left identity: Optional.of(a).flatMap(f) == f(a)', () {
      const a = 5;
      expect(Optional.of(a).flatMap(f), equals(f(a)));
    });

    test('Right identity: m.flatMap(Optional.of) == m', () {
      final m = Optional.of(7);
      expect(m.flatMap((v) => Optional.of(v)), equals(m));
    });

    test('Right identity for None: None.flatMap(f) == None', () {
      final none = Optional<int>.none();
      expect(none.flatMap((v) => Optional.of(v)), isA<None<int>>());
    });

    test(
      'Associativity: (m.flatMap(f)).flatMap(g) == m.flatMap(x => f(x).flatMap(g))',
      () {
        final m = Optional.of(3);
        final lhs = m.flatMap(f).flatMap(g);
        final rhs = m.flatMap((x) => f(x).flatMap(g));
        expect(lhs, equals(rhs));
      },
    );

    test('Associativity with None short-circuits', () {
      final none = Optional<int>.none();
      final lhs = none.flatMap(f).flatMap(g);
      final rhs = none.flatMap((x) => f(x).flatMap(g));
      expect(lhs, isA<None<int>>());
      expect(rhs, isA<None<int>>());
    });
  });

  // -----------------------------------------------------------------------
  // flatMap on None
  // -----------------------------------------------------------------------
  group('Optional - flatMap on None', () {
    test('flatMap on None never calls mapper', () {
      var called = false;
      final result = Optional<int>.none().flatMap((v) {
        called = true;
        return Optional.of(v);
      });
      expect(called, isFalse);
      expect(result, isA<None<int>>());
    });

    test('flatMap returning None yields None', () {
      final result = Optional.of(5).flatMap((_) => Optional<int>.none());
      expect(result, isA<None<int>>());
    });
  });

  // -----------------------------------------------------------------------
  // Functor laws (map)
  // -----------------------------------------------------------------------
  group('Optional - Functor laws', () {
    test('Identity: map(id) == id for Some', () {
      final m = Optional.of(42);
      expect(m.map((x) => x), equals(m));
    });

    test('Identity: map(id) == id for None', () {
      final none = Optional<int>.none();
      expect(none.map((x) => x), isA<None<int>>());
    });

    test('Composition: map(f).map(g) == map(x => g(f(x)))', () {
      int double_(int x) => x * 2;
      int addOne(int x) => x + 1;
      final m = Optional.of(3);
      expect(
        m.map(double_).map(addOne),
        equals(m.map((x) => addOne(double_(x)))),
      );
    });
  });

  // -----------------------------------------------------------------------
  // filter edge cases
  // -----------------------------------------------------------------------
  group('Optional - filter edge cases', () {
    test('filter on Some where predicate is always true keeps value', () {
      expect(Optional.of(7).filter((_) => true), isA<Some<int>>());
    });

    test('filter on Some where predicate is always false gives None', () {
      expect(Optional.of(7).filter((_) => false), isA<None<int>>());
    });

    test('filter on None returns None without calling predicate', () {
      var calls = 0;
      Optional<int>.none().filter((_) {
        calls++;
        return true;
      });
      expect(calls, equals(0));
    });
  });

  // -----------------------------------------------------------------------
  // zip combinations
  // -----------------------------------------------------------------------
  group('Optional - zip combinations', () {
    test('zip Some with Some returns Some of record', () {
      final result = Optional.of(1).zip(Optional.of('a'));
      expect(result, isA<Some<(int, String)>>());
    });

    test('zip None with Some returns None', () {
      expect(Optional<int>.none().zip(Optional.of('a')), isA<None>());
    });

    test('zip Some with None returns None', () {
      expect(Optional.of(1).zip(Optional<String>.none()), isA<None>());
    });

    test('zip None with None returns None', () {
      expect(Optional<int>.none().zip(Optional<String>.none()), isA<None>());
    });

    test('zip values are correctly extracted', () {
      final r = Optional.of(99).zip(Optional.of(true)) as Some<(int, bool)>;
      expect(r.value.$1, equals(99));
      expect(r.value.$2, isTrue);
    });
  });

  // -----------------------------------------------------------------------
  // ofNullable
  // -----------------------------------------------------------------------
  group('Optional - ofNullable', () {
    test('ofNullable with non-null value gives Some', () {
      final opt = Optional.ofNullable(42);
      expect(opt, isA<Some<int>>());
      expect((opt as Some<int>).value, equals(42));
    });

    test('ofNullable with null gives None', () {
      int? nullVal;
      expect(Optional.ofNullable(nullVal), isA<None<int>>());
    });
  });

  // -----------------------------------------------------------------------
  // toString and hashCode
  // -----------------------------------------------------------------------
  group('Optional - toString and hashCode', () {
    test('Some(x).toString() is "Some(x)"', () {
      expect(Optional.of(42).toString(), equals('Some(42)'));
      expect(Optional.of('hello').toString(), equals('Some(hello)'));
    });

    test('None.toString() is "None"', () {
      expect(Optional<int>.none().toString(), equals('None'));
    });

    test('equal Some values have equal hashCodes', () {
      expect(Optional.of(5).hashCode, equals(Optional.of(5).hashCode));
    });

    test('all None instances have equal hashCodes', () {
      expect(
        Optional<int>.none().hashCode,
        equals(Optional<String>.none().hashCode),
      );
    });

    test('Some and None have different hashCodes (expected by convention)', () {
      // This is not strictly required by the contract but is practically desirable
      // unless the value happens to have hashCode == 0
      final someHash = Optional.of(1).hashCode; // value.hashCode == 1
      final noneHash = Optional<int>.none().hashCode; // 0
      expect(someHash, isNot(equals(noneHash)));
    });
  });

  // -----------------------------------------------------------------------
  // valueOr
  // -----------------------------------------------------------------------
  group('Optional - valueOr', () {
    test('valueOr on None returns fallback', () {
      expect(Optional<int>.none().valueOr(99), equals(99));
    });

    test('valueOr on Some ignores fallback', () {
      expect(Optional.of(7).valueOr(99), equals(7));
    });
  });
}
