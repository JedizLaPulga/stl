import 'package:stl/stl.dart';

void main() {
  final temperatures = [18.0, 21.0, 19.5, 23.0, 22.0];

  print('--- PairwiseRange Example: Daily temperature deltas ---');
  // std::views::pairwise — each pair is (today, tomorrow).
  for (final pair in PairwiseRange(temperatures)) {
    final delta = pair.second - pair.first;
    final direction = delta >= 0 ? '▲' : '▼';
    print(
      '  ${pair.first}°C → ${pair.second}°C  $direction ${delta.abs().toStringAsFixed(1)}°',
    );
  }

  print('\n--- PairwiseRange Example: Detect strictly increasing sequence ---');
  final values = [1, 3, 5, 4, 7];
  final isStrictlyIncreasing = PairwiseRange(
    values,
  ).every((p) => p.second > p.first);
  print('Strictly increasing: $isStrictlyIncreasing'); // false
}
