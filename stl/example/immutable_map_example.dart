import 'package:stl/stl.dart';

void main() {
  print('--- ImmutableMap<K, V> Demonstration ---\n');

  // -----------------------------------------------------------------------
  // Construction
  // -----------------------------------------------------------------------
  final empty = ImmutableMap<String, int>.empty();
  print('empty:   $empty');
  print('isEmpty: ${empty.isEmpty}');

  final a = ImmutableMap.of({'x': 1, 'y': 2, 'z': 3});
  print('\nof({x:1, y:2, z:3}): $a');
  print('length: ${a.length}');
  print('a["x"]: ${a['x']}');

  final fromPairs = ImmutableMap.fromPairs([
    Pair('alpha', 10),
    Pair('beta', 20),
    Pair('gamma', 30),
  ]);
  print('\nfromPairs: $fromPairs');

  // -----------------------------------------------------------------------
  // Persistent mutations — original unchanged
  // -----------------------------------------------------------------------
  final b = a.put('w', 4);
  final c = a.remove('x');
  final d = a.update('y', (v) => v * 100);
  final e = a.updateOrInsert('q', (v) => v + 1, () => 99);
  print('\nput("w", 4):                 $b');
  print('remove("x"):                 $c');
  print('update("y", ×100):           $d');
  print('updateOrInsert("q", …, 99):  $e');
  print('original unchanged: $a');

  // -----------------------------------------------------------------------
  // Functional transforms
  // -----------------------------------------------------------------------
  final doubled = a.mapValues((v) => v * 2);
  final positiveKeys = a.whereKey((k) => k != 'z');
  final bigValues = a.whereValue((v) => v >= 2);
  print('\nmapValues(×2):        $doubled');
  print('whereKey(!= "z"):     $positiveKeys');
  print('whereValue(>= 2):     $bigValues');

  // -----------------------------------------------------------------------
  // merge
  // -----------------------------------------------------------------------
  final m1 = ImmutableMap.of({'a': 1, 'b': 2});
  final m2 = ImmutableMap.of({'b': 10, 'c': 3});
  final merged = m1.merge(m2);
  final sumMerged = m1.merge(m2, resolve: (v1, v2) => v1 + v2);
  print('\nmerge (m2 wins):     $merged');
  print('merge (sum):         $sumMerged');

  // -----------------------------------------------------------------------
  // Iteration as Pairs
  // -----------------------------------------------------------------------
  print('\nIterate as Pair<K,V>:');
  for (final p in a) {
    print('  ${p.first} => ${p.second}');
  }

  // -----------------------------------------------------------------------
  // Equality
  // -----------------------------------------------------------------------
  final copy = ImmutableMap.of({'x': 1, 'y': 2, 'z': 3});
  print('\na == copy: ${a == copy}');
  print('a == b:    ${a == b}');

  // -----------------------------------------------------------------------
  // putAll / toMap
  // -----------------------------------------------------------------------
  final extended = a.putAll({'p': 100, 'q': 200});
  print('\nputAll: $extended');
  final mutable = a.toMap();
  mutable['new'] = 42;
  print('toMap (mutable copy): $mutable');
  print('original unchanged: $a');
}
