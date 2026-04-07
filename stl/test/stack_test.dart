import 'package:test/test.dart';
import 'package:stl/stl.dart';

void main() {
  group('Stack', () {
    test('Initialization and empty check', () {
      final stack = Stack<int>();
      expect(stack.empty, isTrue);
      expect(stack.isNotEmpty, isFalse);
      expect(stack.size, equals(0));
    });

    test('Initialization from iterable', () {
      final stack = Stack<int>.from([1, 2, 3]);
      expect(stack.empty, isFalse);
      expect(stack.size, equals(3));
      expect(stack.top, equals(3)); // Top element is the last from iterable
    });

    test('Push and Top', () {
      final stack = Stack<String>();
      stack.push('a');
      expect(stack.top, equals('a'));
      expect(stack.size, equals(1));

      stack.push('b');
      expect(stack.top, equals('b'));
      expect(stack.size, equals(2));
    });

    test('Pop', () {
      final stack = Stack<int>.from([10, 20, 30]);

      expect(stack.top, equals(30));
      final popped1 = stack.pop();
      expect(popped1, equals(30));

      expect(stack.size, equals(2));
      expect(stack.top, equals(20));

      final popped2 = stack.pop();
      expect(popped2, equals(20));
      expect(stack.top, equals(10));

      final popped3 = stack.pop();
      expect(popped3, equals(10));
      expect(stack.empty, isTrue);
    });

    test('Clear', () {
      final stack = Stack<int>.from([1, 2, 3]);
      stack.clear();
      expect(stack.empty, isTrue);
      expect(stack.size, equals(0));
    });

    test('Throws StateError on empty pop or top', () {
      final stack = Stack<int>();

      expect(() => stack.top, throwsStateError);
      expect(() => stack.pop(), throwsStateError);
    });

    test('New 0.2.0 Methods: swap', () {
      final stack1 = Stack<int>.from([1, 2]);
      final stack2 = Stack<int>.from([3, 4, 5]);

      stack1.swap(stack2);
      expect(stack1.size, equals(3));
      expect(stack2.size, equals(2));
      expect(stack1.top, equals(5));
      expect(stack2.top, equals(2));
    });

    test('Iterable properties (LIFO order)', () {
      final stack = Stack<int>.from([1, 2, 3]);

      // Top element is 3. Iteration should be 3, 2, 1.
      final asList = stack.toList();
      expect(asList, equals([3, 2, 1]));

      final mapped = stack.map((x) => x * 10).toList();
      expect(mapped, equals([30, 20, 10]));
    });

    test('Equality and HashCode', () {
      final stack1 = Stack<int>.from([1, 2, 3]);
      final stack2 = Stack<int>.from([1, 2, 3]);
      final stack3 = Stack<int>.from([1, 2, 4]);

      expect(stack1 == stack2, isTrue);
      expect(stack1.hashCode == stack2.hashCode, isTrue);

      expect(stack1 == stack3, isFalse);
    });

    test('Search Utilities (contains, elementAt)', () {
      final stack = Stack<int>.from([10, 20, 30]);

      // Top is 30, index 0. Then 20 at index 1. Then 10 at index 2.
      expect(stack.contains(20), isTrue);
      expect(stack.contains(40), isFalse);

      expect(stack.elementAt(0), equals(30));
      expect(stack.elementAt(2), equals(10));
    });
  });
}
