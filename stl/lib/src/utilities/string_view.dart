/// A non-owning, zero-allocation reference to a string or a contiguous substring.
///
/// In the C++ STL, this matches the behavior of `std::string_view`.
/// It provides high-performance read-only operations on text sequences
/// without dynamically allocating new string memory under the hood.
/// [StringView] implements [Comparable] so instances may be ordered with
/// `<`, `<=`, `>`, `>=`, and [compareTo].
class StringView implements Comparable<StringView> {
  final String _string;
  final int _start;
  final int _end;

  /// Creates a StringView from an entire [String].
  StringView(this._string) : _start = 0, _end = _string.length;

  /// Creates a StringView from a specific segment of a [String].
  ///
  /// The substring spans from [start] (inclusive) to [end] (exclusive).
  StringView.substring(this._string, this._start, this._end) {
    if (_start < 0 || _end > _string.length || _start > _end) {
      throw RangeError('Invalid substring bounds for StringView');
    }
  }

  /// Returns the length of the string view.
  int get length => _end - _start;

  /// Returns `true` if the string view is empty.
  bool get isEmpty => length == 0;

  /// Returns `true` if the string view is not empty.
  bool get isNotEmpty => length > 0;

  /// Returns the character at the given [index].
  String operator [](int index) {
    if (index < 0 || index >= length) {
      throw RangeError.index(index, this);
    }
    return _string[_start + index];
  }

  /// Returns a new StringView spanning a portion of this view.
  ///
  /// The new view references the exact same parent string directly.
  StringView substring(int start, [int? end]) {
    final localEnd = end ?? length;
    if (start < 0 || localEnd > length || start > localEnd) {
      throw RangeError('Invalid substring bounds for StringView');
    }
    return StringView.substring(_string, _start + start, _start + localEnd);
  }

  /// Checks whether the string view begins with the given [pattern].
  bool startsWith(String pattern) {
    if (pattern.length > length) return false;
    for (int i = 0; i < pattern.length; i++) {
      if (_string[_start + i] != pattern[i]) return false;
    }
    return true;
  }

  /// Checks whether the string view ends with the given [pattern].
  bool endsWith(String pattern) {
    if (pattern.length > length) return false;
    int offset = length - pattern.length;
    for (int i = 0; i < pattern.length; i++) {
      if (_string[_start + offset + i] != pattern[i]) return false;
    }
    return true;
  }

  /// Returns the position of the first match of [pattern] in this view,
  /// starting the search at [start].
  int indexOf(String pattern, [int start = 0]) {
    if (start < 0 || start > length) return -1;
    if (pattern.isEmpty) return start;
    if (pattern.length > length - start) return -1;

    for (int i = start; i <= length - pattern.length; i++) {
      bool match = true;
      for (int j = 0; j < pattern.length; j++) {
        if (_string[_start + i + j] != pattern[j]) {
          match = false;
          break;
        }
      }
      if (match) return i;
    }
    return -1;
  }

  /// Checks if this string view contains the [pattern].
  bool contains(String pattern, [int start = 0]) {
    return indexOf(pattern, start) != -1;
  }

  /// Trims leading and trailing whitespace, returning a new tightly-bound StringView.
  StringView trim() {
    int newStart = _start;
    int newEnd = _end;
    while (newStart < newEnd && _isWhitespace(_string[newStart])) {
      newStart++;
    }
    while (newEnd > newStart && _isWhitespace(_string[newEnd - 1])) {
      newEnd--;
    }
    return StringView.substring(_string, newStart, newEnd);
  }

  /// Compares this view with [other] lexicographically, matching the ordering
  /// of `std::string_view::compare`.
  ///
  /// Returns a negative integer, zero, or a positive integer when this view
  /// is lexicographically less than, equal to, or greater than [other].
  @override
  int compareTo(StringView other) {
    final minLen = length < other.length ? length : other.length;
    for (int i = 0; i < minLen; i++) {
      final cmp = this[i].compareTo(other[i]);
      if (cmp != 0) return cmp;
    }
    return length.compareTo(other.length);
  }

  /// Returns `true` if this view is lexicographically less than [other].
  bool operator <(StringView other) => compareTo(other) < 0;

  /// Returns `true` if this view is lexicographically less than or equal to [other].
  bool operator <=(StringView other) => compareTo(other) <= 0;

  /// Returns `true` if this view is lexicographically greater than [other].
  bool operator >(StringView other) => compareTo(other) > 0;

  /// Returns `true` if this view is lexicographically greater than or equal to [other].
  bool operator >=(StringView other) => compareTo(other) >= 0;

  /// Returns the position of the **last** match of [pattern] in this view,
  /// scanning backwards from [start] (defaults to the end of the view).
  ///
  /// Returns `-1` if [pattern] is not found.
  int lastIndexOf(String pattern, [int? start]) {
    final searchEnd = (start ?? length - 1).clamp(0, length - 1);
    if (pattern.isEmpty) return searchEnd;
    if (pattern.length > length) return -1;
    for (int i = searchEnd - pattern.length + 1; i >= 0; i--) {
      bool match = true;
      for (int j = 0; j < pattern.length; j++) {
        if (_string[_start + i + j] != pattern[j]) {
          match = false;
          break;
        }
      }
      if (match) return i;
    }
    return -1;
  }

  /// Splits this view on [delimiter] and returns a list of zero-allocation
  /// [StringView] sub-views into the same backing string.
  ///
  /// Consecutive delimiters produce empty views. A trailing delimiter produces
  /// a final empty view. Mirrors `std::views::split` semantics.
  List<StringView> split(String delimiter) {
    if (delimiter.isEmpty) {
      return List.generate(
        length,
        (i) => StringView.substring(_string, _start + i, _start + i + 1),
        growable: false,
      );
    }
    final result = <StringView>[];
    int segStart = 0;
    while (segStart <= length) {
      final idx = indexOf(delimiter, segStart);
      if (idx == -1) {
        result.add(StringView.substring(_string, _start + segStart, _end));
        break;
      }
      result.add(
        StringView.substring(_string, _start + segStart, _start + idx),
      );
      segStart = idx + delimiter.length;
    }
    return result;
  }

  /// Returns a new [String] with every character converted to upper case.
  ///
  /// Delegates to the Dart runtime for correct Unicode handling. Returns a
  /// `String` rather than a `StringView` because Unicode case-folding can
  /// change the number of code units.
  String toUpperCase() => toString().toUpperCase();

  /// Returns a new [String] with every character converted to lower case.
  ///
  /// Delegates to the Dart runtime for correct Unicode handling. Returns a
  /// `String` rather than a `StringView` because Unicode case-folding can
  /// change the number of code units.
  String toLowerCase() => toString().toLowerCase();

  bool _isWhitespace(String c) {
    return c == ' ' || c == '\n' || c == '\r' || c == '\t';
  }

  /// Instantiates a standard Dart [String] containing the precise view segment.
  /// Note: This performs an $O(N)$ memory allocation!
  @override
  String toString() {
    return _string.substring(_start, _end);
  }

  @override
  int get hashCode => Object.hash(_start, _end, _string);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is StringView) {
      if (length != other.length) return false;
      for (int i = 0; i < length; i++) {
        if (this[i] != other[i]) return false;
      }
      return true;
    }
    if (other is String) {
      if (length != other.length) return false;
      for (int i = 0; i < length; i++) {
        if (this[i] != other[i]) return false;
      }
      return true;
    }
    return false;
  }
}
