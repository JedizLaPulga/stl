import 'package:stl/stl.dart';

void main() {
  final shapes = ['Circle', 'Square', 'Triangle'];
  final colors = ['Red', 'Green', 'Blue'];

  print('--- CartesianRange Example ---');
  // Generate all possible shape + color combinations!
  final combinations = CartesianRange(shapes, colors);

  for (final pair in combinations) {
    print('${pair.second} ${pair.first}');
  }

  print('\nCombinations created: ${combinations.length}');
}
