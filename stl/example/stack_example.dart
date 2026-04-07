import 'package:stl/stl.dart';

void main() {
  print('--- Stack Feature Showcase ---');

  // 1. Creating a Stack
  print('\n1. Creating a Stack');
  var stack1 = Stack<String>.from(['Bottom', 'Middle', 'Top']);
  print('Stack1 size: ${stack1.size}');
  print('Stack1 top: ${stack1.top}');

  // 2. The improved pop() that returns the element
  print('\n2. Improved pop()');
  var poppedItem = stack1.pop();
  print('Popped item: $poppedItem');
  print('Stack1 top after pop: ${stack1.top}');

  // 3. Iterable Superpowers (for-in loops, map, toList)
  print('\n3. Iterable Powers');
  stack1.push('New Top');
  print('Iterating through stack from top to bottom:');
  for (var item in stack1) {
    print(' - $item');
  }

  var loudStack = stack1.map((item) => item.toUpperCase()).toList();
  print('Mapped into an uppercased List: $loudStack');

  // 4. Value-Based Deep Equality
  print('\n4. Deep Equality');
  var stackA = Stack<int>.from([1, 2, 3]);
  var stackB = Stack<int>.from([1, 2, 3]);
  var stackC = Stack<int>.from([1, 2, 99]);

  print('stackA == stackB ? ${stackA == stackB}'); // true
  print('stackA == stackC ? ${stackA == stackC}'); // false

  // 5. Native Search Utilities
  print('\n5. Search Utilities');
  print('Does stackA contain 2? ${stackA.contains(2)}'); // true
  print('Does stackA contain 100? ${stackA.contains(100)}'); // false
  print('Element at index 0 (the top): ${stackA.elementAt(0)}'); // 3
}
