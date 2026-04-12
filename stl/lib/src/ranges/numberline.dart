import 'dart:collection';

/// A memory-efficient iterable sequence of numbers.
/// Mimics C++ `std::views::iota` or Python's `range()`.
///
/// Can iterate over both [int] and [double], and the boundary
/// condition for [end] is *exclusive*, meaning it stops before the exact requested ending.
class NumberLine<T extends num> extends IterableBase<T> {
  /// The starting inclusive boundary of the sequence.
  T start;

  /// The ending exclusive boundary of the sequence.
  T end;

  /// The amount or distance to step incrementally on each iteration.
  T step;

  final T _initStart;
  final T _initEnd;
  final T _initStep;

  /// Creates a memory-efficient sequence from [start] to [end] exclusive, incrementing by [step].
  NumberLine(this.start, this.end, {T? step})
    : step = step ?? _defaultStep(start),
      _initStart = start,
      _initEnd = end,
      _initStep = step ?? _defaultStep(start) {
    if (this.step == 0) {
      throw ArgumentError('Step cannot be zero.');
    }
  }

  static T _defaultStep<T extends num>(T start) {
    if (start is double) return 1.0 as T;
    return 1 as T;
  }

  @override
  Iterator<T> get iterator => _NumberLineIterator<T>(this);

  @override
  bool contains(Object? element) {
    if (element is num) {
      if (step > 0) {
        if (element < start || element >= end) return false;
      } else {
        if (element > start || element <= end) return false;
      }

      num diff = element - start;
      num rem = diff % step;

      // Handle floating point imprecision nicely
      if (rem.abs() < 1e-10 || (rem.abs() - step.abs()).abs() < 1e-10) {
        return true;
      }
    }
    return false;
  }

  @override
  int get length {
    if (step > 0 && start >= end) return 0;
    if (step < 0 && start <= end) return 0;
    return ((end - start) / step).ceil();
  }

  @override
  bool operator ==(Object other) =>
      other is NumberLine &&
      start == other.start &&
      end == other.end &&
      step == other.step;

  @override
  int get hashCode => Object.hash(start, end, step);

  @override
  String toString() => 'NumberLine($start, $end, step: $step)';

  /// Resets the sequence to its initial state.
  void reset() {
    start = _initStart;
    end = _initEnd;
    step = _initStep;
  }

  /// Returns true if the sequence is empty.
  bool empty() => isEmpty;

  /// Returns true if the sequence has elements.
  bool hasValue() => isNotEmpty;

  /// Returns the type argument [T].
  Type type() => T;

  /// Safely casts this [NumberLine] to a different numeric type.
  NumberLine<U> cast<U extends num>() {
    return NumberLine<U>(start as U, end as U, step: step as U);
  }

  /// Modifies the boundaries of this number line sequence.
  void set(T newStart, T newEnd, [T? newStep]) {
    start = newStart;
    end = newEnd;
    if (newStep != null) {
      if (newStep == 0) throw ArgumentError('Step cannot be zero.');
      step = newStep;
    }
  }

  /// Retrieves the element at the specified 0-based [index] in O(1) time.
  T get(int index) {
    if (index < 0 || index >= length) {
      throw RangeError.index(index, this);
    }
    return (start + index * step) as T;
  }

  /// Retrieves the element at the specified 0-based [index] in O(1) time.
  T operator [](int index) => get(index);

  /// Unsupported. Modifying a generated mathematical sequence element by element is invalid.
  void operator []=(int index, T value) {
    throw UnsupportedError(
      'Cannot modify elements of a NumberLine at a specific index.',
    );
  }

  /// Shifts the sequence by adding [offset] consistently to boundaries.
  NumberLine<T> operator +(num offset) =>
      NumberLine<T>((start + offset) as T, (end + offset) as T, step: step);

  /// Shifts the sequence by subtracting [offset] consistently from boundaries.
  NumberLine<T> operator -(num offset) =>
      NumberLine<T>((start - offset) as T, (end - offset) as T, step: step);

  /// Scales the sequence proportionally by multiplying boundaries and step by [factor].
  NumberLine<T> operator *(num factor) => NumberLine<T>(
    (start * factor) as T,
    (end * factor) as T,
    step: (step * factor) as T,
  );

  /// Divides the sequence proportionally safely returning a NumberLine of doubles.
  NumberLine<double> operator /(num divisor) =>
      NumberLine<double>(start / divisor, end / divisor, step: step / divisor);

  /// Modulo operation on sequence boundaries keeping the step intact.
  NumberLine<T> operator %(num modulo) =>
      NumberLine<T>((start % modulo) as T, (end % modulo) as T, step: step);

  /// Safely performs lexicographical comparison against another iterable.
  bool operator <(Iterable<T> other) {
    Iterator<T> it1 = iterator;
    Iterator<T> it2 = other.iterator;
    while (it1.moveNext() && it2.moveNext()) {
      if (it1.current < it2.current) return true;
      if (it1.current > it2.current) return false;
    }
    return it2.moveNext();
  }

  bool operator >(Iterable<T> other) {
    Iterator<T> it1 = iterator;
    Iterator<T> it2 = other.iterator;
    while (it1.moveNext() && it2.moveNext()) {
      if (it1.current > it2.current) return true;
      if (it1.current < it2.current) return false;
    }
    return it1.moveNext();
  }

  bool operator <=(Iterable<T> other) => !(this > other);
  bool operator >=(Iterable<T> other) => !(this < other);
}

class _NumberLineIterator<T extends num> implements Iterator<T> {
  final NumberLine<T> _line;
  T? _current;
  bool _initialized = false;

  _NumberLineIterator(this._line);

  @override
  T get current {
    if (!_initialized) throw StateError('Iterator not initialized');
    return _current as T;
  }

  @override
  bool moveNext() {
    if (!_initialized) {
      if ((_line.step > 0 && _line.start >= _line.end) ||
          (_line.step < 0 && _line.start <= _line.end)) {
        return false;
      }
      _current = _line.start;
      _initialized = true;
      return true;
    }

    T nextValue = (_current! + _line.step) as T;

    // For doubles, we should handle slight precision issues
    // by comparing with a small epsilon, but standard comparison is usually fine
    // as long as step doesn't accumulate huge errors out of nowhere.
    if (_line.step > 0) {
      if (nextValue >= _line.end) return false;
    } else {
      if (nextValue <= _line.end) return false;
    }

    _current = nextValue;
    return true;
  }
}
