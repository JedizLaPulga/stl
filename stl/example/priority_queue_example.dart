import 'package:stl/stl.dart';

void main() {
  print('--- PriorityQueue Example ---');

  // 1. Default Max-Heap behavior
  final maxHeap = PriorityQueue<int>();
  maxHeap.push(15);
  maxHeap.push(5);
  maxHeap.push(20);
  maxHeap.push(10);

  print('Max-Heap Top Element: ${maxHeap.top}'); // 20

  print('Popping from Max-Heap:');
  while (maxHeap.isNotEmpty) {
    print(' -> ${maxHeap.pop()}'); // 20, 15, 10, 5
  }

  // 2. Custom Comparator for Min-Heap behavior
  print('\nMin-Heap behavior:');
  final minHeap = PriorityQueue<int>((a, b) => b.compareTo(a));

  minHeap.push(15);
  minHeap.push(5);
  minHeap.push(20);
  minHeap.push(10);

  print('Popping from Min-Heap:');
  while (minHeap.isNotEmpty) {
    print(' -> ${minHeap.pop()}'); // 5, 10, 15, 20
  }

  // 3. Complex objects based PriorityQueue
  print('\nComplex Objects Queue (Max String Length):');
  final words = PriorityQueue<String>((a, b) => a.length.compareTo(b.length));

  words.push('Dog');
  words.push('Elephant');
  words.push('Cat');
  words.push('Chimpanzee');

  print('Popping words by length:');
  while (words.isNotEmpty) {
    print(' -> ${words.pop()}');
  }
}
