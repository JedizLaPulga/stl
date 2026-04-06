import 'package:test/test.dart';
import 'package:stl/src/ranges/numberline.dart';
import 'package:stl/stl.dart';

void main() {
  group('NumberLine<int>', () {
    test('ascending positive range', () {
      var range = NumberLine(0, 5);
      expect(range.toList(), equals([0, 1, 2, 3, 4]));
      expect(range.contains(3), isTrue);
      expect(range.contains(5), isFalse);
    });

    test('descending range with negative step', () {
      var range = NumberLine(5, 0, step: -2);
      expect(range.toList(), equals([5, 3, 1]));
      expect(range.contains(1), isTrue);
      expect(range.contains(0), isFalse);
      expect(range.contains(2), isFalse);
    });

    test('custom positive step', () {
      var range = NumberLine<int>(0, 10, step: 2);
      expect(range.toList(), equals([0, 2, 4, 6, 8]));
      expect(range.contains(4), isTrue);
      expect(range.contains(5), isFalse);
    });

    test('empty range', () {
      var range = NumberLine(5, 0); // step = 1 (default), start > end -> empty
      expect(range.toList(), isEmpty);
    });

    test('iterable mixin integration', () {
      var range = NumberLine(1, 6);
      expect(range.where((x) => x.isEven).toList(), equals([2, 4]));
      expect(range.reduce((a, b) => a + b), equals(15)); // 1+2+3+4+5
    });
  });

  group('NumberLine<double>', () {
    test('ascending double range', () {
      var range = NumberLine<double>(0.0, 2.0, step: 0.5);
      expect(range.toList(), equals([0.0, 0.5, 1.0, 1.5]));
      expect(range.contains(1.5), isTrue);
      expect(range.contains(2.0), isFalse);
    });

    test('descending double range', () {
      var range = NumberLine(2.0, -1.0, step: -0.5);
      expect(range.toList(), equals([2.0, 1.5, 1.0, 0.5, 0.0, -0.5]));
      expect(range.contains(0.0), isTrue);
    });

    test('iterable mixin features', () {
      var range = NumberLine<double>(0.0, 2.0, step: 0.5);
      expect(range.map((e) => e * 2).toList(), equals([0.0, 1.0, 2.0, 3.0]));
      expect(range.where((element) => element >= 1.0).toList(), equals([1.0, 1.5]));
    });
  });
}
