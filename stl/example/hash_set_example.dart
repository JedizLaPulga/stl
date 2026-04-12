import 'package:stl/stl.dart';

void main() {
  print('--- HashSet Example ---');

  // Create an unordered HashSet
  final hashSet = HashSet<String>();

  // Insert elements
  hashSet.insert('Dog');
  hashSet.insert('Cat');
  hashSet.insert('Elephant');
  hashSet.insert('Bird');

  print('HashSet size: ${hashSet.size}'); // 4

  // Notice that iteration order is NOT guaranteed
  // unlike the default Set which maintains insertion order.
  print('\nIterating HashSet (Order is arbitrary):');
  for (final animal in hashSet) {
    print(' -> $animal');
  }

  // Fast lookups
  print('\nContains "Bird"? ${hashSet.contains('Bird')}');
  print('Contains "Lion"? ${hashSet.contains('Lion')}');

  // Set operations are still supported
  final zooAnimals = HashSet<String>.from(['Elephant', 'Lion', 'Tiger']);

  final common = hashSet.intersection(zooAnimals);
  print('\nAnimals in both sets (Intersection): ${common.toList()}');
}
