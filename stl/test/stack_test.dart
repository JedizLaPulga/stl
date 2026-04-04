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
      stack.pop();
      
      expect(stack.size, equals(2));
      expect(stack.top, equals(20));
      
      stack.pop();
      expect(stack.top, equals(10));
      
      stack.pop();
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
  });
}
