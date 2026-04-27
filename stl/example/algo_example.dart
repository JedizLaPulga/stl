import 'package:stl/stl.dart';

/// Demonstrates the full power of the `<algorithm>` module working together
/// with the C++ STL-style collections provided by this library.
///
/// Each section mirrors a canonical C++ usage pattern, showing how algorithms
/// compose naturally with [Vector], [SortedSet], [SortedMap], [Deque],
/// [PriorityQueue], and other collections.
void main() {
  print('====================================================');
  print('    ⚡ ALGORITHM + COLLECTIONS SHOWCASE (v0.5.6)');
  print('====================================================\n');

  _sectionSearch();
  _sectionSorting();
  _sectionModifying();
  _sectionMinMax();
  _sectionHeap();
  _sectionPartition();
  _sectionSetOps();
  _sectionMerge();
  _sectionNonModifying();
  _sectionRandom();

  print('====================================================');
  print(' All algorithm examples completed successfully! ✓');
  print('====================================================\n');
}

// ============================================================
// 1. SEARCH — find, findIf, search, binarySearch, findEnd
// ============================================================
void _sectionSearch() {
  print('>>> 1. SEARCH <<<\n');

  // find on a Vector
  final scores = Vector<int>([42, 17, 99, 55, 17, 8]);
  final firstIdx = find(scores.toList(), 17);
  print('• find(17) in scores Vector: index $firstIdx');

  // findIf — first element > 50
  final highIdx = findIf(scores.toList(), (n) => n > 50);
  print(
    '• findIf(> 50) in scores:    index $highIdx → ${scores.toList()[highIdx]}',
  );

  // findIfNot — first element that is NOT > 50
  final lowIdx = findIfNot(scores.toList(), (n) => n > 50);
  print(
    '• findIfNot(> 50):           index $lowIdx → ${scores.toList()[lowIdx]}',
  );

  // adjacentFind — detect a run of duplicates
  final dupeIdx = adjacentFind(scores.toList());
  print('• adjacentFind (consecutive equal): index $dupeIdx');

  // search — find subsequence [99, 55]
  final subIdx = search(scores.toList(), [99, 55]);
  print('• search([99, 55]) in scores: index $subIdx');

  // findEnd — last occurrence of [17]
  final lastIdx = findEnd(scores.toList(), [17]);
  print('• findEnd([17]) in scores:   index $lastIdx');

  // binarySearch on a SortedSet (already sorted)
  final sortedNums = SortedSet<int>.from([5, 15, 25, 35, 45]);
  final found = binarySearch(sortedNums.toList(), 25);
  print('• binarySearch(25) in SortedSet{5,15,25,35,45}: $found');

  // findFirstOf — first element that appears in a target set
  final targets = [55, 99];
  final foIdx = findFirstOf(scores.toList(), targets);
  print(
    '• findFirstOf([55,99]) in scores: index $foIdx → ${scores.toList()[foIdx]}\n',
  );
}

// ============================================================
// 2. SORTING — stableSort, nthElement, partialSort, isSorted
// ============================================================
void _sectionSorting() {
  print('>>> 2. SORTING <<<\n');

  // stableSort preserves relative order of equal elements
  // Pair(value, originalIndex) lets us prove stability
  final tagged = [
    makePair(3, 0),
    makePair(1, 1),
    makePair(2, 2),
    makePair(1, 3),
    makePair(2, 4),
  ];
  stableSort(tagged, compare: (a, b) => a.first.compareTo(b.first));
  print('• stableSort by value (original indices preserved for ties):');
  for (final p in tagged) {
    print('    value=${p.first}  originalIndex=${p.second}');
  }

  // isSorted / isSortedUntil
  final nums = [1, 2, 5, 3, 4];
  print('• isSorted([1,2,5,3,4]):         ${isSorted(nums)}');
  print(
    '• isSortedUntil([1,2,5,3,4]):    ${isSortedUntil(nums)} (break at index 3)',
  );

  // nthElement — quickselect
  final data = [5, 3, 1, 4, 2];
  nthElement(data, 2);
  print('• nthElement(k=2) on [5,3,1,4,2]: data[2]=${data[2]} (3rd smallest)');

  // partialSort — first 3 are the 3 smallest in order
  final big = [9, 1, 7, 3, 5, 2, 8, 4, 6];
  partialSort(big, 3);
  print('• partialSort(3) on 9 elements:  first 3 = ${big.sublist(0, 3)}\n');
}

