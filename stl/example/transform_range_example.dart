// ignore_for_file: unused_local_variable
import 'package:stl/stl.dart';

void main() {
  print('--- TransformRange Example ---');

  final numbers = [1, 2, 3, 4, 5];

  // Transform elements by squaring them
  final squared = TransformRange<int, int>(numbers, (int n) => n * n);

  print('Original: \$numbers');
  print('Squared: \${squared.toList()}');

  // Transform elements to string representation
  final stringified = TransformRange<int, String>(
    numbers,
    (int n) => 'Number \$n',
  );
  print('Stringified: \${stringified.toList()}');
}
