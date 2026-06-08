import 'package:stl/stl.dart';

void main() {
  print('--- ImmutableSet<T> Demonstration ---\n');

  // -----------------------------------------------------------------------
  // Construction
  // -----------------------------------------------------------------------
  final empty = ImmutableSet<int>.empty();
  print('empty:   $empty');
  print('isEmpty: ${empty.isEmpty}');

  final a = ImmutableSet.of({1, 2, 3, 4, 5});
  print('\nof({1..5}): $a');
  print('length: ${a.length}');
  print('first:  ${a.first}');
  print('last:   ${a.last}');

  // Duplicates are silently discarded
  final withDups = ImmutableSet.of([1, 2, 2, 3, 3, 3]);
  print('\nof([1,2,2,3,3,3]): $withDups');

  final gen = ImmutableSet.generate(5, (i) => i * 2);
  print('generate(5, i*2): $gen');

  // -----------------------------------------------------------------------
  // Persistent mutations — original unchanged
  // -----------------------------------------------------------------------
  final b = a.add(6);
  final c = a.remove(3);
  final d = a.addAll([10, 11]);
  final cleared = a.clear();
  print('\nadd(6):         $b');
  print('remove(3):      $c');
  print('addAll([10,11]):$d');
  print('clear():        $cleared');
  print('original unchanged: $a');

  // -----------------------------------------------------------------------
  // Membership
  // -----------------------------------------------------------------------
  print('\ncontains(3): ${a.contains(3)}');
  print('contains(9): ${a.contains(9)}');

  // -----------------------------------------------------------------------
  // Set algebra
  // -----------------------------------------------------------------------
  final x = ImmutableSet.of({1, 2, 3});
  final y = ImmutableSet.of({3, 4, 5});

  print('\nx = $x');
  print('y = $y');
  print('union:               ${x.union(y)}');
  print('intersection:        ${x.intersection(y)}');
  print('difference(x \\ y):  ${x.difference(y)}');
  print('symmetricDifference: ${x.symmetricDifference(y)}');

  // -----------------------------------------------------------------------
  // Subset / superset queries
  // -----------------------------------------------------------------------
  final sub = ImmutableSet.of({1, 2});
  print('\n{1,2}.isSubsetOf($x):   ${sub.isSubsetOf(x)}');
  print('$x.isSupersetOf({1,2}): ${x.isSupersetOf(sub)}');
  print('{1,2}.isDisjointFrom($y): ${sub.isDisjointFrom(y)}');

  // -----------------------------------------------------------------------
  // Functional transforms
  // -----------------------------------------------------------------------
  final doubled = x.map((e) => e * 10);
  print('\nmap(x*10): $doubled');

  final odds = a.where((e) => e.isOdd);
  print('where(isOdd): $odds');

  // -----------------------------------------------------------------------
  // Range pipeline compatibility
  // -----------------------------------------------------------------------
  final nums = ImmutableSet.of({5, 3, 1, 4, 2});
  final sumViaFold = nums.fold<int>(0, (acc, e) => acc + e);
  print('\nsum via fold: $sumViaFold');

  // -----------------------------------------------------------------------
  // Equality
  // -----------------------------------------------------------------------
  final p = ImmutableSet.of({1, 2, 3});
  final q = ImmutableSet.of({
    3,
    2,
    1,
  }); // Same elements, different insertion order
  print('\np == q (same elements): ${p == q}');
}
