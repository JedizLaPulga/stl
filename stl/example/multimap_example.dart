import 'package:stl/stl.dart';

void main() {
  print('--- MultiMap Example ---');
  final map = MultiMap<String, int>();
  map.insert('Fruit', 5);
  map.insert('Vegetable', 3);
  map.insert('Fruit', 8); // Duplicate key!

  print('Map size: ${map.size}'); // 3

  print('Fruits count: ${map.count('Fruit')}'); // 2
  
  for (var value in map.equalRange('Fruit')) {
    print('Fruit value: $value');
  }
}
