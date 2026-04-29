import 'package:stl/stl.dart';

void main() {
  print('--- IotaRange Example: Bounded sequence ---');
  // std::views::iota(0, 6) — integers [0, 6)
  final bounded = IotaRange(0, 6);
  print(bounded.toList()); // [0, 1, 2, 3, 4, 5]

  print('\n--- IotaRange Example: Infinite sequence with take() ---');
  // Infinite starting at 5; consume only the first 4 values.
  final infinite = IotaRange(5).take(4);
  print(infinite.toList()); // [5, 6, 7, 8]

  print('\n--- IotaRange Example: Compose with FilterRange ---');
  // Even numbers in [0, 12)
  final evens = FilterRange(IotaRange(0, 12), (n) => n % 2 == 0);
  print(evens.toList()); // [0, 2, 4, 6, 8, 10]

  print('\n--- IotaRange Example: Compose with TransformRange ---');
  // Squares of [1, 6)
  final squares = TransformRange<int, int>(IotaRange(1, 6), (n) => n * n);
  print(squares.toList()); // [1, 4, 9, 16, 25]

  print('\n--- IotaRange Example: Use as index source ---');
  final items = ['apple', 'banana', 'cherry'];
  for (final i in IotaRange(0, items.length)) {
    print('  $i -> ${items[i]}');
  }
}
