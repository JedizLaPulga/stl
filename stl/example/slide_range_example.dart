import 'package:stl/stl.dart';

void main() {
  final prices = [100.0, 102.5, 101.0, 105.0, 107.5, 106.0];

  print('--- SlideRange Example: 3-day moving average ---');
  // std::views::slide(3) — each window is 3 consecutive prices.
  final windows = SlideRange(prices, 3);
  for (final window in windows) {
    final avg = window.reduce((a, b) => a + b) / window.length;
    print('  Window $window  →  avg: ${avg.toStringAsFixed(2)}');
  }

  print('\n--- SlideRange Example: Detect consecutive duplicates ---');
  final data = [1, 1, 2, 3, 3, 3, 4];
  final pairs = SlideRange(data, 2).where((w) => w[0] == w[1]);
  print('Consecutive duplicate windows: ${pairs.toList()}');
}
