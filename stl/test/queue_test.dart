import 'package:test/test.dart';
import 'package:stl/stl.dart';

void main() {
  group('Queue', () {
    test('push and pop', () {
      final q = Queue<int>();
      expect(q.empty, isTrue);

      q.push(1);
      q.push(2);
      q.push(3);

      expect(q.size, equals(3));
      expect(q.empty, isFalse);

      expect(q.pop(), equals(1));
      expect(q.size, equals(2));

      expect(q.pop(), equals(2));
      expect(q.size, equals(1));

      expect(q.pop(), equals(3));
      expect(q.empty, isTrue);
    });

    test('front and back', () {
      final q = Queue<String>();
      q.push('a');
      expect(q.front, equals('a'));
      expect(q.back, equals('a'));

      q.push('b');
      expect(q.front, equals('a'));
      expect(q.back, equals('b'));

      q.push('c');
      expect(q.front, equals('a'));
      expect(q.back, equals('c'));
    });

    test('iterator', () {
      final q = Queue<int>.from([10, 20, 30]);
      final list = q.toList();
      expect(list, equals([10, 20, 30]));
    });

    test('clear', () {
      final q = Queue<int>.from([1, 2, 3]);
      expect(q.size, equals(3));
      q.clear();
      expect(q.size, equals(0));
      expect(q.empty, isTrue);
    });

    test('swap', () {
      final q1 = Queue<int>.from([1, 2]);
      final q2 = Queue<int>.from([3, 4, 5]);

      q1.swap(q2);

      expect(q1.toList(), equals([3, 4, 5]));
      expect(q2.toList(), equals([1, 2]));
    });

    test('equality', () {
      final q1 = Queue<int>.from([1, 2, 3]);
      final q2 = Queue<int>.from([1, 2, 3]);
      final q3 = Queue<int>.from([1, 2]);

      expect(q1, equals(q2));
      expect(q1, isNot(equals(q3)));
    });

    test('StateErrors on empty queue', () {
      final q = Queue<int>();

      expect(() => q.pop(), throwsStateError);
      expect(() => q.front, throwsStateError);
      expect(() => q.back, throwsStateError);
    });
  });
}
