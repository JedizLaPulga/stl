import 'package:stl/stl.dart';

void main() {
  print('──────────────────────────────────────────────');
  print('  Span<T>  —  std::span (C++20) for Dart');
  print('──────────────────────────────────────────────\n');

  // ── 1. Full-list span ────────────────────────────────────────────────────────
  print('1. Full-list span');
  final data = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100];
  final view = Span(data);

  print('   Source : $data');
  print('   Span   : $view');
  print('   length : ${view.length}');
  print('   first  : ${view.first}');
  print('   last   : ${view.last}');
  print('   [3]    : ${view[3]}\n');

  // ── 2. Named constructor Span.subspan ────────────────────────────────────────
  print('2. Span.subspan — direct window into a list');
  final window = Span.subspan(data, 2, 5); // [30, 40, 50, 60, 70]
  print('   Span.subspan(data, 2, 5) : $window\n');

  // ── 3. firstSpan / lastSpan ──────────────────────────────────────────────────
  print('3. firstSpan / lastSpan');
  print('   view.firstSpan(3) : ${view.firstSpan(3)}');
  print('   view.lastSpan(4)  : ${view.lastSpan(4)}\n');

  // ── 4. subspan (instance method) ─────────────────────────────────────────────
  print('4. subspan — relative offset within the span');
  print('   view.subspan(3, 4) : ${view.subspan(3, 4)}'); // [40, 50, 60, 70]
  print('   view.subspan(7)    : ${view.subspan(7)}\n'); // [80, 90, 100]

  // ── 5. Chained slicing ────────────────────────────────────────────────────────
  print('5. Chained slicing — all zero-copy');
  final chain = view
      .subspan(1) // [20 .. 100]
      .firstSpan(6) // [20, 30, 40, 50, 60, 70]
      .subspan(1, 4); // [30, 40, 50, 60]
  print('   view.subspan(1).firstSpan(6).subspan(1,4) : $chain\n');

  // ── 6. contains / indexOf ────────────────────────────────────────────────────
  print('6. Search');
  final mid = view.subspan(2, 5); // [30, 40, 50, 60, 70]
  print('   mid = $mid');
  print('   mid.contains(50) : ${mid.contains(50)}');
  print(
    '   mid.contains(10) : ${mid.contains(10)}  (10 is outside the window)',
  );
  print('   mid.indexOf(50)  : ${mid.indexOf(50)}');
  print('   mid.indexOf(99)  : ${mid.indexOf(99)}\n');

  // ── 7. Iterable integration ───────────────────────────────────────────────────
  print('7. Iterable integration');
  final nums = Span([1, 2, 3, 4, 5, 6, 7, 8]);
  final evens = nums.where((e) => e.isEven).toList();
  final doubled = nums.map((e) => e * 2).toList();
  final sum = nums.reduce((a, b) => a + b);
  print('   nums    : $nums');
  print('   evens   : $evens');
  print('   doubled : $doubled');
  print('   sum     : $sum\n');

  // ── 8. Zero-copy guarantee ────────────────────────────────────────────────────
  print(
    '8. Zero-copy guarantee — mutations to source are visible through span',
  );
  final src = [100, 200, 300, 400];
  final s = Span(src);
  print('   Before: $s');
  src[1] = 999;
  print('   After src[1] = 999: $s');
  print('   (no copy was made — span still points into src)\n');

  // ── 9. toList ────────────────────────────────────────────────────────────────
  print('9. toList — produces an independent copy');
  final span9 = Span([1, 2, 3, 4, 5]);
  final copy = span9.toList();
  copy[0] = 99;
  print('   Original span after mutating the copy: $span9');
  print('   Copy: $copy\n');

  // ── 10. Works with StringView-style text processing ──────────────────────────
  print('10. Span<String> for zero-copy string processing');
  final tokens = ['error', 'warning', 'info', 'debug', 'error', 'info'];
  final tokenSpan = Span(tokens);
  final errors = tokenSpan.where((t) => t == 'error').length;
  final slice = tokenSpan.subspan(1, 4); // ['warning', 'info', 'debug']
  print('    Tokens      : $tokenSpan');
  print('    Error count : $errors');
  print('    Middle 3    : $slice\n');

  print('All Span<T> examples complete.');
}
