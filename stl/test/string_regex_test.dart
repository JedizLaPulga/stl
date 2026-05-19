import 'package:test/test.dart';
import 'package:stl/stl.dart';

void main() {
  group('Regex', () {
    test('regexMatch strictly matches whole string', () {
      final r = Regex(r'^[a-z]+$');
      expect(regexMatch('hello', r), isTrue);
      expect(regexMatch('hello world', r), isFalse);
      expect(regexMatch('123hello', r), isFalse);
    });

    test('regexSearch finds partial matches', () {
      final r = Regex(r'[0-9]+');
      expect(regexSearch('hello 123 world', r), isTrue);
      expect(regexSearch('hello world', r), isFalse);
    });

    test('regexReplace replaces all occurrences', () {
      final r = Regex(r'\s+');
      expect(regexReplace('hello   world', r, '-'), equals('hello-world'));
    });

    test('RegexIterator lazily yields all matches', () {
      final r = Regex(r'\w+');
      final iter = RegexIterator('hello world dart', r);
      
      expect(iter.moveNext(), isTrue);
      expect(iter.current.group(0), equals('hello'));
      
      expect(iter.moveNext(), isTrue);
      expect(iter.current.group(0), equals('world'));
      
      expect(iter.moveNext(), isTrue);
      expect(iter.current.group(0), equals('dart'));
      
      expect(iter.moveNext(), isFalse);
    });
  });
}
