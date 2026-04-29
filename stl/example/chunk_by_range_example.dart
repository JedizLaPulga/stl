import 'package:stl/stl.dart';

void main() {
  print('--- ChunkByRange Example: Group equal consecutive elements ---');
  // std::views::chunk_by — group runs of identical integers
  final runs = ChunkByRange([1, 1, 2, 2, 2, 3, 1, 1], (a, b) => a == b);
  print(runs.toList()); // [[1, 1], [2, 2, 2], [3], [1, 1]]

  print('\n--- ChunkByRange Example: Group ascending runs ---');
  // New chunk whenever the next element is smaller than the previous.
  final ascending = ChunkByRange([1, 2, 3, 1, 2, 5, 3], (a, b) => b >= a);
  print(ascending.toList()); // [[1, 2, 3], [1, 2, 5], [3]]

  print('\n--- ChunkByRange Example: Group words by first letter ---');
  final words = ['ant', 'ape', 'bee', 'bat', 'cat', 'crow'];
  final byLetter = ChunkByRange(
    words,
    (a, b) => a[0] == b[0],
  ).map((group) => group.join(', ')).toList();
  print(byLetter); // [ant, ape], [bee, bat], [cat, crow]

  print('\n--- ChunkByRange Example: RLE encode ---');
  final signal = [0, 0, 1, 1, 1, 0, 1];
  final rle = ChunkByRange(
    signal,
    (a, b) => a == b,
  ).map((group) => '${group.length}x${group.first}').toList();
  print(rle); // [2x0, 3x1, 1x0, 1x1]
}
