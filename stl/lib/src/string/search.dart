import 'dart:math';

/// Advanced text search algorithms providing high performance substring matching.

/// Searches for the [pattern] within [text] using the Knuth-Morris-Pratt (KMP) algorithm.
///
/// Executes in `O(N + M)` time, where `N` is the length of the text and `M` is
/// the length of the pattern. Extremely efficient for patterns with many repeating
/// sub-patterns.
/// Returns the starting index of the first match, or `-1` if not found.
int knuthMorrisPrattSearch(String text, String pattern) {
  if (pattern.isEmpty) return 0;
  if (text.isEmpty || pattern.length > text.length) return -1;

  final m = pattern.length;
  final lps = List<int>.filled(m, 0);

  // Compute the Longest Prefix Suffix (LPS) array
  var length = 0;
  var i = 1;
  while (i < m) {
    if (pattern[i] == pattern[length]) {
      length++;
      lps[i] = length;
      i++;
    } else {
      if (length != 0) {
        length = lps[length - 1];
      } else {
        lps[i] = 0;
        i++;
      }
    }
  }

  // Perform the search
  i = 0; // index for text
  var j = 0; // index for pattern
  while (i < text.length) {
    if (pattern[j] == text[i]) {
      j++;
      i++;
    }
    if (j == m) {
      return i - j;
    } else if (i < text.length && pattern[j] != text[i]) {
      if (j != 0) {
        j = lps[j - 1];
      } else {
        i++;
      }
    }
  }
  return -1;
}

/// Searches for the [pattern] within [text] using the Boyer-Moore algorithm
/// (specifically utilizing the bad-character heuristic).
///
/// Executes in `O(N + M)` worst-case time but is significantly faster on average
/// for larger alphabets and long texts, often exhibiting sublinear characteristics.
/// Returns the starting index of the first match, or `-1` if not found.
int boyerMooreSearch(String text, String pattern) {
  if (pattern.isEmpty) return 0;
  if (text.isEmpty || pattern.length > text.length) return -1;

  final m = pattern.length;
  final n = text.length;

  // Initialize the bad character heuristic table
  final badChar = <int, int>{};
  for (var i = 0; i < m; i++) {
    badChar[pattern.codeUnitAt(i)] = i;
  }

  var shift = 0;
  while (shift <= (n - m)) {
    var j = m - 1;

    // Keep reducing j while characters match
    while (j >= 0 && pattern.codeUnitAt(j) == text.codeUnitAt(shift + j)) {
      j--;
    }

    // Match found
    if (j < 0) {
      return shift;
    } else {
      // Shift based on bad character heuristic
      final charCode = text.codeUnitAt(shift + j);
      final lastOccur = badChar[charCode] ?? -1;
      shift += max(1, j - lastOccur);
    }
  }

  return -1;
}
