import 'package:stl/stl.dart';

void main() {
  print('--- NonEmptyVector<T> Demonstration ---\n');

  // -----------------------------------------------------------------------
  // Construction
  // -----------------------------------------------------------------------
  final nev = NonEmptyVector.of(10, [20, 30, 40]);
  print('Created: $nev');
  print('first:  ${nev.first}');
  print('last:   ${nev.last}');
  print('length: ${nev.length}');

  // -----------------------------------------------------------------------
  // Indexing and mutation
  // -----------------------------------------------------------------------
  nev[1] = 99;
  print('\nAfter nev[1] = 99: $nev');

  nev.add(50);
  print('After add(50): $nev');

  nev.addAll([60, 70]);
  print('After addAll([60, 70]): $nev');

  // -----------------------------------------------------------------------
  // Safe removal — non-empty invariant enforced
  // -----------------------------------------------------------------------
  nev.removeAt(0);
  print('\nAfter removeAt(0): $nev');

  nev.removeLast();
  print('After removeLast(): $nev');

  // -----------------------------------------------------------------------
  // insert
  // -----------------------------------------------------------------------
  nev.insert(1, 15);
  print('After insert(1, 15): $nev');

  // -----------------------------------------------------------------------
  // fromVector
  // -----------------------------------------------------------------------
  final vec = Vector<int>([1, 2, 3]);
  final fromVec = NonEmptyVector.fromVector(vec);
  print('\nFromVector: $fromVec');

  // -----------------------------------------------------------------------
  // Error: attempting to empty the vector throws
  // -----------------------------------------------------------------------
  final single = NonEmptyVector.of(42);
  try {
    single.removeAt(0);
  } on InvalidArgument catch (e) {
    print('\nExpected error: ${e.message}');
  }

  // -----------------------------------------------------------------------
  // Error: constructing from empty Vector throws
  // -----------------------------------------------------------------------
  try {
    NonEmptyVector.fromVector(Vector<int>([]));
  } on InvalidArgument catch (e) {
    print('Expected error: ${e.message}');
  }
}
