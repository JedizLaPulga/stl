import 'package:stl/stl.dart';

void main() {
  print('--- Queue Example ---');

  // Create an empty Queue
  final queue = Queue<String>();

  // Push elements into the queue
  queue.push('First');
  queue.push('Second');
  queue.push('Third');

  print('Queue elements: ${queue.toList()}');
  print('Queue size: ${queue.size}');

  // Access front and back elements
  print('Front element: ${queue.front}');
  print('Back element: ${queue.back}');

  // Pop an element (First)
  final poppedElement = queue.pop();
  print('Popped element: $poppedElement');

  // Queue state after popping
  print('Queue after pop: ${queue.toList()}');
  print('New Front element: ${queue.front}');

  // Clear the queue
  queue.clear();
  print('Queue is empty: ${queue.empty}');

  // Construct from an iterable
  final newQueue = Queue<int>.from([10, 20, 30, 40]);
  print('\nNew Queue: ${newQueue.toList()}');

  // Iterating through a queue (FIFO order)
  print('Iterating through the queue:');
  for (final element in newQueue) {
    print(' -> $element');
  }
}
