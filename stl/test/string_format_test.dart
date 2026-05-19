import 'package:test/test.dart';
import 'package:stl/stl.dart';

void main() {
  group('format', () {
    test('basic automatic positional formatting', () {
      expect(format('Hello {}', ['World']), equals('Hello World'));
      expect(format('{} + {} = {}', [1, 2, 3]), equals('1 + 2 = 3'));
    });

    test('explicit positional formatting', () {
      expect(format('{1} comes after {0}', ['A', 'B']), equals('B comes after A'));
    });

    test('escaping braces', () {
      expect(format('{{hello}} {}', ['world']), equals('{hello} world'));
    });

    test('specifier formatting', () {
      expect(format('{:.2f}', [3.14159]), equals('3.14'));
      expect(format('{:x}', [255]), equals('ff'));
      expect(format('{:X}', [255]), equals('FF'));
      expect(format('{:04d}', [42]), equals('0042'));
      expect(format('{0:05d}', [7]), equals('00007'));
    });

    test('throws on unmatched braces', () {
      expect(() => format('Hello {', []), throwsFormatException);
      expect(() => format('Hello }', []), throwsFormatException);
    });

    test('throws on out of bounds arguments', () {
      expect(() => format('Hello {}', []), throwsRangeError);
      expect(() => format('Hello {1}', ['A']), throwsRangeError);
    });
  });
}
