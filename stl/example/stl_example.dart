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
  print('• Functional Plus operator (5 + 10): ${invoke(mathOp.call, positional: [5, 10])}\n');


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


  print('====================================================');
  print(' 🌟 Click example/ for more examples on GitHub! 🌟');
  print('====================================================\n');
}
