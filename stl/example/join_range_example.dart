import 'package:stl/stl.dart';

void main() {
  print('--- JoinRange Example ---');
  
  final nestedNumbers = [
    [1, 2, 3],
    [4, 5],
    [],
    [6, 7, 8, 9]
  ];
  
  // Flatten the nested list
  final joined = JoinRange(nestedNumbers);
  
  print('Original: \$nestedNumbers');
  print('Joined: \${joined.toList()}');
}
