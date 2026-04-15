import 'package:stl/stl.dart';

void main() {
  print('--- C++ <numeric> Algorithms Example ---\n');

  // 1. accumulate
  final numbers = [1, 2, 3, 4, 5];
  final sum = numbers.accumulate(0);
  print('accumulate(0): $numbers -> $sum');
  
  // Custom operation (product)
  final product = numbers.accumulate(1, (a, b) => a * b);
  print('accumulate(1, product): $numbers -> $product\n');

  // 2. innerProduct
  final vector1 = [1, 2, 3];
  final vector2 = [4, 5, 6];
  final dotProduct = vector1.innerProduct(vector2, 0);
  print('innerProduct: $vector1 . $vector2 -> $dotProduct\n');

  // 3. adjacentDifference
  final bounds = [1, 3, 6, 10];
  final diffs = bounds.adjacentDifference();
  print('adjacentDifference: $bounds -> $diffs\n');

  // 4. partialSum
  final sequence = [1, 2, 3, 4];
  final pSums = sequence.partialSum();
  print('partialSum: $sequence -> $pSums\n');

  // 5. iota
  final emptyList = List<int>.filled(5, 0);
  emptyList.iota(10);
  print('iota(10): [0, 0, 0, 0, 0] -> $emptyList');
}
