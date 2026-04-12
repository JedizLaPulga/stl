import 'package:stl/stl.dart';

void main() {
  print('--- Set Example ---');

  // Create a new Set
  final mySet = Set<String>();

  // Insert elements
  mySet.insert('Apple');
  mySet.insert('Banana');
  mySet.insert('Cherry');

  // Try inserting a duplicate
  final addedDuplicate = mySet.insert('Apple');
  print('Was duplicate Apple added? $addedDuplicate'); // false

  print('Set size: ${mySet.size}'); // 3

  // Erase an element
  mySet.erase('Banana');
  print('Contains Banana? ${mySet.contains('Banana')}'); // false

  // Iterating through Set
  print('\nIterating Set:');
  for (final item in mySet) {
    print(' -> $item');
  }

  // Powerful Set Operations (Union, Intersection, Difference)
  final primaryColors = Set<String>.from(['Red', 'Green', 'Blue']);
  final flagColors = Set<String>.from(['Red', 'White', 'Blue']);

  print('\n--- Mathematical Operations ---');
  print('Union: ${primaryColors.union(flagColors).toList()}');
  print('Intersection: ${primaryColors.intersection(flagColors).toList()}');
  print(
    'Difference (Primary - Flag): ${primaryColors.difference(flagColors).toList()}',
  );
}
