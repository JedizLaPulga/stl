import 'package:stl/stl.dart';

void main() {
  print('--- NonEmptyList<T> Demonstration ---\n');

  // -----------------------------------------------------------------------
  // Construction
  // -----------------------------------------------------------------------
  final nel = NonEmptyList.of(1, [2, 3, 4, 5]);
  print('Created: $nel');
  print('head:   ${nel.head}');
  print('last:   ${nel.last}');
  print('length: ${nel.length}');

  // -----------------------------------------------------------------------
  // From iterable
  // -----------------------------------------------------------------------
  final fromIter = NonEmptyList.fromIterable(['apple', 'banana', 'cherry']);
  print('\nFrom iterable: $fromIter');

  // -----------------------------------------------------------------------
  // map / flatMap
  // -----------------------------------------------------------------------
  final doubled = nel.map((x) => x * 2);
  print('\nmap (×2): $doubled');

  final expanded = NonEmptyList.of(1, [
    2,
    3,
  ]).flatMap((x) => NonEmptyList.of(x, [x * 10]));
  print('flatMap (x, x*10): $expanded');

  // -----------------------------------------------------------------------
  // reduce / fold
  // -----------------------------------------------------------------------
  final sum = nel.reduce((a, b) => a + b);
  print('\nreduce (sum): $sum');

  final product = nel.fold(1, (acc, e) => acc * e);
  print('fold (product): $product');

  // -----------------------------------------------------------------------
  // Structural operations — immutable
  // -----------------------------------------------------------------------
  final prepended = nel.prepend(0);
  final appended = nel.append(6);
  print('\nprepend(0): $prepended');
  print('append(6):  $appended');
  print('original unchanged: $nel');

  // -----------------------------------------------------------------------
  // concat
  // -----------------------------------------------------------------------
  final a = NonEmptyList.of(1, [2, 3]);
  final b = NonEmptyList.of(4, [5, 6]);
  print('\nconcat: ${a.concat(b)}');

  // -----------------------------------------------------------------------
  // Error: constructing from empty iterable throws
  // -----------------------------------------------------------------------
  try {
    NonEmptyList.fromIterable([]);
  } on InvalidArgument catch (e) {
    print('\nExpected error: ${e.message}');
  }
}
