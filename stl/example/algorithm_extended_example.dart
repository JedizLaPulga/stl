import 'package:stl/stl.dart';

void main() {
  print('--- C++23 Range Algorithms (v0.7.5) ---\n');

  // =======================================================================
  // foldLeft / foldRight / foldLeftFirst
  // =======================================================================
  print('=== Fold Operations ===\n');

  final nums = [1, 2, 3, 4, 5];
  print('nums: $nums');

  // foldLeft — left-to-right reduction
  final sum = foldLeft(nums, 0, (acc, x) => acc + x);
  print('\nfoldLeft(sum):    $sum');

  final product = foldLeft(nums, 1, (acc, x) => acc * x);
  print('foldLeft(product): $product');

  // String concatenation showing associativity
  final words = ['Hello', ' ', 'Dart', '!'];
  final leftStr = foldLeft(words, '', (acc, s) => acc + s);
  final rightStr = foldRight(words, '', (s, acc) => s + acc);
  print('\nwords: $words');
  print('foldLeft  (left-to-right): "$leftStr"');
  print('foldRight (right-to-left): "$rightStr"');

  // foldLeftFirst — no initial value needed
  final maxVal = foldLeftFirst(nums, (a, b) => a > b ? a : b);
  print('\nfoldLeftFirst(max): $maxVal');

  final minVal = foldLeftFirst(nums, (a, b) => a < b ? a : b);
  print('foldLeftFirst(min): $minVal');

  // =======================================================================
  // rangeContains / rangeContainsSubrange
  // =======================================================================
  print('\n=== rangeContains Operations ===\n');

  final data = [10, 20, 30, 40, 50];
  print('data: $data');

  print('\ncontains(30):  ${rangeContains(data, 30)}');
  print('rangeContains(99):  ${rangeContains(data, 99)}');

  print('\ncontainsSubrange([20,30]): ${rangeContainsSubrange(data, [20, 30])}');
  print('rangeContainsSubrange([20,40]): ${rangeContainsSubrange(data, [20, 40])}');
  print('rangeContainsSubrange([]):      ${rangeContainsSubrange(data, [])}');

  final text = 'The quick brown fox'.split(' ');
  print('\nsentence: $text');
  print(
    'rangeContainsSubrange(["quick","brown"]): ${rangeContainsSubrange(text, ["quick", "brown"])}',
  );
  print(
    'rangeContainsSubrange(["quick","fox"]):   ${rangeContainsSubrange(text, ["quick", "fox"])}',
  );

  // =======================================================================
  // startsWith / endsWith
  // =======================================================================
  print('\n=== Prefix / Suffix Matching ===\n');

  final seq = [1, 2, 3, 4, 5];
  print('seq: $seq');

  print('rangeStartsWith([1,2,3]):   ${rangeStartsWith(seq, [1, 2, 3])}');
  print('rangeStartsWith([2,3]):     ${rangeStartsWith(seq, [2, 3])}');
  print('rangeStartsWith([]):        ${rangeStartsWith(seq, [])}');

  print('rangeEndsWith([4,5]):       ${rangeEndsWith(seq, [4, 5])}');
  print('rangeEndsWith([3,5]):       ${rangeEndsWith(seq, [3, 5])}');
  print('rangeEndsWith([]):          ${rangeEndsWith(seq, [])}');

  final path = '/usr/local/bin/dart'.split('/');
  print('\npath segments: $path');
  print('rangeStartsWith(["","usr"]): ${rangeStartsWith(path, ['', 'usr'])}');
  print(
    'rangeEndsWith(["bin","dart"]): ${rangeEndsWith(path, ['bin', 'dart'])}',
  );

  // =======================================================================
  // findLast / findLastIf / findLastIfNot
  // =======================================================================
  print('\n=== Find-Last Operations ===\n');

  final list = [1, 3, 2, 5, 2, 4, 2];
  print('list: $list');

  print('\nfindLast(2):        ${findLast(list, 2)}  (index)');
  print('find(2):             ${find(list, 2)}  (first index)');

  print('\nfindLastIf(even):   ${findLastIf(list, (n) => n.isEven)}');
  print('findIf(even):        ${findIf(list, (n) => n.isEven)}');

  print('\nfindLastIfNot(even): ${findLastIfNot(list, (n) => n.isEven)}');
  print('findIfNot(even):      ${findIfNot(list, (n) => n.isEven)}');

  // findLast on strings
  final tokens = ['a', 'b', 'c', 'b', 'a'];
  print('\ntokens: $tokens');
  print('findLast("b"):  ${findLast(tokens, 'b')}');
  print(
    'findLastIf(isUppercase): ${findLastIf(tokens, (s) => s == s.toUpperCase())}',
  );

  // =======================================================================
  // Combining the new algorithms
  // =======================================================================
  print('\n=== Combined Example ===\n');

  final scores = [88, 72, 95, 61, 95, 80, 95];
  print('scores: $scores');

  // Find last 95
  final lastTop = findLast(scores, 95);
  print('\nlast 95 is at index $lastTop');

  // Find last below 70
  final lastFail = findLastIf(scores, (s) => s < 70);
  print('last score < 70 is at index $lastFail (score: ${scores[lastFail]})');

  // Build running max via foldLeft
  final runningMax = foldLeft<int, List<int>>(
    scores,
    [],
    (acc, x) => acc.isEmpty ? [x] : [...acc, x > acc.last ? x : acc.last],
  );
  print('\nrunning maximum: $runningMax');

  // Check if scores start with a passing run [88, 72, 95]
  print(
    'rangeStartsWith scores [88,72,95]: ${rangeStartsWith(scores, [88, 72, 95])}',
  );
  // Check if any 95 sub-run exists
  print(
    'rangeContainsSubrange scores [95,61,95]: ${rangeContainsSubrange(scores, [95, 61, 95])}',
  );
}
