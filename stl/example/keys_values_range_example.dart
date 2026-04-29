import 'package:stl/stl.dart';

void main() {
  // ---------- KeysRange ----------
  print('--- KeysRange Example: Extract keys from a Pair list ---');
  // std::views::keys — project first element of each Pair
  final pairs = [Pair('alpha', 1), Pair('beta', 2), Pair('gamma', 3)];
  print(KeysRange(pairs).toList()); // [alpha, beta, gamma]

  print('\n--- KeysRange Example: Keys of a SortedMap ---');
  final map = SortedMap<String, int>((a, b) => a.compareTo(b));
  map['cherry'] = 3;
  map['apple'] = 1;
  map['banana'] = 2;
  // SortedMap iteration yields Pair<K,V> in key order.
  print(KeysRange(map).toList()); // [apple, banana, cherry]

  print('\n--- KeysRange Example: Compose with FilterRange ---');
  // Keep only keys whose associated value is even.
  final evenKeys = FilterRange<String>(
    KeysRange(pairs),
    (k) => pairs.firstWhere((p) => p.first == k).second % 2 == 0,
  );
  print(evenKeys.toList()); // [beta]

  // ---------- ValuesRange ----------
  print('\n--- ValuesRange Example: Extract values from a Pair list ---');
  // std::views::values — project second element of each Pair
  print(ValuesRange(pairs).toList()); // [1, 2, 3]

  print('\n--- ValuesRange Example: Values of a SortedMap ---');
  print(ValuesRange(map).toList()); // [1, 2, 3]

  print('\n--- ValuesRange Example: Sum of all values ---');
  final total = ValuesRange(map).fold<int>(0, (sum, v) => sum + v);
  print('Total: $total'); // Total: 6

  // ---------- Keys + Values together ----------
  print('\n--- KeysRange + ValuesRange: Parallel projection ---');
  final keys = KeysRange(pairs).toList();
  final values = ValuesRange(pairs).toList();
  for (var i = 0; i < keys.length; i++) {
    print('  ${keys[i]} => ${values[i]}');
  }
}
