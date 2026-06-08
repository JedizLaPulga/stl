import 'package:stl/stl.dart';

void main() {
  print('--- FlatSet<T> & FlatMap<K,V> Demonstration ---\n');

  // =======================================================================
  // FlatSet
  // =======================================================================
  print('=== FlatSet<int> ===\n');

  final s = FlatSet<int>();
  s.insert(3);
  s.insert(1);
  s.insert(4);
  s.insert(1); // duplicate — ignored
  s.insert(5);
  s.insert(2);
  print('after inserts: $s');
  print('length:        ${s.length}');
  print('first:         ${s.first}');
  print('last:          ${s.last}');

  // Construction from iterable
  final s2 = FlatSet.from([10, 5, 20, 5, 15]);
  print('\nFlatSet.from([10,5,20,5,15]): $s2');

  // Lookup
  print('\ncontains(4): ${s.contains(4)}');
  print('contains(9): ${s.contains(9)}');
  print('lowerBound(3): ${s.lowerBound(3)}  (index of first element >= 3)');
  print('upperBound(3): ${s.upperBound(3)}  (index of first element > 3)');

  // Mutation
  final removed = s.erase(4);
  print('\nerase(4) → $removed, set: $s');
  s.insert(4); // restore
  s.insert(6);
  print('after re-insert(4) and insert(6): $s');

  // Set algebra
  final sa = FlatSet.from([1, 2, 3, 4]);
  final sb = FlatSet.from([3, 4, 5, 6]);
  print('\nsa = $sa');
  print('sb = $sb');
  print('union:        ${sa.union(sb)}');
  print('intersection: ${sa.intersection(sb)}');
  print('difference:   ${sa.difference(sb)}');

  // Custom comparator — descending order
  final desc = FlatSet<int>((a, b) => b.compareTo(a));
  desc.insert(3);
  desc.insert(1);
  desc.insert(2);
  print('\nFlatSet (descending): $desc');

  // Iteration
  print('\niterating FlatSet.from([5,1,3]):');
  for (final e in FlatSet.from([5, 1, 3])) {
    print('  $e');
  }

  // =======================================================================
  // FlatMap
  // =======================================================================
  print('\n=== FlatMap<String, int> ===\n');

  final m = FlatMap<String, int>();
  m.insert('banana', 3);
  m.insert('apple', 1);
  m.insert('cherry', 5);
  m.insert('date', 2);
  m['elderberry'] = 4;
  print('after inserts: $m');
  print('length: ${m.length}');

  // Lookup
  print("\nm['apple']:  ${m['apple']}");
  print("m.at('cherry'): ${m.at('cherry')}");
  print("containsKey('date'): ${m.containsKey('date')}");
  print("containsKey('fig'):  ${m.containsKey('fig')}");

  // Update (insert with same key overwrites)
  m.insert('apple', 99);
  print("\nafter insert('apple', 99): $m");

  // Binary search on keys
  print('\nlowerBound("c"): ${m.lowerBound('c')}  (index of first key >= "c")');
  print('upperBound("c"): ${m.upperBound('c')}  (index of first key > "c")');

  // Erase
  final erased = m.erase('date');
  print('\nerase("date") → $erased, map: $m');

  // Keys and values
  print('\nkeys:   ${m.keys.toList()}');
  print('values: ${m.values.toList()}');

  // Iteration over FlatMapEntry
  print('\niterating FlatMap:');
  for (final entry in m) {
    print('  ${entry.key} → ${entry.value}');
  }

  // Construction from Dart Map
  final fromMap = FlatMap.from({'z': 3, 'a': 1, 'm': 2});
  print('\nFlatMap.from({z:3, a:1, m:2}): $fromMap');

  // Custom comparator — reverse alphabetical
  final rev = FlatMap<String, int>((a, b) => b.compareTo(a));
  rev['a'] = 1;
  rev['z'] = 2;
  rev['m'] = 3;
  print('\nFlatMap (reverse alpha): $rev');
}
