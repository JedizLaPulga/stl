import 'package:stl/stl.dart';

void main() {
  print('--- TakeRange Example ---');
  
  final numbers = [10, 20, 30, 40, 50, 60, 70];
  
  // Take the first 3 elements
  final taken = TakeRange(numbers, 3);
  
  print('Original: \$numbers');
  print('Taken 3: \${taken.toList()}');
  
  // Taking more than available just takes all
  final overflow = TakeRange(numbers, 100);
  print('Taken 100: \${overflow.toList()}');
}
