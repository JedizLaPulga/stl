import 'package:stl/stl.dart';

void main() {
  print('--- CycleRange Example: Round-robin task assignment ---');
  // Assign tasks to workers in a round-robin fashion using a finite cycle.
  final workers = ['Alice', 'Bob', 'Charlie'];
  final tasks = ['T1', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'];

  // Cycle workers enough times to cover all tasks, then zip.
  final assignments = ZipRange(
    tasks,
    TakeRange(CycleRange(workers), tasks.length),
  );
  for (final pair in assignments) {
    print('  ${pair.first} → ${pair.second}');
  }

  print('\n--- CycleRange Example: Repeating colour palette ---');
  final colours = ['red', 'green', 'blue'];
  // Two full cycles of the palette.
  final palette = CycleRange(colours, 2).toList();
  print(palette); // [red, green, blue, red, green, blue]

  print('\n--- CycleRange Example: Infinite sequence via TakeRange ---');
  final first10 = TakeRange(CycleRange([0, 1]), 10).toList();
  print('First 10 bits: $first10'); // [0, 1, 0, 1, 0, 1, 0, 1, 0, 1]
}