// ============================================================
// 3. MODIFYING — transform, fill, replace, remove, generate
// ============================================================
void _sectionModifying() {
  print('>>> 3. MODIFYING <<<\n');

  // transform — square every element
  final original = [1, 2, 3, 4, 5];
  final squared = transform(original, (n) => n * n);
  print('• transform(square) [1..5]: $squared');

  // transformBinary — element-wise product of two Vectors
  final a = Vector<int>([1, 2, 3]);
  final b = Vector<int>([10, 20, 30]);
  final products = transformBinary(a.toList(), b.toList(), (x, y) => x * y);
  print('• transformBinary(multiply) [1,2,3] × [10,20,30]: $products');

  // fill + generate
  final buf = List<int>.filled(5, 0);
  fill(buf, 7);
  print('• fill(7) on 5-element list: $buf');

  var counter = 0;
  generate(buf, () => counter += 3);
  print('• generate(×3) in-place:     $buf');

  // replace / replaceIf
  final words = ['apple', 'banana', 'apple', 'cherry'];
  replace(words, 'apple', 'mango');
  print('• replace("apple" → "mango"):    $words');

  final lengths = [1, 2, 3, 4, 5, 6];
  replaceIf(lengths, (n) => n % 2 == 0, 0);
  print('• replaceIf(even → 0):           $lengths');

  // remove / removeIf (in-place compaction)
  final evens = [1, 2, 3, 2, 4, 5, 2];
  final newLen = remove(evens, 2);
  print('• remove(2) from [1,2,3,2,4,5,2]: $evens (length=$newLen)');

  final odds = [1, 2, 3, 4, 5];
  final oddsLen = removeIf(odds, (n) => n % 2 != 0);
  print('• removeIf(odd):                 $odds (length=$oddsLen)');

  // copyIf — extract only uppercase strings from a Deque
  final dq = Deque<String>()
    ..pushBack('Alpha')
    ..pushBack('beta')
    ..pushBack('Gamma')
    ..pushBack('delta');
  final upper = copyIf(dq.toList(), (s) => s[0] == s[0].toUpperCase());
  print('• copyIf(uppercase) from Deque:  $upper');

  // swapRanges
  final x = [1, 2, 3];
  final y = [4, 5, 6];
  swapRanges(x, y);
  print('• swapRanges: x=$x, y=$y\n');
}

// ============================================================
// 4. MIN / MAX
// ============================================================
void _sectionMinMax() {
  print('>>> 4. MIN / MAX <<<\n');

  final values = [7, 2, 9, 1, 5, 8, 3];

  print('• minElement:    ${minElement(values)}');
  print('• maxElement:    ${maxElement(values)}');

  final pair = minMaxElement(values);
  print('• minMaxElement: min=${pair.first}, max=${pair.second}');

  // clampRange — hard-clamp a score vector to [0, 100]
  final rawScores = [-5, 0, 45, 105, 200, 100];
  clampRange(rawScores, 0, 100);
  print('• clampRange([0,100]): $rawScores\n');
}

// ============================================================
// 5. HEAP — makeHeap, pushHeap, popHeap, sortHeap
// ============================================================
void _sectionHeap() {
  print('>>> 5. HEAP OPERATIONS <<<\n');

  final heap = [3, 1, 4, 1, 5, 9, 2, 6];
  print('• Before makeHeap: $heap');
  makeHeap(heap);
  print('• After  makeHeap: $heap  (heap[0]=${heap[0]} is max)');
  print('• isHeap:          ${isHeap(heap)}');

  // Push a new maximum
  pushHeap(heap, 99);
  print('• After pushHeap(99): heap[0]=${heap[0]}');

  // Pop the maximum (moves it to the end)
  final lenAfterPop = popHeap(heap);
  print('• After popHeap: new heap size=$lenAfterPop, popped=${heap.last}');
  heap.removeLast(); // actually remove it

  // sortHeap — turns the heap back into a sorted list
  sortHeap(heap);
  print('• After sortHeap:  $heap');

  // Tie a PriorityQueue together: same data, same order guarantee
  final pq = PriorityQueue<int>();
  for (final v in [3, 1, 4, 1, 5, 9, 2, 6]) {
    pq.push(v);
  }
  final pqResult = <int>[];
  while (pq.isNotEmpty) {
    pqResult.add(pq.pop());
  }
  print('• PriorityQueue drain (same order): $pqResult\n');
}

// ============================================================
// 6. PARTITION — partition, stablePartition, isPartitioned,
//                partitionCopy, partitionPoint
// ============================================================
void _sectionPartition() {
  print('>>> 6. PARTITION <<<\n');

  final nums = [1, 2, 3, 4, 5, 6, 7, 8];

  // partition — evens first (order not guaranteed)
  final p1 = List<int>.of(nums);
  final splitIdx = partition(p1, (n) => n % 2 == 0);
  print('• partition(even first):    $p1 | split at $splitIdx');

  // stablePartition — evens first, relative order preserved
  final p2 = List<int>.of(nums);
  final stableIdx = stablePartition(p2, (n) => n % 2 == 0);
  print('• stablePartition(even):    $p2 | split at $stableIdx');

  // isPartitioned
  print('• isPartitioned(p2, even):  ${isPartitioned(p2, (n) => n % 2 == 0)}');

  // partitionCopy — non-destructive split
  final split = partitionCopy(nums, (n) => n > 4);
  print(
    '• partitionCopy(> 4):       evens=${split.first}  rest=${split.second}',
  );

  // partitionPoint — O(log N) search on already-partitioned range
  // p2 = [2, 4, 6, 8, 1, 3, 5, 7]
  final pp = partitionPoint(p2, (n) => n % 2 == 0);
  print('• partitionPoint on $p2:');
  print('  first odd at index $pp → ${p2[pp]}\n');
}

