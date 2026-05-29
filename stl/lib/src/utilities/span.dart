/// A non-owning, bounds-checked view over a contiguous [List<T>].
///
/// Mirrors C++20 `std::span`. A [Span] holds no data of its own — it references
/// a window `[_offset, _offset + length)` of an existing [List<T>]. All read
/// operations are $O(1)$; no memory is copied unless [toList] is explicitly
/// called.
///
/// [Span] implements [Iterable<T>] so it composes naturally with every range
/// adapter in the library (`FilterRange`, `TransformRange`, etc.) and works
/// with `for`-`in` loops out of the box.
///
/// ```dart
/// final data = [10, 20, 30, 40, 50];
/// final view = Span(data);
///
/// print(view[2]);               // 30
/// print(view.first);            // 10
/// print(view.last);             // 50
///
/// final middle = view.subspan(1, 3);
/// print(middle.toList());       // [20, 30, 40]
///
/// final head = view.firstSpan(2);
/// print(head.toList());         // [10, 20]
/// ```
///
/// **Zero-copy guarantee:** [subspan], [firstSpan], and [lastSpan] all return
/// new [Span] instances that point into the same backing [List] — no elements
/// are copied.
///
/// See also:
/// - [StringView], the string-specific non-owning view in this library.
/// - C++20 `std::span` (`<span>`).
library;

import 'dart:collection' show IterableMixin;

/// A non-owning, zero-allocation view over a contiguous [List<T>].
///
/// Analogous to C++20 `std::span<T>`. Wraps a window into an existing
/// [List<T>] without copying elements. Element access and all slicing
/// operations are $O(1)$.
class Span<T> with IterableMixin<T> {
  final List<T> _source;
  final int _offset;
  final int _length;

  // ── Constructors ────────────────────────────────────────────────────────────

  /// Creates a [Span] that covers the entire [source] list.
  ///
  /// ```dart
  /// final s = Span([1, 2, 3, 4, 5]);
  /// print(s.length); // 5
  /// ```
  Span(List<T> source) : _source = source, _offset = 0, _length = source.length;

  /// Creates a [Span] that views [count] elements of [source] starting at
  /// [offset].
  ///
  /// Throws [RangeError] if `offset < 0`, `count < 0`, or
  /// `offset + count > source.length`.
  ///
  /// ```dart
  /// final s = Span.subspan([1, 2, 3, 4, 5], 1, 3);
  /// print(s.toList()); // [2, 3, 4]
  /// ```
  Span.subspan(List<T> source, int offset, int count)
    : _source = source,
      _offset = offset,
      _length = count {
    if (offset < 0 || count < 0 || offset + count > source.length) {
      throw RangeError(
        'Span window [$offset, ${offset + count}) is out of range '
        'for a source of length ${source.length}.',
      );
    }
  }

  // ── Core Properties ─────────────────────────────────────────────────────────

  /// The number of elements in this span.
  ///
  /// Mirrors `std::span::size`. $O(1)$.
  @override
  int get length => _length;

  /// Returns `true` if this span contains no elements.
  ///
  /// Mirrors `std::span::empty`.
  @override
  bool get isEmpty => _length == 0;

  /// Returns `true` if this span contains at least one element.
  @override
  bool get isNotEmpty => _length > 0;

  // ── Element Access ──────────────────────────────────────────────────────────

  /// Returns the element at [index] within this span.
  ///
  /// Throws [RangeError] if `index < 0` or `index >= length`.
  /// Mirrors `std::span::operator[]`. $O(1)$.
  T operator [](int index) {
    if (index < 0 || index >= _length) {
      throw RangeError.index(index, this, 'index', null, _length);
    }
    return _source[_offset + index];
  }

  /// The first element of the span.
  ///
  /// Throws [StateError] if the span is empty.
  /// Mirrors `std::span::front`. $O(1)$.
  @override
  T get first {
    if (isEmpty) throw StateError('Cannot access first of an empty Span.');
    return _source[_offset];
  }

  /// The last element of the span.
  ///
  /// Throws [StateError] if the span is empty.
  /// Mirrors `std::span::back`. $O(1)$.
  @override
  T get last {
    if (isEmpty) throw StateError('Cannot access last of an empty Span.');
    return _source[_offset + _length - 1];
  }

  // ── Slicing ─────────────────────────────────────────────────────────────────

  /// Returns a new [Span] covering the first [count] elements of this span.
  ///
  /// Throws [RangeError] if `count < 0` or `count > length`.
  /// Mirrors `std::span::first(n)`. $O(1)$.
  ///
  /// ```dart
  /// final s = Span([10, 20, 30, 40, 50]);
  /// print(s.firstSpan(3).toList()); // [10, 20, 30]
  /// ```
  Span<T> firstSpan(int count) {
    if (count < 0 || count > _length) {
      throw RangeError.value(count, 'count', 'count must be in [0, $_length].');
    }
    return Span.subspan(_source, _offset, count);
  }

