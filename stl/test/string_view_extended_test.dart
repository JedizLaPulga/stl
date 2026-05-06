// v0.6.4 Extended StringView Tests
// Covers edge cases not in string_view_test.dart:
// bounds errors, equality/hashCode, empty-string behaviour,
// split with empty delimiter, toUpperCase/toLowerCase.
import 'package:test/test.dart';
import 'package:stl/stl.dart';

void main() {
  // -----------------------------------------------------------------------
  // Bounds checking
  // -----------------------------------------------------------------------
  group('StringView - Bounds checking', () {
    test('operator[] throws RangeError on negative index', () {
      final view = StringView('hello');
      expect(() => view[-1], throwsRangeError);
    });

    test('operator[] throws RangeError on index == length', () {
      final view = StringView('hello');
      expect(() => view[5], throwsRangeError);
    });

    test('operator[] throws RangeError on index > length', () {
      final view = StringView('hi');
      expect(() => view[99], throwsRangeError);
    });

    test('substring throws RangeError when start < 0', () {
      final view = StringView('hello');
      expect(() => view.substring(-1), throwsRangeError);
    });

    test('substring throws RangeError when end > length', () {
      final view = StringView('hello');
      expect(() => view.substring(0, 99), throwsRangeError);
    });

    test('substring throws RangeError when start > end', () {
      final view = StringView('hello');
      expect(() => view.substring(3, 1), throwsRangeError);
    });

    test(
      'StringView.substring constructor throws RangeError for invalid bounds',
      () {
        expect(() => StringView.substring('hello', -1, 3), throwsRangeError);
        expect(() => StringView.substring('hello', 0, 99), throwsRangeError);
        expect(() => StringView.substring('hello', 3, 1), throwsRangeError);
      },
    );

    test('valid boundary: operator[] at first and last index', () {
      final view = StringView('abc');
      expect(view[0], equals('a'));
      expect(view[2], equals('c'));
    });
  });

  // -----------------------------------------------------------------------
  // Empty string edge cases
  // -----------------------------------------------------------------------
  group('StringView - Empty string', () {
    test('empty view has length 0 and isEmpty true', () {
      final view = StringView('');
      expect(view.length, equals(0));
      expect(view.isEmpty, isTrue);
      expect(view.isNotEmpty, isFalse);
    });

    test('trim on all-whitespace returns empty view', () {
      final view = StringView('   \t\n').trim();
      expect(view.isEmpty, isTrue);
      expect(view.toString(), equals(''));
    });

    test('trim on already-empty returns empty view', () {
      final view = StringView('').trim();
      expect(view.isEmpty, isTrue);
    });

    test('startsWith empty pattern returns true', () {
      expect(StringView('hello').startsWith(''), isTrue);
      expect(StringView('').startsWith(''), isTrue);
    });

    test('endsWith empty pattern returns true', () {
      expect(StringView('hello').endsWith(''), isTrue);
      expect(StringView('').endsWith(''), isTrue);
    });

    test('indexOf empty pattern returns start index', () {
      expect(StringView('abc').indexOf(''), equals(0));
      expect(StringView('abc').indexOf('', 2), equals(2));
    });

    test('contains empty pattern returns true', () {
      expect(StringView('hello').contains(''), isTrue);
    });

    test('compareTo empty vs non-empty: empty is less', () {
      final empty = StringView('');
      final nonEmpty = StringView('a');
      expect(empty.compareTo(nonEmpty), isNegative);
      expect(nonEmpty.compareTo(empty), isPositive);
    });

    test('compareTo two empty views returns 0', () {
      expect(StringView('').compareTo(StringView('')), equals(0));
    });

    test('empty view operators', () {
      final e = StringView('');
      final a = StringView('a');
      expect(e < a, isTrue);
      expect(a > e, isTrue);
      expect(e <= e, isTrue);
      expect(e >= e, isTrue);
    });
  });

  // -----------------------------------------------------------------------
  // Equality and hashCode
  // -----------------------------------------------------------------------
  group('StringView - Equality and hashCode', () {
    test('two views of the same string content are equal', () {
      final a = StringView('hello');
      final b = StringView('hello');
      expect(a == b, isTrue);
    });

    test('views of different content are not equal', () {
      expect(StringView('abc') == StringView('abd'), isFalse);
    });

    test('view equals against same String', () {
      final view = StringView('dart');
      // StringView.== explicitly supports String comparison; suppress lint.
      // ignore: unrelated_type_equality_checks
      expect(view == 'dart', isTrue);
      // ignore: unrelated_type_equality_checks
      expect(view == 'Dart', isFalse);
    });

    test('substring views with same content are equal', () {
      final whole = StringView('hello world');
      final sub1 = whole.substring(6, 11); // "world"
      final sub2 = StringView('world');
      expect(sub1 == sub2, isTrue);
    });

    test('equal views have equal hashCodes', () {
      final a = StringView('foo');
      final b = StringView('foo');
      expect(a == b, isTrue);
      expect(a.hashCode, equals(b.hashCode));
    });

    test('views with different lengths are not equal', () {
      expect(StringView('ab') == StringView('abc'), isFalse);
    });
  });

  // -----------------------------------------------------------------------
  // split edge cases
  // -----------------------------------------------------------------------
  group('StringView - split edge cases', () {
    test('split with empty delimiter returns one-character views', () {
      final parts = StringView('abc').split('');
      expect(parts.length, equals(3));
      expect(parts[0].toString(), equals('a'));
      expect(parts[1].toString(), equals('b'));
      expect(parts[2].toString(), equals('c'));
    });

    test('split empty view on non-empty delimiter returns one empty view', () {
      final parts = StringView('').split(',');
      expect(parts.length, equals(1));
      expect(parts[0].toString(), equals(''));
    });

    test('split with consecutive delimiters produces empty views', () {
      final parts = StringView('a,,b').split(',');
      expect(parts.length, equals(3));
      expect(parts[0].toString(), equals('a'));
      expect(parts[1].toString(), equals(''));
      expect(parts[2].toString(), equals('b'));
    });

    test('split with leading delimiter produces empty first view', () {
      final parts = StringView(',a,b').split(',');
      expect(parts.length, equals(3));
      expect(parts[0].toString(), equals(''));
    });

    test(
      'split where delimiter equals whole view produces two empty views',
      () {
        final parts = StringView(',').split(',');
        expect(parts.length, equals(2));
        expect(parts[0].toString(), equals(''));
        expect(parts[1].toString(), equals(''));
      },
    );
  });

  // -----------------------------------------------------------------------
  // lastIndexOf edge cases
  // -----------------------------------------------------------------------
  group('StringView - lastIndexOf edge cases', () {
    test('lastIndexOf with empty pattern', () {
      // Empty pattern returns searchEnd (which defaults to length-1)
      final view = StringView('abc');
      expect(view.lastIndexOf(''), equals(2));
    });

    test('lastIndexOf pattern longer than view returns -1', () {
      expect(StringView('hi').lastIndexOf('hello'), equals(-1));
    });

    test('lastIndexOf on empty view returns -1 for non-empty pattern', () {
      expect(StringView('').lastIndexOf('a'), equals(-1));
    });
  });

  // -----------------------------------------------------------------------
  // toUpperCase / toLowerCase
  // -----------------------------------------------------------------------
  group('StringView - toUpperCase / toLowerCase', () {
    test('toUpperCase converts all characters', () {
      expect(StringView('hello World').toUpperCase(), equals('HELLO WORLD'));
    });

    test('toLowerCase converts all characters', () {
      expect(StringView('Hello WORLD').toLowerCase(), equals('hello world'));
    });

    test('toUpperCase on empty string returns empty string', () {
      expect(StringView('').toUpperCase(), equals(''));
    });

    test('toLowerCase on empty string returns empty string', () {
      expect(StringView('').toLowerCase(), equals(''));
    });

    test('toUpperCase on already-uppercase is idempotent', () {
      expect(StringView('DART').toUpperCase(), equals('DART'));
    });
  });

  // -----------------------------------------------------------------------
  // toString
  // -----------------------------------------------------------------------
  group('StringView - toString', () {
    test('toString returns correct slice', () {
      final view = StringView.substring('hello world', 6, 11);
      expect(view.toString(), equals('world'));
    });

    test('toString on empty view returns empty string', () {
      expect(StringView('').toString(), equals(''));
    });
  });
}
