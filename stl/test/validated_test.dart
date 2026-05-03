import 'package:stl/stl.dart';
import 'package:test/test.dart';

void main() {
  group('Validated<E, A>', () {
    // -------------------------------------------------------------------------
    // Construction
    // -------------------------------------------------------------------------
    group('construction', () {
      test('valid() holds value', () {
        final v = Validated<String, int>.valid(42);
        expect(v.isValid, isTrue);
        expect(v.isInvalid, isFalse);
        expect(v.valueOr(0), 42);
      });

      test('invalid() holds single error', () {
        final v = Validated<String, int>.invalid('bad input');
        expect(v.isInvalid, isTrue);
        expect(v.isValid, isFalse);
        expect((v as Invalid).errors, ['bad input']);
      });

      test('invalidAll() holds multiple errors', () {
        final v = Validated<String, int>.invalidAll(['err1', 'err2']);
        expect((v as Invalid).errors, ['err1', 'err2']);
      });

      test('invalidAll() throws on empty list', () {
        expect(
          () => Validated<String, int>.invalidAll([]),
          throwsA(isA<InvalidArgument>()),
        );
      });
    });

    // -------------------------------------------------------------------------
    // valueOr
    // -------------------------------------------------------------------------
    group('valueOr', () {
      test('returns value when valid', () {
        expect(Validated<String, int>.valid(5).valueOr(0), 5);
      });

      test('returns fallback when invalid', () {
        expect(Validated<String, int>.invalid('err').valueOr(0), 0);
      });
    });

    // -------------------------------------------------------------------------
    // map
    // -------------------------------------------------------------------------
    group('map', () {
      test('transforms valid value', () {
        final v = Validated<String, int>.valid(5).map((x) => x * 2);
        expect(v, equals(Validated<String, int>.valid(10)));
      });

      test('passes through invalid', () {
        final v = Validated<String, int>.invalid('err').map((x) => x * 2);
        expect(v.isInvalid, isTrue);
        expect((v as Invalid).errors, ['err']);
      });
    });

    // -------------------------------------------------------------------------
    // mapError
    // -------------------------------------------------------------------------
    group('mapError', () {
      test('transforms errors', () {
        final v = Validated<String, int>.invalid(
          'error',
        ).mapError((e) => e.length);
        expect((v as Invalid<int, int>).errors, [5]);
      });

      test('passes through valid', () {
        final v = Validated<String, int>.valid(10).mapError((e) => e.length);
        expect((v as Valid).value, 10);
      });
    });

    // -------------------------------------------------------------------------
    // andThen
    // -------------------------------------------------------------------------
    group('andThen', () {
      test('chains valid computations', () {
        final result = Validated<String, int>.valid(
          5,
        ).andThen((x) => Validated.valid(x * 2));
        expect((result as Valid).value, 10);
      });

      test('short-circuits on invalid', () {
        final result = Validated<String, int>.invalid(
          'first error',
        ).andThen((x) => Validated.valid(x * 2));
        expect(result.isInvalid, isTrue);
        expect((result as Invalid).errors, ['first error']);
      });

      test('andThen can return invalid', () {
        final result = Validated<String, int>.valid(
          5,
        ).andThen((_) => Validated<String, int>.invalid('step error'));
        expect(result.isInvalid, isTrue);
      });
    });

    // -------------------------------------------------------------------------
    // zip — the key distinguishing operation
    // -------------------------------------------------------------------------
    group('zip', () {
      test('valid + valid produces a valid pair', () {
        final age = Validated<String, int>.valid(25);
        final name = Validated<String, String>.valid('Alice');
        final combined = age.zip(name);
        expect(combined.isValid, isTrue);
        expect((combined as Valid).value, (25, 'Alice'));
      });

      test('invalid + valid propagates errors', () {
        final bad = Validated<String, int>.invalid('Age error');
        final good = Validated<String, String>.valid('Alice');
        final combined = bad.zip(good);
        expect(combined.isInvalid, isTrue);
        expect((combined as Invalid).errors, ['Age error']);
      });

      test('valid + invalid propagates errors', () {
        final good = Validated<String, int>.valid(25);
        final bad = Validated<String, String>.invalid('Name error');
        final combined = good.zip(bad);
        expect(combined.isInvalid, isTrue);
        expect((combined as Invalid).errors, ['Name error']);
      });

      test('invalid + invalid ACCUMULATES all errors', () {
        final bad1 = Validated<String, int>.invalid('Age error');
        final bad2 = Validated<String, String>.invalid('Name error');
        final combined = bad1.zip(bad2);
        expect(combined.isInvalid, isTrue);
        // Both errors must be present — this is the key distinction from Expected
        expect((combined as Invalid).errors, ['Age error', 'Name error']);
      });

      test('multi-error invalid + multi-error invalid accumulates all', () {
        final bad1 = Validated<String, int>.invalidAll(['err1', 'err2']);
        final bad2 = Validated<String, String>.invalidAll(['err3', 'err4']);
        final combined = bad1.zip(bad2);
        expect((combined as Invalid).errors, ['err1', 'err2', 'err3', 'err4']);
      });
    });

    // -------------------------------------------------------------------------
    // Equality
    // -------------------------------------------------------------------------
    group('equality', () {
      test('equal valid instances are equal', () {
        final a = Validated<String, int>.valid(10);
        final b = Validated<String, int>.valid(10);
        expect(a, equals(b));
        expect(a.hashCode, equals(b.hashCode));
      });

      test('different valid values are not equal', () {
        final a = Validated<String, int>.valid(10);
        final b = Validated<String, int>.valid(11);
        expect(a, isNot(equals(b)));
      });

      test('equal invalid instances are equal', () {
        final a = Validated<String, int>.invalid('err');
        final b = Validated<String, int>.invalid('err');
        expect(a, equals(b));
      });

      test('valid and invalid are not equal', () {
        final a = Validated<String, int>.valid(1);
        final b = Validated<String, int>.invalid('err');
        expect(a, isNot(equals(b)));
      });
    });

    group('toString', () {
      test('valid toString', () {
        expect(Validated<String, int>.valid(42).toString(), 'Valid(42)');
      });

      test('invalid toString', () {
        expect(
          Validated<String, int>.invalid('oops').toString(),
          'Invalid([oops])',
        );
      });
    });
  });
}
