import 'package:test/test.dart';
import 'package:stl/stl.dart';

void main() {
  group('SList Tests', () {
    test('pushFront and pushBack', () {
      final list = SList<int>();
      list.pushBack(2);
      list.pushFront(1);
      list.pushBack(3);
      
      expect(list.length, 3);
      expect(list.front(), 1);
      expect(list.back(), 3);
      expect(list.toList(), [1, 2, 3]);
    });

    test('popFront and popBack', () {
      final list = SList<int>.from([1, 2, 3]);
      list.popFront();
      expect(list.front(), 2);
      expect(list.length, 2);
      
      list.popBack();
      expect(list.back(), 2);
      expect(list.length, 1);
    });

    test('reverse', () {
      final list = SList<int>.from([1, 2, 3]);
      list.reverse();
      expect(list.toList(), [3, 2, 1]);
    });

    test('unique', () {
      final list = SList<int>.from([1, 1, 2, 3, 3, 3]);
      list.unique();
      expect(list.toList(), [1, 2, 3]);
    });

    test('remove and removeIf', () {
      final list = SList<int>.from([1, 2, 3, 4, 5, 2]);
      list.remove(2);
      expect(list.toList(), [1, 3, 4, 5]);

      list.removeIf((val) => val > 3);
      expect(list.toList(), [1, 3]);
    });
  });
}
