import 'package:stl/stl.dart';

void main() {
  final fruits = ['apple', 'banana', 'cherry', 'date'];

  print('--- EnumerateRange Example: Numbered menu ---');
  // Equivalent to std::views::enumerate — no manual counter needed.
  for (final item in EnumerateRange(fruits)) {
    print('  ${item.first + 1}. ${item.second}');
  }

  print('\n--- EnumerateRange Example: Build an index map ---');
  final indexMap = Map.fromEntries(
    EnumerateRange(fruits).map((p) => MapEntry(p.second, p.first)),
  );
  print(indexMap); // {apple: 0, banana: 1, cherry: 2, date: 3}
}
