/// A non-owning, zero-allocation reference to a string or a contiguous substring.
///
/// In the C++ STL, this matches the behavior of `std::string_view`.
/// It provides high-performance read-only operations on text sequences
/// without dynamically allocating new string memory under the hood.
class StringView {
  final String _string;
  final int _start;
  final int _end;

  /// Creates a StringView from an entire [String].
  StringView(this._string)
      : _start = 0,
        _end = _string.length;

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
