import 'package:test/test.dart';
import 'package:stl/stl.dart';

void main() {
  group('Iterator Adapters Tests', () {
    test('ReverseIterator', () {
      final list = [1, 2, 3, 4, 5];
      final reversed = ReverseIterator(list).toList();
      expect(reversed, equals([5, 4, 3, 2, 1]));
    });

    test('BackInsertIterator with List', () {
      final list = <int>[1, 2];
      final inserter = BackInsertIterator(list);
      inserter.add(3);
      inserter.add(4);
      expect(list, equals([1, 2, 3, 4]));
    });

    test('BackInsertIterator with Vector', () {
      final vec = Vector([1, 2]);
      final inserter = BackInsertIterator(vec);
      inserter.add(3);
      inserter.add(4);
      expect(vec.toList(), equals([1, 2, 3, 4]));
    });

    test('FrontInsertIterator with List', () {
      final list = <int>[3, 4];
      final inserter = FrontInsertIterator(list);
      inserter.add(2);
      inserter.add(1);
      // FrontInsertIterator pushes to index 0, pushing 2 then 1 makes it [1, 2, 3, 4]
      expect(list, equals([1, 2, 3, 4]));
    });

    test('FrontInsertIterator with Deque', () {
      final deque = Deque<int>()..pushBack(3)..pushBack(4);
      final inserter = FrontInsertIterator(deque);
      inserter.add(2);
      inserter.add(1);
      expect(deque.toList(), equals([1, 2, 3, 4]));
    });

    test('InsertIterator', () {
      final list = <int>[1, 4, 5];
      final inserter = InsertIterator(list, 1);
      inserter.add(2);
      inserter.add(3);
      expect(list, equals([1, 2, 3, 4, 5]));
    });
  });
}
