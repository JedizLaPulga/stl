import 'package:stl/stl.dart';

void main() {
  final samples = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];

  print('--- StrideRange Example: Downsample sensor data ---');
  // Keep every 3rd reading — equivalent to std::views::stride(3).
  final downsampled = StrideRange(samples, 3).toList();
  print('Every 3rd sample: $downsampled'); // [0, 3, 6, 9]

  print('\n--- StrideRange Example: Pick odd-indexed elements ---');
  final letters = ['a', 'b', 'c', 'd', 'e', 'f'];
  final evenIndexed = StrideRange(letters, 2).toList();
  print('Even-indexed: $evenIndexed'); // [a, c, e]
}
