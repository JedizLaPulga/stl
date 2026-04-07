import 'package:test/test.dart';
import 'package:stl/stl.dart';

void main() {
  group('Vector', () {
    test('Initialization', () {
      final vec = Vector<int>(<int>[]);
      expect(vec.empty(), isTrue);
      expect(vec.size(), equals(0));
    });

    test('Const initialization', () {
      const vec = Vector<int>([10, 20]);
      expect(vec.size(), equals(2));
    });

    test('Element access', () {
      final vec = Vector<int>([10, 20, 30]);
      expect(vec[0], equals(10));
      expect(vec.at(1), equals(20));
      expect(vec.front(), equals(10));
      expect(vec.back(), equals(30));

      vec[1] = 25;
      expect(vec[1], equals(25));
    });

    test('Bounds checking', () {
      final vec = Vector<int>([10]);

      expect(() => vec[1], throwsRangeError);
      expect(() => vec[-1], throwsRangeError);
      expect(() => vec.at(1), throwsRangeError);

      final emptyVec = Vector<int>(<int>[]);
      expect(() => emptyVec.front(), throwsStateError);
      expect(() => emptyVec.back(), throwsStateError);
    });

    test('Modifiers', () {
      final vec = Vector<int>(<int>[]);

      vec.pushBack(10);
      expect(vec.size(), equals(1));
      expect(vec.back(), equals(10));

      vec.insert(0, 5);
      expect(vec.front(), equals(5));
      expect(vec.size(), equals(2));

      vec.popBack();
      expect(vec.size(), equals(1));
      expect(vec.back(), equals(5));

      vec.clear();
      expect(vec.empty(), isTrue);
    });

    test('Equality and comparison', () {
      final vec1 = Vector<int>([1, 2, 3]);
      final vec2 = Vector<int>([1, 2, 3]);
      final vec3 = Vector<int>([1, 2, 4]);

      expect(vec1 == vec2, isTrue);
      expect(vec1 == vec3, isFalse);

      expect(vec1 < vec3, isTrue);
      expect(vec3 > vec1, isTrue);
    });

    test('Operators: +, -, *', () {
      final vec1 = Vector<int>([1, 2]);
      final vec2 = Vector<int>([3, 4]);

      final added = vec1 + vec2;
      expect(added.size(), equals(4));
      expect(added[2], equals(3));

      final multiplied = vec1 * 2;
      expect(multiplied.size(), equals(4));
      expect(multiplied[2], equals(1));

      final vec3 = Vector<int>([1, 2, 3, 2, 4]);
      final vec4 = Vector<int>([2]);
      final subtracted = vec3 - vec4;
      expect(subtracted.size(), equals(3));
      expect(subtracted[0], equals(1));
      expect(subtracted[1], equals(3));
    });

    test('Iterable methods', () {
      final vec = Vector<int>([1, 2, 3]);
      int sum = 0;
      for (var element in vec) {
        sum += element;
      }
      expect(sum, equals(6));
    });

    test('New 0.2.0 Methods: assign, resize, insertAll, swap', () {
      final vec1 = Vector<int>([1, 2, 3]);
      final vec2 = Vector<int>([4, 5]);

      vec1.swap(vec2);
      expect(vec1.size(), equals(2));
      expect(vec2.size(), equals(3));
      expect(vec1[0], equals(4));
      expect(vec2[0], equals(1));

      vec1.assign(3, 9);
      expect(vec1.size(), equals(3));
      expect(vec1[0], equals(9));
      expect(vec1[2], equals(9));

      vec1.resize(5, 0);
      expect(vec1.size(), equals(5));
      expect(vec1[4], equals(0));

      vec1.resize(2, 0);
      expect(vec1.size(), equals(2));
      expect(vec1[1], equals(9));

      vec1.insertAll(1, [8, 8]);
      expect(vec1.size(), equals(4));
      expect(vec1[1], equals(8));
      expect(vec1[2], equals(8));
      expect(vec1[3], equals(9));
    });
  });
}
