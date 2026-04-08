import 'package:test/test.dart';
import 'package:stl/stl.dart';

void main() {
  group('Deque', () {
    test('Initialization', () {
      final deque = Deque<int>();
      expect(deque.isEmpty, isTrue);
      expect(deque.isNotEmpty, isFalse);
      expect(deque.length, equals(0));
    });

    test('Initialization from iterable', () {
      final deque = Deque<int>.from([1, 2, 3]);
      expect(deque.isEmpty, isFalse);
      expect(deque.length, equals(3));
      expect(deque.getFront(), equals(1));
      expect(deque.getRear(), equals(3));
    });

    test('Insert and delete operations', () {
      final deque = Deque<String>();

      deque.insertLast('a');
      expect(deque.getRear(), equals('a'));
      expect(deque.getFront(), equals('a'));

      deque.insertFront('b');
      expect(deque.getFront(), equals('b'));
      expect(deque.getRear(), equals('a'));
      expect(deque.length, equals(2));

      final back = deque.deleteLast();
      expect(back, equals('a'));
      expect(deque.length, equals(1));
      expect(deque.getFront(), equals('b'));

      final front = deque.deleteFront();
      expect(front, equals('b'));
      expect(deque.isEmpty, isTrue);
    });

    test('Clear', () {
      final deque = Deque<int>.from([1, 2, 3]);
      deque.clear();
      expect(deque.isEmpty, isTrue);
    });

    test('Throws StateError on empty gets and deletes', () {
      final deque = Deque<int>();

      expect(() => deque.getFront(), throwsStateError);
      expect(() => deque.getRear(), throwsStateError);
      expect(() => deque.deleteFront(), throwsStateError);
      expect(() => deque.deleteLast(), throwsStateError);
    });

    test('New 0.2.0 Methods: pushBack etc, operator [], swap', () {
      final deque1 = Deque<int>.from([1, 2, 3]);
      final deque2 = Deque<int>.from([4, 5]);

      deque1.swap(deque2);
      expect(deque1.length, equals(2));
      expect(deque2.length, equals(3));
      expect(deque1.front(), equals(4));
      expect(deque2.back(), equals(3));

      deque1.pushFront(0);
      deque1.pushBack(6);
      expect(deque1.front(), equals(0));
      expect(deque1.back(), equals(6));

      expect(deque1.popFront(), equals(0));
      expect(deque1.popBack(), equals(6));

      expect(deque1[0], equals(4));
      expect(deque1.at(1), equals(5));

      deque1[1] = 9;
      expect(deque1[1], equals(9));

      int sum = 0;
      for (var element in deque1) {
        sum += element;
      }
      expect(sum, equals(13));
    });

    test('Equality and formatting', () {
      final deque1 = Deque<int>.from([1, 2, 3]);
      final deque2 = Deque<int>.from([1, 2, 3]);
      final deque3 = Deque<int>.from([3, 2, 1]);

      expect(deque1, equals(deque2));
      expect(deque1, isNot(equals(deque3)));
      expect(deque1.toString(), equals('Deque([1, 2, 3])'));
    });
  });
}
