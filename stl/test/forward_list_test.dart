import 'package:test/test.dart';
import 'package:stl/stl.dart';

void main() {
  group('ForwardList', () {
    test('Initialization', () {
      final list = ForwardList<int>();
      expect(list.empty(), isTrue);
      expect(list.isEmpty, isTrue); // from Iterable
      expect(list.length, equals(0));
    });

    test('Initialization from iterable', () {
      final list = ForwardList<int>.from([1, 2, 3]);
      expect(list.empty(), isFalse);
      expect(list.length, equals(3));
      expect(list.front(), equals(1));
      
      // Test iterable nature
      final asList = list.toList();
      expect(asList, equals([1, 2, 3]));
    });

    test('Push and Pop Front', () {
      final list = ForwardList<String>();
      
      list.pushFront('a');
      expect(list.front(), equals('a'));
      expect(list.length, equals(1));
      
      list.pushFront('b');
      expect(list.front(), equals('b'));
      expect(list.length, equals(2));
      
      list.popFront();
      expect(list.front(), equals('a'));
      expect(list.length, equals(1));
      
      list.popFront();
      expect(list.empty(), isTrue);
    });

    test('Clear', () {
      final list = ForwardList<int>.from([1, 2, 3]);
      list.clear();
      expect(list.empty(), isTrue);
      expect(list.length, equals(0));
    });

    test('Reverse', () {
      final list = ForwardList<int>.from([1, 2, 3]);
      list.reverse();
      expect(list.toList(), equals([3, 2, 1]));
      expect(list.front(), equals(3));
    });

    test('Throws StateError on empty pop or front', () {
      final list = ForwardList<int>();
      
      expect(() => list.front(), throwsStateError);
      expect(() => list.popFront(), throwsStateError);
    });
    
    test('Iterable methods compatibility', () {
      final list = ForwardList<int>.from([1, 2, 3, 4, 5]);
      
      // reduce
      final sum = list.reduce((a, b) => a + b);
      expect(sum, equals(15));
      
      // where
      final evens = list.where((x) => x % 2 == 0).toList();
      expect(evens, equals([2, 4]));
      
      // map
      final strings = list.map((x) => x.toString()).toList();
      expect(strings, equals(['1', '2', '3', '4', '5']));
    });

    test('New 0.2.0 Methods: remove, removeIf, insertAfter, eraseAfter, unique', () {
      final list = ForwardList<int>.from([1, 2, 2, 3, 3, 3, 4, 1, 5]);
      
      list.unique();
      expect(list.toList(), equals([1, 2, 3, 4, 1, 5]));

      list.remove(1);
      expect(list.toList(), equals([2, 3, 4, 5]));

      list.removeIf((x) => x % 2 == 0);
      expect(list.toList(), equals([3, 5]));

      list.insertAfter(0, 9);
      expect(list.toList(), equals([3, 9, 5]));

      list.eraseAfter(0);
      expect(list.toList(), equals([3, 5]));
    });
  });
}
