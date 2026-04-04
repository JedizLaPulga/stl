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
  });
}
