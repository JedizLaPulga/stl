import 'package:stl/stl.dart';

void main() {
  print('========================================');
  print('    📦 STL Vector & Deque - Showcase');
  print('========================================\n');

  // ========================================
  //              VECTOR SHOWCASE
  // ========================================

  // 1. Initialization (const and final)
  print('--- 1. Initialization & toString() ---');
  const v1 = Vector<int>([1, 2, 3]);
  final v2 = Vector<int>([1, 2, 3]);
  final v3 = Vector<int>([1, 2, 100]);

  print('v1 (const): $v1');
  print('v2 (final): $v2');
  print('v3 (final): $v3\n');

  // 2. Deep Equality
  print('--- 2. Deep Equality (operator ==) ---');
  print('Is v1 == v2? ${v1 == v2}  <-- True value-based equality!');
  print('Is v1 == v3? ${v1 == v3}\n');

  // 3. Lexicographical Comparison
  print('--- 3. Lexicographical Comparison ---');
  if (v3 > v1) {
    print('$v3 is strictly greater than $v1');
  }
  print('Is v1 <= v2? ${v1 <= v2}\n');

  // 4. Modifiers (pushBack, popBack, insert, clear)
  print('--- 4. Modifiers ---');
  final dynamicVec = Vector<String>(['Apple', 'Banana']);
  print('Initial Vector: $dynamicVec');

  dynamicVec.pushBack('Cherry');
  print('After pushBack: $dynamicVec');

  dynamicVec.insert(1, 'Blueberry');
  print('After insert at index 1: $dynamicVec');

  dynamicVec.popBack();
  print('After popBack: $dynamicVec\n');

  // 5. Memory Safety & Bounds Checking
  print('--- 5. Memory Safety & Strict Bounds ---');
  try {
    print('Attempting to access dynamicVec[100]...');
    final _ = dynamicVec[100]; // This will throw!
  } catch (e) {
    print('Caught expected memory safety guard: $e\n');
  }

  // 6. Iterable Support
  print('--- 6. Dart Iterable Support ---');
  final numbers = Vector<int>([10, 15, 20, 25, 30]);
  print('Iterating through $numbers in a for-in loop:');
  for (final n in numbers) {
    print(' -> $n');
  }

  // 7. Concatenation
  print('--- 7. Concatenation ---');
  final v4 = Vector<int>([1, 2, 3]);
  final v5 = Vector<int>([4, 5, 6]);
  final v6 = v4 + v5;
  print('v4: $v4');
  print('v5: $v5');
  print('v4 + v5: $v6\n');

  // 8. Multiplication
  print('--- 8. Multiplication ---');
  final v7 = Vector<int>([1, 2, 3]);
  final v8 = v7 * 3;
  print('v7: $v7');
  print('v7 * 3: $v8\n');

  // 9. Subtraction
  print('--- 9. Subtraction ---');
  final v9 = Vector<int>([1, 2, 3]);
  final v10 = Vector<int>([1, 2, 3]);
  final v11 = v9 - v10;
  print('v9: $v9');
  print('v10: $v10');
  print('v9 - v10: $v11\n');

  // 10. ~ operator
  print('--- 10. ~ operator ---');
  final v12 = Vector<int>([1, 2, 3]);
  final v13 = ~v12;
  print('v12: $v12');
  print('~v12: $v13\n');

  // ========================================
  //              DEQUE SHOWCASE
  // ========================================
  print('========================================');
  print('              DEQUE SHOWCASE');
  print('========================================\n');

  // Initialization
  print('--- 11. Deque Initialization ---');
  final deque = Deque<int>();
  print('Created empty Deque. Is empty? ${deque.isEmpty}');

  // Modifiers
  print('\n--- 12. Deque Modifiers (insertFront / insertLast) ---');
  deque.insertLast(10);
  deque.insertFront(5);
  deque.insertLast(20);
  deque.insertFront(1);
  print('Inserted 1, 5, 10, 20.');
  print('Front element: ${deque.getFront()}');
  print('Rear element: ${deque.getRear()}');

  // Deletion
  print('\n--- 13. Deque Deletion (deleteFront / deleteLast) ---');
  print('Removed from front: ${deque.deleteFront()}');
  print('Removed from rear: ${deque.deleteLast()}');
  print('New Front element: ${deque.getFront()}');
  print('New Rear element: ${deque.getRear()}');

  // From Iterable
  print('\n--- 14. Deque from Iterable ---');
  final stringDeque = Deque<String>.from(['Apple', 'Banana', 'Cherry']);
  print('Front: ${stringDeque.getFront()}, Rear: ${stringDeque.getRear()}');

  print('\n========================================');
  print('  🎉 Showcase Complete!');
  print('========================================\n');
}
