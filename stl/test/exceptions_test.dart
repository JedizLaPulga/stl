import 'package:stl/stl.dart';
import 'package:test/test.dart';

void main() {
  group('Exceptions Module Tests', () {
    test('StdException and what()', () {
      final e = StdExceptionImpl('base exception');
      expect(e.what(), equals('base exception'));
      expect(e.toString(), equals('StdExceptionImpl: base exception'));
    });

    test('LogicError hierarchy', () {
      final e = LogicError('logic error');
      expect(e, isA<StdException>());
      expect(e.what(), equals('logic error'));

      final invalidArg = InvalidArgument('invalid argument');
      expect(invalidArg, isA<LogicError>());
      expect(invalidArg.what(), equals('invalid argument'));

      final domain = DomainError('domain error');
      expect(domain, isA<LogicError>());

      final length = LengthError('length error');
      expect(length, isA<LogicError>());

      final outOfRange = OutOfRange('out of range');
      expect(outOfRange, isA<LogicError>());
    });

    test('RuntimeError hierarchy', () {
      final e = RuntimeError('runtime error');
      expect(e, isA<StdException>());
      expect(e.what(), equals('runtime error'));

      final range = StdRangeError('range error');
      expect(range, isA<RuntimeError>());

      final overflow = OverflowError('overflow error');
      expect(overflow, isA<RuntimeError>());

      final underflow = UnderflowError('underflow error');
      expect(underflow, isA<RuntimeError>());
    });
  });
}

class StdExceptionImpl extends StdException {
  const StdExceptionImpl(super.message);
}
