import 'package:stl/stl.dart';

void main() {
  print('--- Pair Feature Showcase ---');

  // 1. Basic C++ std::pair capabilities
  print('\n1. Pure std::pair capabilities');
  var user = makePair('Alice', 25);
  print('User Pair: $user');
  print('first: ${user.first}');
  print('second: ${user.second}');

  // 2. Dart 3 Record Interoperability
  print('\n2. Dart 3 Record Interoperability');
  var pair = makePair(10, 'Apples');
  var (quantity, item) = pair.record;
  print(
    'Destructured directly via .record -> Quantity: $quantity, Item: $item',
  );

  var fastPair = Pair<String, double>.fromRecord(('Price', 9.99));
  print('Created from Record: $fastPair');

  // 3. Map Interoperability
  print('\n3. Map Translations');
  var mapEntryPair = makePair('ServerPort', 8080);
  var entry = mapEntryPair.toMapEntry();
  print(
    'Translated to Dart MapEntry -> key: ${entry.key}, value: ${entry.value}',
  );

  // 4. Comparable Extension (Lexicographical logic)
  print('\n4. Lexicographical Comparable Extension');
  var pairA = makePair(1, 100);
  var pairB = makePair(2, 50);
  print('$pairB > $pairA ? ${pairB > pairA}'); // true because 2 > 1.

  // 5. Utility Converters
  print('\n5. Utility Converters');
  var clonePair = user.clone();
  print('Cloned pair successfully == user ? ${clonePair == user}');
  print('As standard List: ${user.toList()}');
}
