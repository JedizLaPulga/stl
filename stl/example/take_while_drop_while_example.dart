import 'package:stl/stl.dart';

void main() {
  // ---------------------------------------------------------------------------
  // 1. TakeWhileRange — basic: take while even
  // ---------------------------------------------------------------------------
  print('--- TakeWhileRange: take while even ---');
  final data = [2, 4, 6, 7, 8, 10];
  final evens = TakeWhileRange(data, (int n) => n.isEven);
  print(evens.toList()); // [2, 4, 6]

  // ---------------------------------------------------------------------------
  // 2. DropWhileRange — basic: skip leading evens
  // ---------------------------------------------------------------------------
  print('\n--- DropWhileRange: skip leading evens ---');
  final fromOdd = DropWhileRange(data, (int n) => n.isEven);
  print(fromOdd.toList()); // [7, 8, 10]
  // NOTE: 8 and 10 are even, but the skip phase already ended at 7

  // ---------------------------------------------------------------------------
  // 3. TakeWhileRange on an infinite IotaRange
  // ---------------------------------------------------------------------------
  print('\n--- TakeWhileRange on infinite IotaRange (n < 8) ---');
  final below8 = TakeWhileRange(IotaRange(0), (int n) => n < 8);
  print(below8.toList()); // [0, 1, 2, 3, 4, 5, 6, 7]

  // ---------------------------------------------------------------------------
  // 4. DropWhileRange — trim leading zeros from a sensor signal
  // ---------------------------------------------------------------------------
  print('\n--- DropWhileRange: trim leading zeros ---');
  final signal = [0, 0, 0, 3, 7, 2, 0, 5];
  final trimmed = DropWhileRange(signal, (int n) => n == 0);
  print(trimmed.toList()); // [3, 7, 2, 0, 5]

  // ---------------------------------------------------------------------------
  // 5. Compose TakeWhileRange + DropWhileRange — extract the inner non-zero span
  // ---------------------------------------------------------------------------
  print('\n--- Composition: extract inner non-zero span ---');
  final padded = [0, 0, 1, 3, 5, 0, 0];
  final inner = TakeWhileRange(
    DropWhileRange(padded, (int n) => n == 0),
    (int n) => n != 0,
  );
  print(inner.toList()); // [1, 3, 5]

  // ---------------------------------------------------------------------------
  // 6. TakeWhileRange vs FilterRange — spot the difference
  // ---------------------------------------------------------------------------
  print('\n--- TakeWhileRange vs FilterRange ---');
  final mixed = [2, 4, 7, 8, 10]; // 7 is odd, breaks the run
  // TakeWhileRange stops at 7 — never sees 8 or 10
  print(TakeWhileRange(mixed, (int n) => n.isEven).toList()); // [2, 4]
  // FilterRange skips 7 but continues — emits 8 and 10
  print(FilterRange(mixed, (int n) => n.isEven).toList()); // [2, 4, 8, 10]

  // ---------------------------------------------------------------------------
  // 7. DropWhileRange on strings — trim leading whitespace tokens
  // ---------------------------------------------------------------------------
  print('\n--- DropWhileRange: trim blank leading lines ---');
  final lines = ['', '', 'Dear Alice,', 'How are you?', ''];
  final body = DropWhileRange(lines, (String s) => s.isEmpty);
  print(body.toList()); // [Dear Alice,, How are you?, ]

  // ---------------------------------------------------------------------------
  // 8. Composing with TakeRange for a fixed-length window after a prefix
  // ---------------------------------------------------------------------------
  print('\n--- TakeRange(DropWhileRange(...)): first 3 non-zero values ---');
  final readings = [0, 0, 5, 3, 8, 1, 0, 4];
  final firstThree = TakeRange(DropWhileRange(readings, (int n) => n == 0), 3);
  print(firstThree.toList()); // [5, 3, 8]

  // ---------------------------------------------------------------------------
  // 9. Word prefix extraction with TakeWhileRange
  // ---------------------------------------------------------------------------
  print('\n--- TakeWhileRange: extract lowercase prefix words ---');
  final words = ['dart', 'flutter', 'GO', 'rust', 'java'];
  final lowercase = TakeWhileRange(words, (String w) => w == w.toLowerCase());
  print(lowercase.toList()); // [dart, flutter]
}
