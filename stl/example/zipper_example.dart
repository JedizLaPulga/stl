import 'package:stl/stl.dart';

void main() {
  print('--- Zipper<T> Demonstration ---\n');

  // -----------------------------------------------------------------------
  // Construction
  // -----------------------------------------------------------------------
  var z = Zipper.fromList([1, 2, 3, 4, 5]);
  print('Created at index 0: focus=${z.focus}, index=${z.index}');
  print('Full sequence: ${z.toList()}');

  // Position at specific index
  final zMid = Zipper.fromListAt([10, 20, 30, 40, 50], 2);
  print('\nfromListAt index 2: focus=${zMid.focus}');
  print('  left:  ${zMid.left}');
  print('  right: ${zMid.right}');

  // -----------------------------------------------------------------------
  // Navigation
  // -----------------------------------------------------------------------
  print('\nNavigation:');
  var zStr = Zipper.fromList(['a', 'b', 'c', 'd', 'e']);
  print('Start: focus=${zStr.focus}, index=${zStr.index}');

  zStr = zStr.moveRight();
  print('moveRight: focus=${zStr.focus}, index=${zStr.index}');

  zStr = zStr.moveRight();
  print('moveRight: focus=${zStr.focus}, index=${zStr.index}');

  zStr = zStr.moveLeft();
  print('moveLeft:  focus=${zStr.focus}, index=${zStr.index}');

  // -----------------------------------------------------------------------
  // replace — non-destructive edit
  // -----------------------------------------------------------------------
  print('\nreplace:');
  final zr = Zipper.fromListAt([1, 2, 3, 4], 2);
  final replaced = zr.replace(99);
  print('  original: ${zr.toList()}  (focus=${zr.focus})');
  print('  replaced: ${replaced.toList()}  (focus=${replaced.focus})');

  // -----------------------------------------------------------------------
  // insert
  // -----------------------------------------------------------------------
  print('\ninsert (before focus):');
  final zi = Zipper.fromListAt([1, 3, 4], 1);
  final inserted = zi.insert(2);
  print('  original: ${zi.toList()}');
  print('  inserted: ${inserted.toList()}  (focus still=${inserted.focus})');

  // -----------------------------------------------------------------------
  // delete
  // -----------------------------------------------------------------------
  print('\ndelete:');
  final zd = Zipper.fromListAt([1, 2, 3, 4], 1);
  final deleted = zd.delete();
  print('  original: ${zd.toList()}  (focus=${zd.focus})');
  print('  deleted:  ${deleted.toList()}  (new focus=${deleted.focus})');

  // -----------------------------------------------------------------------
  // Practical: find & replace all occurrences by walking the zipper
  // -----------------------------------------------------------------------
  print('\nFind and replace all 0s with 99:');
  Zipper<int> walk = Zipper.fromList([0, 1, 0, 2, 0, 3]);
  // Walk and replace
  while (true) {
    if (walk.focus == 0) {
      walk = walk.replace(99);
    }
    if (!walk.canMoveRight) break;
    walk = walk.moveRight();
  }
  // Handle last element
  if (walk.focus == 0) walk = walk.replace(99);
  print('  result: ${walk.toList()}');

  // -----------------------------------------------------------------------
  // Error cases
  // -----------------------------------------------------------------------
  print('\nError cases:');
  try {
    Zipper.fromList([]);
  } on InvalidArgument catch (e) {
    print('  fromList([]): ${e.message}');
  }

  try {
    Zipper.fromList([42]).delete();
  } on StateError catch (e) {
    print('  delete on single: ${e.message}');
  }

  try {
    Zipper.fromList([1, 2]).moveRight().moveRight();
  } on StateError catch (e) {
    print('  moveRight past end: ${e.message}');
  }
}