  /// Returns a new [Span] covering the last [count] elements of this span.
  ///
  /// Throws [RangeError] if `count < 0` or `count > length`.
  /// Mirrors `std::span::last(n)`. $O(1)$.
  ///
  /// ```dart
  /// final s = Span([10, 20, 30, 40, 50]);
  /// print(s.lastSpan(2).toList()); // [40, 50]
  /// ```
  Span<T> lastSpan(int count) {
    if (count < 0 || count > _length) {
      throw RangeError.value(count, 'count', 'count must be in [0, $_length].');
    }
    return Span.subspan(_source, _offset + _length - count, count);
  }

  /// Returns a new [Span] starting at [offset] within this span, covering
  /// [count] elements (or extending to the end if [count] is omitted).
  ///
  /// The [offset] is relative to this span's own start — not to the backing
  /// source list.
  ///
  /// Throws [RangeError] if the window falls outside this span.
  /// Mirrors `std::span::subspan(offset[, count])`. $O(1)$.
  ///
  /// ```dart
  /// final s = Span([10, 20, 30, 40, 50]);
  /// print(s.subspan(1, 3).toList()); // [20, 30, 40]
  /// print(s.subspan(3).toList());    // [40, 50]
  /// ```
  Span<T> subspan(int offset, [int? count]) {
    final actualCount = count ?? (_length - offset);
    if (offset < 0 || actualCount < 0 || offset + actualCount > _length) {
      throw RangeError(
        'subspan($offset, $actualCount) is out of range '
        'for a span of length $_length.',
      );
    }
    return Span.subspan(_source, _offset + offset, actualCount);
  }

  // ── Search ──────────────────────────────────────────────────────────────────

  /// Returns `true` if [element] appears anywhere in this span.
  ///
  /// Uses `==` for comparison. $O(n)$.
  @override
  bool contains(Object? element) {
    for (int i = 0; i < _length; i++) {
      if (_source[_offset + i] == element) return true;
    }
    return false;
  }

  /// Returns the index of the first occurrence of [element] within this span,
  /// or `-1` if not found.
  ///
  /// The search begins at [start] (default `0`). The returned index is
  /// relative to the start of this span. $O(n)$.
  ///
  /// ```dart
  /// final s = Span([10, 20, 30, 20, 10]);
  /// print(s.indexOf(20));    // 1
  /// print(s.indexOf(20, 2)); // 3
  /// print(s.indexOf(99));    // -1
  /// ```
  int indexOf(T element, [int start = 0]) {
    if (start < 0) start = 0;
    for (int i = start; i < _length; i++) {
      if (_source[_offset + i] == element) return i;
    }
    return -1;
  }

  // ── Conversion ──────────────────────────────────────────────────────────────

  /// Returns a new [List<T>] containing a copy of the elements in this span.
  ///
  /// The returned list is independent of the backing source; mutating it does
  /// not affect this span or its source.
  @override
  List<T> toList({bool growable = true}) {
    final result = _source.sublist(_offset, _offset + _length);
    return growable ? result : List<T>.unmodifiable(result);
  }

  // ── Iteration ────────────────────────────────────────────────────────────────

  @override
  Iterator<T> get iterator => _SpanIterator<T>(_source, _offset, _length);

  // ── Value Semantics ──────────────────────────────────────────────────────────

  /// Two spans are equal when they have the same [length] and every
  /// corresponding element compares equal via `==`.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Span<T>) return false;
    if (_length != other._length) return false;
    for (int i = 0; i < _length; i++) {
      if (_source[_offset + i] != other._source[other._offset + i]) {
        return false;
      }
    }
    return true;
  }

  @override
  int get hashCode {
    var h = _length.hashCode;
    for (int i = 0; i < _length; i++) {
      h = h ^ _source[_offset + i].hashCode;
    }
    return h;
  }

  @override
  String toString() {
    final buf = StringBuffer('Span[');
    for (int i = 0; i < _length; i++) {
      if (i > 0) buf.write(', ');
      buf.write(_source[_offset + i]);
    }
    buf.write(']');
    return buf.toString();
  }
}

/// Internal forward iterator for [Span<T>].
class _SpanIterator<T> implements Iterator<T> {
  final List<T> _source;
  final int _offset;
  final int _length;
  int _index = -1;

  _SpanIterator(this._source, this._offset, this._length);

  @override
  T get current => _source[_offset + _index];

  @override
  bool moveNext() {
    _index++;
    return _index < _length;
  }
}
