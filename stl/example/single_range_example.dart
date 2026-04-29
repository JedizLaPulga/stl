import 'package:stl/stl.dart';

void main() {
  print('--- SingleRange Example: Wrap a value as a range ---');
  // std::views::single(42) — one-element view
  final single = SingleRange(42);
  print(single.toList()); // [42]
  print(single.first); // 42

  print('\n--- SingleRange Example: Prepend a sentinel via JoinRange ---');
  // Prepend 0 before a generated sequence without allocating a new list.
  final withSentinel = JoinRange([SingleRange(0), IotaRange(1, 5)]);
  print(withSentinel.toList()); // [0, 1, 2, 3, 4]

  print('\n--- SingleRange Example: Compose with TransformRange ---');
  // Wrap a seed value and double it lazily.
  final doubled = TransformRange<int, int>(SingleRange(21), (n) => n * 2);
  print(doubled.toList()); // [42]

  print('\n--- SingleRange Example: Works with any type ---');
  print(SingleRange('hello').toList()); // [hello]
  print(SingleRange(3.14).toList()); // [3.14]
}
