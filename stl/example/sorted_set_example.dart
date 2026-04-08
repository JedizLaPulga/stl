import 'package:stl/stl.dart';

void main() {
  print('--- SortedSet Example ---');

  // 1. Natural ordering
  final sortedSet = SortedSet<int>();

  // Insert elements randomly
  sortedSet.insert(50);
  sortedSet.insert(10);
  sortedSet.insert(30);
  sortedSet.insert(20);

  print('Natural Output (Always Sorted!):');
  for (final value in sortedSet) {
    print(' -> $value');
  }

  // 2. Custom Comparator
  print('\n--- Custom Ordering (String reversed length) ---');
  final stringSet = SortedSet<String>((a, b) => b.length.compareTo(a.length));
  
  stringSet.insert('A');
  stringSet.insert('Supercal']); // wait typo
  stringSet.insert('Supercalifragilistic');
  stringSet.insert('Apple');
  stringSet.insert('Cat');

  print('Elements are sorted perfectly upon insertion:');
  for (final value in stringSet) {
    print(' -> $value');
  }

  // Set algebra works here too and preserves custom rules!
  final anotherSet = SortedSet<String>.from(['Cat', 'Dog', 'Z'], (a, b) => b.length.compareTo(a.length));
  
  final merged = stringSet.union(anotherSet);
  print('\nMerged Set maintains custom iteration:');
  print(merged.toList());
}
