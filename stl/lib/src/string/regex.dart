/// A powerful, object-oriented wrapper around Dart's native [RegExp],
/// inspired by C++ `std::regex`.
///
/// This provides a familiar, typed API for text processing, pattern matching,
/// and extraction without relying entirely on raw string manipulations.
class Regex {
  final RegExp _regExp;

  /// Compiles a new [Regex] from the given [pattern].
  ///
  /// - [multiLine]: Whether this is a multi-line regular expression.
  /// - [caseSensitive]: Whether this regular expression is case sensitive.
  /// - [unicode]: Whether this regular expression is in Unicode mode.
  /// - [dotAll]: Whether `.` matches newlines.
  Regex(
    String pattern, {
    bool multiLine = false,
    bool caseSensitive = true,
    bool unicode = false,
    bool dotAll = false,
  }) : _regExp = RegExp(
          pattern,
          multiLine: multiLine,
          caseSensitive: caseSensitive,
          unicode: unicode,
          dotAll: dotAll,
        );

  /// Returns the underlying Dart [RegExp].
  RegExp get raw => _regExp;

  /// Returns the string pattern used to create this [Regex].
  String get pattern => _regExp.pattern;
}

/// Matches the **entire** [text] strictly against the [regex] pattern.
///
/// Mirrors C++ `std::regex_match`. Returns `true` only if the pattern covers
/// the string from the very beginning to the very end.
bool regexMatch(String text, Regex regex) {
  final match = regex.raw.firstMatch(text);
  return match != null && match.start == 0 && match.end == text.length;
}

/// Searches the [text] for the **first** sub-sequence that matches the [regex].
///
/// Mirrors C++ `std::regex_search`. Returns `true` if any portion of the string
/// satisfies the pattern.
bool regexSearch(String text, Regex regex) {
  return regex.raw.hasMatch(text);
}

/// Replaces all occurrences of the [regex] pattern in the [text] with the [replacement].
///
/// Mirrors C++ `std::regex_replace`. Optionally, you can replace a matched pattern
/// dynamically using [replaceMapped] with a function.
String regexReplace(String text, Regex regex, String replacement) {
  return text.replaceAll(regex.raw, replacement);
}

/// An iterator that lazily yields all non-overlapping matches of a [Regex] within a string.
///
/// Mirrors C++ `std::sregex_iterator`. Can be used to elegantly extract all matches
/// sequentially without allocating a single block of memory upfront.
class RegexIterator implements Iterator<RegExpMatch> {
  final Iterable<RegExpMatch> _matches;
  late Iterator<RegExpMatch> _iterator;

  /// Creates a new lazy iterator over the matches in [text].
  RegexIterator(String text, Regex regex)
      : _matches = regex.raw.allMatches(text) {
    _iterator = _matches.iterator;
  }

  @override
  RegExpMatch get current => _iterator.current;

  @override
  bool moveNext() => _iterator.moveNext();
}
