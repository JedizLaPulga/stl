import 'package:stl/stl.dart';

void main() {
  print('--- FingerTree<T> Demonstration ---\n');

  // -----------------------------------------------------------------------
  // Construction
  // -----------------------------------------------------------------------
  var ft = FingerTree<int>.fromIterable([1, 2, 3, 4, 5]);
  print('fromIterable([1..5]): ${ft.toList()}');
  print('length: ${ft.length}');
  print('first:  ${ft.first}');
  print('last:   ${ft.last}');

  // -----------------------------------------------------------------------
  // prepend / append — immutable
  // -----------------------------------------------------------------------
  final prepended = ft.prepend(0);
  final appended = ft.append(6);
  print('\nprepend(0): ${prepended.toList()}');
  print('append(6):  ${appended.toList()}');
  print('original unchanged: ${ft.toList()}');

  // -----------------------------------------------------------------------
  // removeFirst / removeLast
  // -----------------------------------------------------------------------
  print('\nremoveFirst(): ${ft.removeFirst().toList()}');
  print('removeLast():  ${ft.removeLast().toList()}');

  // -----------------------------------------------------------------------
  // concat
  // -----------------------------------------------------------------------
  final left = FingerTree.fromIterable([1, 2, 3]);
  final right = FingerTree.fromIterable([4, 5, 6]);
  final cat = left.concat(right);
  print('\nconcat([1,2,3], [4,5,6]): ${cat.toList()}');

  // Large concat
  final bigLeft = FingerTree.fromIterable(List.generate(25, (i) => i));
  final bigRight = FingerTree.fromIterable(List.generate(25, (i) => i + 25));
  final big = bigLeft.concat(bigRight);
  print(
    'concat of two 25-element trees: length=${big.length}, '
    'first=${big.first}, last=${big.last}',
  );

  // -----------------------------------------------------------------------
  // splitAt
  // -----------------------------------------------------------------------
  final ft2 = FingerTree.fromIterable([10, 20, 30, 40, 50]);
  final (l, r) = ft2.splitAt(3);
  print('\nsplitAt(3) on [10,20,30,40,50]:');
  print('  left:  ${l.toList()}');
  print('  right: ${r.toList()}');

  // -----------------------------------------------------------------------
  // Iteration via for-in
  // -----------------------------------------------------------------------
  print('\nIteration:');
  for (final x in FingerTree.fromIterable(['a', 'b', 'c'])) {
    print('  $x');
  }

  // -----------------------------------------------------------------------
  // Building via successive prepend
  // -----------------------------------------------------------------------
  FingerTree<int> built = FingerTree<int>.empty();
  for (int i = 10; i >= 1; i--) {
    built = built.prepend(i);
  }
  print('\nBuilt via prepend: ${built.toList()}');
}
