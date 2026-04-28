import 'package:stl/stl.dart';

void main() {
  final steps = ['Step 1', 'Step 2', 'Step 3', 'Step 4'];

  print('--- ReverseRange Example: Undo history ---');
  // std::views::reverse — replay steps in reverse (undo) order.
  for (final step in ReverseRange(steps)) {
    print('  Undoing: $step');
  }

  print('\n--- ReverseRange Example: Palindrome check ---');
  final word = 'racecar'.split('');
  final isPalindrome = ZipRange(
    word,
    ReverseRange(word),
  ).every((p) => p.first == p.second);
  print('"racecar" is palindrome: $isPalindrome'); // true
}