// ============================================================
// 7. SET OPERATIONS — setUnion, setIntersection, setDifference,
//                     setSymmetricDifference
// ============================================================
void _sectionSetOps() {
  print('>>> 7. SET OPERATIONS <<<\n');

  final s1 = SortedSet<int>.from([1, 2, 3, 4, 5]);
  final s2 = SortedSet<int>.from([3, 4, 5, 6, 7]);

  final a = s1.toList();
  final b = s2.toList();

  print('• SortedSet A: $a');
  print('• SortedSet B: $b');
  print('• union:        ${setUnion(a, b)}');
  print('• intersection: ${setIntersection(a, b)}');
  print('• difference (A \\ B): ${setDifference(a, b)}');
  print('• symmetric diff:     ${setSymmetricDifference(a, b)}');

  // isPermutation
  final x = [3, 1, 4, 1, 5, 9];
  final y = [9, 5, 1, 4, 1, 3];
  print(
    '\n• isPermutation([3,1,4,1,5,9], [9,5,1,4,1,3]): ${isPermutation(x, y)}',
  );

  // lexicographicalCompare
  final cmp = lexicographicalCompare([1, 2, 3], [1, 2, 4]);
  print(
    '• lexicographicalCompare([1,2,3], [1,2,4]): $cmp (< 0 means first is less)\n',
  );
}

// ============================================================
// 8. MERGE — merge, inplaceMerge
// ============================================================
void _sectionMerge() {
  print('>>> 8. MERGE <<<\n');

  // merge two sorted SortedSet-derived lists (preserves duplicates)
  final left = [1, 3, 3, 5, 7];
  final right = [2, 3, 4, 6, 8];
  final merged = merge(left, right);
  print('• merge($left, $right):');
  print('  → $merged');

  // inplaceMerge — glue two sorted halves together
  final combined = [1, 3, 5, 2, 4, 6];
  inplaceMerge(combined, 3);
  print('• inplaceMerge([1,3,5 | 2,4,6], mid=3): $combined\n');
}

// ============================================================
// 9. NON-MODIFYING — allOf, anyOf, noneOf, count, mismatch,
//                    equal, forEach, forEachN, searchN
// ============================================================
void _sectionNonModifying() {
  print('>>> 9. NON-MODIFYING QUERIES <<<\n');

  final primes = [2, 3, 5, 7, 11, 13];

  print('• allOf(> 1):    ${allOf(primes, (n) => n > 1)}');
  print('• anyOf(> 10):   ${anyOf(primes, (n) => n > 10)}');
  print(
    '• noneOf(even, except 2): ${noneOf(primes.skip(1).toList(), (n) => n % 2 == 0)}',
  );
  print('• count(3):      ${count(primes, 3)}');
  print('• countIf(>5):   ${countIf(primes, (n) => n > 5)}');

  // mismatch
  final v1 = [1, 2, 3, 4];
  final v2 = [1, 2, 9, 4];
  final mm = mismatch(v1, v2);
  print('• mismatch([1,2,3,4], [1,2,9,4]): first diff at index ${mm.first}');

  // equal
  print('• equal([1,2,3], [1,2,3]):   ${equal([1, 2, 3], [1, 2, 3])}');
  print('• equal([1,2,3], [1,2,4]):   ${equal([1, 2, 3], [1, 2, 4])}');

  // forEachN with a SortedMap — print first 3 entries
  final sm = SortedMap<String, int>()
    ..insert('alpha', 1)
    ..insert('beta', 2)
    ..insert('gamma', 3)
    ..insert('delta', 4);
  final keys = sm.map((p) => p.first).toList();
  print('• forEachN (first 3 SortedMap keys):');
  forEachN(keys, 3, (k) => print('    $k → ${sm[k]}'));

  // searchN — find 3 consecutive identical stock prices
  final prices = [100, 100, 102, 103, 103, 103, 104];
  final runIdx = searchN(prices, 3, 103);
  print('• searchN(3×103) in prices: starts at index $runIdx\n');
}

// ============================================================
// 10. RANDOM — shuffle, sample
// ============================================================
void _sectionRandom() {
  print('>>> 10. RANDOM (shuffle & sample) <<<\n');

  // shuffle a deck of cards (just suits here) using a seeded Random
  final deck = ['♠A', '♠K', '♠Q', '♠J', '♠10', '♥A', '♥K', '♥Q'];
  print('• deck before shuffle: $deck');
  shuffle(deck); // live shuffle
  print('• deck after  shuffle: $deck');

  // sample — pick 3 random cards
  final hand = sample(deck, 3);
  print('• sample(3 cards): $hand\n');
}
