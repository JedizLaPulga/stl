import 'package:stl/stl.dart';

void main() {
  print('--- SplitRange Example: Split integers on a delimiter ---');
  // std::views::split — split [1, 0, 2, 3, 0, 4] on 0
  final numbers = SplitRange([1, 0, 2, 3, 0, 4], 0);
  print(numbers.toList()); // [[1], [2, 3], [4]]

  print('\n--- SplitRange Example: Split a CSV-style character list ---');
  // Split 'a,b,c' (as chars) on ','
  final csv = SplitRange('a,b,c'.split(''), ',');
  final words = csv.map((chars) => chars.join()).toList();
  print(words); // [a, b, c]

  print('\n--- SplitRange Example: Consecutive delimiters ---');
  // Two consecutive delimiters produce an empty segment between them.
  final doubles = SplitRange([1, 0, 0, 2], 0);
  print(doubles.toList()); // [[1], [], [2]]

  print('\n--- SplitRange Example: Sentence tokeniser ---');
  final sentence = 'the quick brown fox'.split('');
  final tokens = SplitRange(
    sentence,
    ' ',
  ).map((chars) => chars.join()).toList();
  print(tokens); // [the, quick, brown, fox]
}
