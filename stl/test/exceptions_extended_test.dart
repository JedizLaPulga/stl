// v0.6.4 Extended Exceptions Tests
// Covers catchability via base type, empty messages, toString on all subtypes,
// and hierarchy completeness — gaps identified in the v0.6.4 audit.
import 'package:test/test.dart';
import 'package:stl/stl.dart';

void main() {
  // -----------------------------------------------------------------------
  // toString on every concrete type
  // -----------------------------------------------------------------------
  group('Exceptions - toString format', () {
    test('InvalidArgument toString', () {
      const e = InvalidArgument('bad arg');
      expect(e.toString(), equals('InvalidArgument: bad arg'));
    });

    test('DomainError toString', () {
      const e = DomainError('out of domain');
      expect(e.toString(), equals('DomainError: out of domain'));
    });

    test('LengthError toString', () {
      const e = LengthError('too long');
      expect(e.toString(), equals('LengthError: too long'));
    });

    test('OutOfRange toString', () {
      const e = OutOfRange('index 99');
      expect(e.toString(), equals('OutOfRange: index 99'));
    });

    test('RuntimeError toString', () {
      const e = RuntimeError('runtime failure');
      expect(e.toString(), equals('RuntimeError: runtime failure'));
    });

    test('StdRangeError toString', () {
      const e = StdRangeError('range exceeded');
      expect(e.toString(), equals('StdRangeError: range exceeded'));
    });

    test('OverflowError toString', () {
      const e = OverflowError('integer overflow');
      expect(e.toString(), equals('OverflowError: integer overflow'));
    });

    test('UnderflowError toString', () {
      const e = UnderflowError('integer underflow');
      expect(e.toString(), equals('UnderflowError: integer underflow'));
    });
  });

  // -----------------------------------------------------------------------
  // Empty message
  // -----------------------------------------------------------------------
  group('Exceptions - empty message', () {
    test('StdException with empty message: what() returns empty string', () {
      const e = InvalidArgument('');
      expect(e.what(), equals(''));
    });

    test('StdException with empty message: toString contains type name', () {
      const e = DomainError('');
      expect(e.toString(), equals('DomainError: '));
    });
  });

  // -----------------------------------------------------------------------
  // Catchability via base type (hierarchy correctness)
  // -----------------------------------------------------------------------
  group('Exceptions - catch by base type', () {
    test('InvalidArgument is caught as LogicError', () {
      expect(
        () => throw const InvalidArgument('bad'),
        throwsA(isA<LogicError>()),
      );
    });

    test('DomainError is caught as LogicError', () {
      expect(
        () => throw const DomainError('domain'),
        throwsA(isA<LogicError>()),
      );
    });

    test('LengthError is caught as LogicError', () {
      expect(
        () => throw const LengthError('length'),
        throwsA(isA<LogicError>()),
      );
    });

    test('OutOfRange is caught as LogicError', () {
      expect(() => throw const OutOfRange('range'), throwsA(isA<LogicError>()));
    });

    test('StdRangeError is caught as RuntimeError', () {
      expect(
        () => throw const StdRangeError('range'),
        throwsA(isA<RuntimeError>()),
      );
    });

    test('OverflowError is caught as RuntimeError', () {
      expect(
        () => throw const OverflowError('overflow'),
        throwsA(isA<RuntimeError>()),
      );
    });

    test('UnderflowError is caught as RuntimeError', () {
      expect(
        () => throw const UnderflowError('underflow'),
        throwsA(isA<RuntimeError>()),
      );
    });

    test('All concrete types are caught as StdException', () {
      for (final e in <StdException>[
        const InvalidArgument('x'),
        const DomainError('x'),
        const LengthError('x'),
        const OutOfRange('x'),
        const RuntimeError('x'),
        const StdRangeError('x'),
        const OverflowError('x'),
        const UnderflowError('x'),
      ]) {
        expect(() => throw e, throwsA(isA<StdException>()));
      }
    });

    test('All concrete types are caught as Exception', () {
      for (final e in <StdException>[
        const InvalidArgument('x'),
        const OverflowError('x'),
      ]) {
        expect(() => throw e, throwsA(isA<Exception>()));
      }
    });
  });

  // -----------------------------------------------------------------------
  // what() mirrors message exactly
  // -----------------------------------------------------------------------
  group('Exceptions - what() contract', () {
    test('what() on LogicError subtypes returns message verbatim', () {
      const cases = [
        InvalidArgument('inv'),
        DomainError('dom'),
        LengthError('len'),
        OutOfRange('oor'),
      ];
      for (final e in cases) {
        expect(e.what(), equals(e.message));
      }
    });

    test('what() on RuntimeError subtypes returns message verbatim', () {
      const cases = [
        RuntimeError('rt'),
        StdRangeError('rng'),
        OverflowError('ovf'),
        UnderflowError('udf'),
      ];
      for (final e in cases) {
        expect(e.what(), equals(e.message));
      }
    });
  });
}
