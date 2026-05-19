import 'package:stl/stl.dart';

void main() {
  // --- format ---
  print('--- std::format equivalent ---');
  printFormat('Hello, {}! The answer is {}.', ['World', 42]);
  printFormat('Hex: {:X}, Zero-padded: {:05d}', [255, 7]);
  printFormat('Pi to 2 decimals: {:.2f}', [3.14159265]);

  // --- regex ---
  print('\n--- std::regex equivalent ---');
  final r = Regex(r'\b\w{5}\b'); // Match 5-letter words
  final text = 'quick brown foxes jumps right over';
  
  if (regexSearch(text, r)) {
    print('Found a 5-letter word!');
  }

  final iter = RegexIterator(text, r);
  print('5-letter words in text:');
  while (iter.moveNext()) {
    print('- ${iter.current.group(0)}');
  }

  // --- string search ---
  print('\n--- Text Search Algorithms ---');
  final haystack = 'There is a needle in this haystack';
  final needle = 'needle';

  final kmpIndex = knuthMorrisPrattSearch(haystack, needle);
  final bmIndex = boyerMooreSearch(haystack, needle);

  print('KMP found "$needle" at index $kmpIndex');
  print('Boyer-Moore found "$needle" at index $bmIndex');
}
