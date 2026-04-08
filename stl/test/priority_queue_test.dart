import 'package:test/test.dart';
import 'package:stl/stl.dart';

void main() {
  group('PriorityQueue', () {
    test('push and pop (default max-heap)', () {
      final pq = PriorityQueue<int>();
      expect(pq.empty, isTrue);

      pq.push(10);
      pq.push(30);
      pq.push(20);

      expect(pq.size, equals(3));
      expect(pq.empty, isFalse);

      expect(pq.top, equals(30)); 
      expect(pq.pop(), equals(30));
      expect(pq.pop(), equals(20));
      expect(pq.pop(), equals(10));
      expect(pq.empty, isTrue);
    });

    test('custom comparator (min-heap)', () {
      // Create a min-heap by reversing the comparison
      final pq = PriorityQueue<int>((a, b) => b.compareTo(a));
      
      pq.push(5);
      pq.push(1);
      pq.push(10);
      
      expect(pq.top, equals(1));
      expect(pq.pop(), equals(1));
      expect(pq.pop(), equals(5));
      expect(pq.pop(), equals(10));
    });

    test('from iterable', () {
      final pq = PriorityQueue<int>.from([15, 5, 20, 10]);
      
      expect(pq.size, equals(4));
      expect(pq.pop(), equals(20));
      expect(pq.pop(), equals(15));
      expect(pq.pop(), equals(10));
      expect(pq.pop(), equals(5));
    });

    test('complex class with custom compare', () {
      final elements = ['apple', 'banana', 'kiwi', 'strawberry'];
      // Max-heap based on string length
      final pq = PriorityQueue<String>((a, b) => a.length.compareTo(b.length));
      
      for (final e in elements) {
        pq.push(e);
      }
      
      expect(pq.pop(), equals('strawberry')); // 10
      expect(pq.pop(), equals('banana')); // 6
      expect(pq.pop(), equals('apple')); // 5
      expect(pq.pop(), equals('kiwi')); // 4
    });

    test('clear', () {
      final pq = PriorityQueue<int>.from([1, 2, 3]);
      expect(pq.size, equals(3));
      pq.clear();
      expect(pq.size, equals(0));
      expect(pq.empty, isTrue);
    });

    test('swap', () {
      final pq1 = PriorityQueue<int>.from([10, 20]);
      final pq2 = PriorityQueue<int>.from([100, 200, 300]);

      pq1.swap(pq2);

      expect(pq1.size, equals(3));
      expect(pq1.top, equals(300));
      expect(pq2.size, equals(2));
      expect(pq2.top, equals(20));
    });

    test('StateErrors on empty queue', () {
      final pq = PriorityQueue<int>();

      expect(() => pq.pop(), throwsStateError);
      expect(() => pq.top, throwsStateError);
    });

    test('Equality and formatting', () {
      final pq1 = PriorityQueue<int>.from([10, 20, 30]);
      final pq2 = PriorityQueue<int>.from([10, 20, 30]);
      final pq3 = PriorityQueue<int>.from([30, 20]);

      expect(pq1, equals(pq2));
      expect(pq1, isNot(equals(pq3)));
      expect(pq1.toString(), contains('PriorityQueue'));
    });
  });
}
