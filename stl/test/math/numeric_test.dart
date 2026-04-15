import 'package:test/test.dart';
import 'package:stl/stl.dart';

void main() {
  group('Numeric Algorithms', () {
    test('accumulate', () {
      final list = [1, 2, 3, 4, 5];
      expect(list.accumulate(0), equals(15));
      expect(list.accumulate(10), equals(25));
      
      // Custom operator
      expect(list.accumulate(1, (a, b) => a * b), equals(120));
      
      final listDouble = [1.1, 2.2, 3.3];
      expect(listDouble.accumulate(0.0), closeTo(6.6, 0.001));
    });

    test('cppReduce', () {
      final list = [1, 2, 3, 4, 5];
      expect(list.cppReduce(), equals(15));
      expect(list.cppReduce((a, b) => a * b), equals(120));
      
      expect(() => <int>[].cppReduce(), throwsStateError);
    });

    test('innerProduct', () {
      final list1 = [1, 2, 3];
      final list2 = [4, 5, 6];
      // 1*4 + 2*5 + 3*6 = 4 + 10 + 18 = 32
      expect(list1.innerProduct(list2, 0), equals(32));
      
      // Custom operators: sum of differences
      expect(list1.innerProduct(list2, 0, 
        op1: (a, b) => a + b,
        op2: (a, b) => a - b
      ), equals(-9)); // (1-4) + (2-5) + (3-6) = -3 + -3 + -3 = -9
    });

    test('adjacentDifference', () {
      final list = [1, 3, 6, 10];
      // Expected diffs: [1, 3-1, 6-3, 10-6] = [1, 2, 3, 4]
      expect(list.adjacentDifference(), equals([1, 2, 3, 4]));
      
      // Custom operator: addition
      expect(list.adjacentDifference((a, b) => a + b), equals([1, 4, 9, 16]));
      
      expect(<int>[].adjacentDifference(), equals([]));
      expect([5].adjacentDifference(), equals([5]));
    });

    test('partialSum', () {
      final list = [1, 2, 3, 4];
      // Expected partial sums: [1, 1+2, 1+2+3, 1+2+3+4] = [1, 3, 6, 10]
      expect(list.partialSum(), equals([1, 3, 6, 10]));
      
      // Custom operator: multiplication
      expect(list.partialSum((a, b) => a * b), equals([1, 2, 6, 24]));
      
      expect(<int>[].partialSum(), equals([]));
      expect([5].partialSum(), equals([5]));
    });

    test('iota', () {
      final list = List<int>.filled(5, 0);
      list.iota(10);
      expect(list, equals([10, 11, 12, 13, 14]));
      
      final listDouble = List<double>.filled(4, 0.0);
      listDouble.iota(0.5, (val) => val + 0.5);
      expect(listDouble, equals([0.5, 1.0, 1.5, 2.0]));
    });
  });
}
