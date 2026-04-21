// ignore_for_file: unused_local_variable
import 'package:stl/stl.dart';

void main() {
  print('--- FilterRange Example ---');

  final numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  // Filter only even numbers
  final evens = FilterRange(numbers, (int n) => n % 2 == 0);

  print('Original: \$numbers');
  print('Evens: \${evens.toList()}');

  // Filter numbers greater than 5
  final greaterThanFive = FilterRange(numbers, (int n) => n > 5);
  print('Greater than 5: \${greaterThanFive.toList()}');
}
