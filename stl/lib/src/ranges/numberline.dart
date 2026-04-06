import 'dart:collection';

/// A memory-efficient iterable sequence of numbers.
/// Mimics C++ `std::views::iota` or Python's `range()`.
///
/// Can iterate over both [int] and [double], and the boundary
/// condition for [end] is *exclusive*, meaning it stops before the exact requested ending.
class NumberLine<T extends num> extends IterableBase<T> {
  final T start;
  final T end;
  final T step;

  NumberLine(this.start, this.end, {T? step})
      : step = step ?? _defaultStep(start) {
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
