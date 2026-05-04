import 'package:test/test.dart';
import 'package:stl/stl.dart';

void main() {
  group('StringView Tests', () {
    test('basic operations', () {
      final view = StringView('Hello World');
      expect(view.length, 11);
      expect(view[0], 'H');
      expect(view.isEmpty, isFalse);
    });

    test('substring view', () {
      final view = StringView.substring('Hello World', 6, 11);
      expect(view.length, 5);
      expect(view.toString(), 'World');
    });

    test('startsWith and endsWith', () {
      final view = StringView.substring('Hello World!', 0, 11); // "Hello World"
      expect(view.startsWith('Hello'), isTrue);
      expect(view.endsWith('World'), isTrue);
      expect(view.startsWith('World'), isFalse);
    });

    test('indexOf and contains', () {
      final view = StringView('abracadabra');
      expect(view.indexOf('cad'), 4);
      expect(view.contains('cad'), isTrue);
      expect(view.contains('zoo'), isFalse);
    });

    test('trim', () {
      final view = StringView('  hello  ').trim();
      expect(view.toString(), 'hello');
    });

    test('compareTo and relational operators', () {
      final abc = StringView('abc');
      final abd = StringView('abd');
      final ab = StringView('ab');

      expect(abc.compareTo(abc), equals(0));
      expect(abc.compareTo(abd), isNegative);
      expect(abd.compareTo(abc), isPositive);
      expect(ab.compareTo(abc), isNegative); // shorter string is less

      expect(abc < abd, isTrue);
      expect(abc <= abc, isTrue);
      expect(abd > abc, isTrue);
      expect(abc >= abc, isTrue);
      expect(abc < ab, isFalse);
    });

    test('lastIndexOf finds the last occurrence', () {
      final view = StringView('abracadabra');
      expect(view.lastIndexOf('a'), equals(10));
      expect(view.lastIndexOf('abra'), equals(7));
      expect(view.lastIndexOf('z'), equals(-1));
      expect(
        view.lastIndexOf('a', 9),
        equals(7),
      ); // search ending before index 10
    });

    test('split on delimiter produces correct sub-views', () {
      final view = StringView('one,two,three');
      final parts = view.split(',');
      expect(parts.length, equals(3));
      expect(parts[0].toString(), equals('one'));
      expect(parts[1].toString(), equals('two'));
      expect(parts[2].toString(), equals('three'));

      // Trailing delimiter
      final trailing = StringView('a,b,').split(',');
      expect(trailing.length, equals(3));
      expect(trailing[2].toString(), equals(''));

      // No delimiter present — whole view as single element
      final noMatch = StringView('hello').split(',');
      expect(noMatch.length, equals(1));
      expect(noMatch[0].toString(), equals('hello'));
    });

    test('toUpperCase and toLowerCase delegate to Dart runtime', () {
      final view = StringView('Hello World');
      expect(view.toUpperCase(), equals('HELLO WORLD'));
      expect(view.toLowerCase(), equals('hello world'));
    });
  });
}
