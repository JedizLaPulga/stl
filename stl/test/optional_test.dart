import 'package:test/test.dart';
import 'package:stl/stl.dart';

void main() {
  group('Optional Construction', () {
    test('Optional.of should create a Some instance', () {
      final opt = Optional.of("Hello");
      expect(opt.isPresent, isTrue);
      expect(opt.isEmpty, isFalse);
      expect(opt.toString(), equals('Some(Hello)'));
    });

    test('Optional.none should create a None instance', () {
      final opt = Optional<int>.none();
      expect(opt.isPresent, isFalse);
      expect(opt.isEmpty, isTrue);
      expect(opt.toString(), equals('None'));
    });

    test('Optional.ofNullable should handle nulls and values', () {
      expect(Optional.ofNullable(null), isA<None>());
      expect(Optional.ofNullable("Value"), isA<Some>());
    });
  });

  group('Functional Methods', () {
    test('valueOr returns value when present and fallback when empty', () {
      final some = Optional.of(10);
      final none = Optional<int>.none();

      expect(some.valueOr(0), equals(10));
      expect(none.valueOr(0), equals(0));
    });

    test('map transforms value in Some and ignores None', () {
      final some = Optional.of(5);
      final mappedSome = some.map((v) => v * 2);

      final none = Optional<int>.none();
      final mappedNone = none.map((v) => v * 2);

      expect(mappedSome.valueOr(0), equals(10));
      expect(mappedNone, isA<None>());
    });

    test('flatMap prevents nested Optionals', () {
      final some = Optional.of(10);
      // If we used map, we'd get Optional<Optional<String>>
      final flatMapped = some.flatMap((v) => Optional.of(v.toString()));

      expect(flatMapped, isA<Some<String>>());
      expect(flatMapped.valueOr(""), equals("10"));
    });
  });

  group('Equality and Pattern Matching', () {
    test('Value equality should work for Some and None', () {
      expect(Optional.of(1), equals(Optional.of(1)));
      expect(Optional.of(1), isNot(equals(Optional.of(2))));
      expect(Optional<int>.none(), equals(Optional<int>.none()));
    });

    test('Pattern matching works with switch expressions', () {
      final Optional<String> opt = Optional.of("Dart");

      final result = switch (opt) {
        Some(value: final v) => v,
        None() => "Empty",
      };

      expect(result, equals("Dart"));
    });
  });

  group('fold, filter, zip', () {
    test('fold calls onSome for Some and onNone for None', () {
      final some = Optional.of(42);
      final none = Optional<int>.none();

      expect(some.fold((v) => 'got $v', () => 'nothing'), equals('got 42'));
      expect(none.fold((v) => 'got $v', () => 'nothing'), equals('nothing'));
    });

    test('filter keeps Some when predicate holds', () {
      final even = Optional.of(4).filter((n) => n.isEven);
      expect(even, isA<Some<int>>());
      expect(even.valueOr(0), equals(4));
    });

    test('filter returns None when predicate fails', () {
      final result = Optional.of(3).filter((n) => n.isEven);
      expect(result, isA<None<int>>());
    });

    test('filter on None returns None without calling predicate', () {
      var called = false;
      final result = Optional<int>.none().filter((n) {
        called = true;
        return true;
      });
      expect(result, isA<None<int>>());
      expect(called, isFalse);
    });

    test('zip returns Some record when both are Some', () {
      final result = Optional.of(1).zip(Optional.of('a'));
      expect(result, isA<Some<(int, String)>>());
      final (n, s) = (result as Some<(int, String)>).value;
      expect(n, equals(1));
      expect(s, equals('a'));
    });

    test('zip returns None when either operand is None', () {
      expect(Optional.of(1).zip(Optional<String>.none()), isA<None>());
      expect(Optional<int>.none().zip(Optional.of('a')), isA<None>());
      expect(Optional<int>.none().zip(Optional<String>.none()), isA<None>());
    });
  });
}
