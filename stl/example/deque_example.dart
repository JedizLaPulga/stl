import 'package:stl/src/collections/deque.dart';

void main() {
  print('--- Deque<T> Showcase ---\n');

  // 1. Initialize an empty Deque
  print('[1] Creating an empty Deque of integers...');
  final deque = Deque<int>();
  print('Is empty? ${deque.isEmpty}'); // true
  print('Current length: ${deque.length}\n');

  // 2. Insert at the front and back
  print('[2] Inserting elements at both ends (Front and Last)...');
  deque.insertLast(10);  // [10]
  deque.insertFront(5);  // [5, 10]
  deque.insertLast(20);  // [5, 10, 20]
  deque.insertFront(1);  // [1, 5, 10, 20]
  print('Successfully inserted 1, 5, 10, 20.');
  print('Current length: ${deque.length}');
  print('Front element: ${deque.getFront()}'); // Should be 1
  print('Rear element: ${deque.getRear()}\n');   // Should be 20

  // 3. Delete from the front and back
  print('[3] Deleting elements from both ends...');
  final frontRemoved = deque.deleteFront();
  print('Removed from front: $frontRemoved'); // Should be 1

  final rearRemoved = deque.deleteLast();
  print('Removed from rear: $rearRemoved');   // Should be 20

  print('Current length: ${deque.length}');
  print('New Front element: ${deque.getFront()}'); // Should be 5
  print('New Rear element: ${deque.getRear()}\n');   // Should be 10

  // 4. Clearing the Deque
  print('[4] Clearing the Deque...');
  deque.clear();
  print('Is empty? ${deque.isEmpty}\n'); // true

  // 5. Creating a Deque from an existing Iterable
  print('[5] Creating a Deque from an existing Iterable (e.g., a List)...');
  final stringDeque = Deque<String>.from(['Apple', 'Banana', 'Cherry']);
  print('String Deque created with ${stringDeque.length} elements.');
  print('Front: ${stringDeque.getFront()}, Rear: ${stringDeque.getRear()}');
  
  stringDeque.insertFront('Mango');
  stringDeque.insertLast('Grapes');
  print('After inserting "Mango" at front and "Grapes" at rear:');
  print('Front: ${stringDeque.getFront()}, Rear: ${stringDeque.getRear()}\n');
  
  print('--- End of Showcase ---');
}
