import 'package:stl/stl.dart';

void main() {
  print('====================================================');
  print('    💎 STL SHOWCASE & ARCHITECTURE');
  print('====================================================\n');

  // ========================================
  // 1. COLLECTIONS (2 Examples)
  // ========================================
  print('>>> 1. COLLECTIONS <<<\n');

  // Example 1: Vector (Dynamic Contiguous Array)
  final vec = Vector<String>(['Alpha', 'Bravo', 'Charlie']);
  vec.pushBack('Delta');
  print('• Vector: $vec (Size: ${vec.size()})');

  // Example 2: SortedMap (Auto-balancing associative container)
  final sortedMap = SortedMap<int, String>();
  sortedMap.insert(3, 'Charlie');
  sortedMap.insert(1, 'Alpha');
  sortedMap.insert(2, 'Bravo');
  print('• SortedMap (Auto-sorted keys): $sortedMap\n');

  // ========================================
  // 2. RANGES (2 Examples)
  // ========================================
  print('>>> 2. C++23 FUNCTIONAL RANGES <<<\n');

  // Example 1: NumberLine (Iota / sequence generator)
  final evens = NumberLine(0, 10, step: 2);
  print('• NumberLine (Evens 0 to 10): ${evens.toList()}');

  // Example 2: ZipRange (Parallel Iteration)
  final keys = ['ID', 'Status'];
  final values = [99, 'Active'];
  final zipped = ZipRange(keys, values);
  print('• ZipRange merged outputs: ${zipped.toList()}\n');

  // ========================================
  // 3. UTILITIES (2 Examples)
  // ========================================
  print('>>> 3. UTILITIES <<<\n');

  // Example 1: Pair (Heterogeneous Tuple)
  final task = makePair('Critical Bug', 1);
  print('• Pair: ${task.first} (Priority: ${task.second})');

  // Example 2: Optional (Safe null abstraction)
  final opt = Optional<String>.of('Success');
  print('• Optional value: ${opt.valueOr('Fallback')}\n');

  // ========================================
  // 4. MATH (4 Examples)
  // ========================================
  print('>>> 4. MATHEMATICS <<<\n');

  // Example 1: cmath clamp
  print('• clamp(-5, 0, 10): ${clamp(-5, 0, 10)}');

  // Example 2: cmath hypot
  print('• hypot(3, 4): ${hypot(3, 4)}');

  // Example 3: number_theory gcd
  print('• gcd(48, 18): ${gcd(48, 18)}');

  // Example 4: Complex numbers
  final c1 = Complex(1, 2);
  final c2 = Complex(3, 4);
  print('• Complex Addition (1+2i) + (3+4i): ${c1 + c2}\n');

  // ========================================
  // 5. GEOMETRY (2 Examples)
  // ========================================
  print('>>> 5. GEOMETRY <<<\n');

  // Example 1: Point
  final pt1 = Point(x: 0, y: 0);
  final pt2 = Point(x: 10, y: 10);
  print('• Point Distance: ${pt1.distanceTo(pt2)}');

  // Example 2: Rectangle (Shape Area)
  final rect = Rectangle(center: pt1, width: 5, height: 4);
  print('• Rectangle Area: ${rect.area}\n');

  // ========================================
  // 6. FUNCTIONAL (1 Example)
  // ========================================
  print('>>> 6. FUNCTIONAL <<<\n');

  // Example 1: invoke and function objects
  final mathOp = Plus<int>();
  print(
    '• Functional Plus operator (5 + 10): ${invoke(mathOp.call, positional: [5, 10])}\n',
  );

  // ========================================
  // 7. RANDOM (New Feature)
  // ========================================
  print('>>> 7. RANDOM <<<\n');

  // Custom Seeded Random Generator
  final rand = StdRandom(42);
  print('• StdRandom Seeded Next(): ${rand.next()}');

  // Bounded Range
  print('• StdRandom Bounded Range (10-50): ${rand.range(10, 50)}');

  // Flush (Discard next 5 states)
  rand.flush(5);
  print('• StdRandom after flushing 5 states: ${rand.next()}\n');

  // ========================================
  // 8. ITERATOR, CHRONO, & RATIO (v0.5.3)
  // ========================================
  print('>>> 8. ITERATOR, CHRONO & RATIO <<<\n');

  // Chrono
  final start = SteadyClock.now();
  final delay = 10.milliseconds;
  final futureTime = start + delay;
  print('• Chrono: 10 milliseconds from now is $futureTime');

  // Ratio
  final half = Ratio(1, 2);
  final quarter = Ratio(1, 4);
  print('• Ratio: $half + $quarter = ${half + quarter}');
  print('• Ratio Micro Prefix: ${Ratio.micro}');

  // Iterator
  final list = [1, 2, 3];
  final reverseIt = ReverseIterator(list);
  print('• ReverseIterator: ${reverseIt.toList()}');

  final vec2 = Vector<int>([]);
  final inserter = BackInsertIterator(vec2);
  inserter.add(99);
  inserter.add(100);
  print('• BackInsertIterator (Vector): $vec2\n');

  print('====================================================');
  print(' 🌟 Click example/ for more examples on GitHub! 🌟');
  print('====================================================\n');

  // ========================================
  // 9. ALGORITHMS (v0.5.6)
  // ========================================
  print('>>> 9. ALGORITHMS (v0.5.6) <<<\n');

  // --- Non-modifying queries ---
  final scores = [88, 42, 99, 55, 72, 61];
  print('• allOf  (>= 40):  ${allOf(scores, (n) => n >= 40)}');
  print('• anyOf  (>= 90):  ${anyOf(scores, (n) => n >= 90)}');
  print('• countIf(>= 70):  ${countIf(scores, (n) => n >= 70)}');
  print('• maxElement:      ${maxElement(scores)}');
  print('• minElement:      ${minElement(scores)}');

  // --- Sorting ---
  final words = ['banana', 'apple', 'cherry', 'date', 'apple'];
  stableSort(words);
  print('• stableSort words: $words');

  // --- partialSort — top-3 scores ---
  final topScores = List<int>.of(scores);
  partialSort(topScores, 3, compare: (a, b) => b.compareTo(a)); // descending
  print('• partialSort top-3 scores: ${topScores.sublist(0, 3)}');

  // --- transform + Vector ---
  final vec3 = Vector<int>([1, 2, 3, 4, 5]);
  final doubled = transform(vec3.toList(), (n) => n * 2);
  print('• transform(double) Vector: $doubled');

  // --- partition on a list of tasks ---
  final tasks = ['bug:login', 'feat:UI', 'bug:crash', 'feat:api', 'bug:perf'];
  final bugFirst = List<String>.of(tasks);
  stablePartition(bugFirst, (t) => t.startsWith('bug'));
  print('• stablePartition(bugs first): $bugFirst');

  // --- Set operations with SortedSet ---
  final setA = SortedSet<int>.from([1, 2, 3, 4, 5]);
  final setB = SortedSet<int>.from([3, 4, 5, 6, 7]);
  print(
    '• setIntersection A∩B: ${setIntersection(setA.toList(), setB.toList())}',
  );
  print(
    '• setSymmetricDifference A△B: ${setSymmetricDifference(setA.toList(), setB.toList())}',
  );

  // --- Heap ---
  final heap = [3, 1, 4, 1, 5, 9];
  makeHeap(heap);
  print('• makeHeap:  heap[0]=${heap[0]} (max)');
  pushHeap(heap, 42);
  print('• pushHeap(42): heap[0]=${heap[0]}');

  // --- merge two sorted ranges ---
  final merged = merge([1, 3, 5], [2, 4, 6]);
  print('• merge([1,3,5], [2,4,6]): $merged');

  print('');
  print('====================================================');
  print(' 🌟 Click example/ for more examples on GitHub! 🌟');
  print('====================================================\n');
}
