import 'package:stl/stl.dart';

void main() {
  print('--- SortedMap Example ---');
  final map = SortedMap<String, int>();
  map.insert('Banana', 2);
  map.insert('Apple', 5);
  map.insert('Cherry', 8);

  print('Map size: ${map.size}'); // 3
  
  // Notice how they are printed in alphabetically sorted order by key
  for (var pair in map) {
    print('${pair.first}: ${pair.second}');
  }
}
