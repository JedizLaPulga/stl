import 'package:stl/stl.dart';

void main() {
  print('--- ImmutableList<T> Demonstration ---\n');

  // -----------------------------------------------------------------------
  // Construction
  // -----------------------------------------------------------------------
  final empty = ImmutableList<int>.empty();
  print('empty:   $empty');
  print('length:  ${empty.length}');
  print('isEmpty: ${empty.isEmpty}');

  final a = ImmutableList.of([1, 2, 3, 4, 5]);
  print('\nof([1..5]): $a');
  print('first: ${a.first}');
  print('last:  ${a.last}');
  print('a[2]:  ${a[2]}');

  final filled = ImmutableList.filled(4, 0);
  print('\nfilled(4, 0): $filled');

  final squares = ImmutableList.generate(6, (i) => i * i);
  print('generate squares: $squares');

  // -----------------------------------------------------------------------
  // Persistent mutations — original unchanged
  // -----------------------------------------------------------------------
  final b = a.add(6);
  final c = a.removeAt(0);
  final d = a.set(2, 99);
  final e = a.insert(2, 42);
  print('\nadd(6):         $b');
  print('removeAt(0):    $c');
  print('set(2, 99):     $d');
  print('insert(2, 42):  $e');
  print('original unchanged: $a');

  // -----------------------------------------------------------------------
  // Functional transforms
  // -----------------------------------------------------------------------
  final doubled = a.map((x) => x * 2);
  final evens = a.where((x) => x.isEven);
  final flat = ImmutableList.of([1, 2, 3]).expand((x) => [x, x * 10]);
  print('\nmap(×2):       $doubled');
  print('where(even):   $evens');
  print('expand:        $flat');

  // -----------------------------------------------------------------------
  // Slicing
  // -----------------------------------------------------------------------
  final taken = a.take(3);
  final dropped = a.drop(2);
  final sub = a.sublist(1, 4);
  print('\ntake(3):       $taken');
  print('drop(2):       $dropped');
  print('sublist(1,4):  $sub');

  // -----------------------------------------------------------------------
  // sorted / reversed
  // -----------------------------------------------------------------------
  final unsorted = ImmutableList.of([5, 2, 8, 1, 9, 3]);
  print('\nunsorted:   $unsorted');
  print('sorted:     ${unsorted.sorted()}');
  print('reversed:   ${unsorted.reversed()}');
  print('sorted desc: ${unsorted.sorted((a, b) => b.compareTo(a))}');

  // -----------------------------------------------------------------------
  // concat / addAll
  // -----------------------------------------------------------------------
  final f = ImmutableList.of([1, 2]).concat(ImmutableList.of([3, 4]));
  print('\nconcat: $f');

  // -----------------------------------------------------------------------
  // Queries
  // -----------------------------------------------------------------------
  print('\ncontains(3): ${a.contains(3)}');
  print('indexOf(3):  ${a.indexOf(3)}');

  // -----------------------------------------------------------------------
  // Equality
  // -----------------------------------------------------------------------
  final copy = ImmutableList.of([1, 2, 3, 4, 5]);
  print('\na == copy: ${a == copy}');
  print('a == b:    ${a == b}');

  // -----------------------------------------------------------------------
  // Range pipeline interop
  // -----------------------------------------------------------------------
  final filtered = FilterRange(a, (x) => x > 2).map((x) => x * 3).toList();
  print('\nFilterRange > 2, × 3: $filtered');
}
