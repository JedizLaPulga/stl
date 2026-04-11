import 'package:stl/stl.dart';

void main() {
  print('--- DropRange Example ---');
  
  final numbers = [10, 20, 30, 40, 50, 60, 70];
  
  // Drop the first 4 elements
  final dropped = DropRange(numbers, 4);
  
  print('Original: \$numbers');
  print('Dropped 4: \${dropped.toList()}');
  
  // Dropping more than available leaves an empty iterable
  final overflow = DropRange(numbers, 100);
  print('Dropped 100: \${overflow.toList()}');
}
