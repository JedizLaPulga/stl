import 'dart:typed_data';

/// A space-efficient set implementation for managing boolean flags.
/// Mimics C++ `std::bitset` functionality.
class BitSet {
  final int _length;
  late final Uint32List _words;

  /// Creates a [BitSet] with a fixed number of bits.
  BitSet(this._length) {
    if (_length < 0) {
      throw RangeError('BitSet length cannot be negative.');
    }
    _words = Uint32List((_length + 31) ~/ 32);
  }

  /// The number of bits this BitSet holds.
  int size() => _length;

  /// Sets the bit at [index] to true (or the provided [value]).
  void set(int index, [bool value = true]) {
    _checkBounds(index);
    final wordIndex = index ~/ 32;
    final bitIndex = index % 32;
    if (value) {
      _words[wordIndex] |= (1 << bitIndex);
    } else {
      _words[wordIndex] &= ~(1 << bitIndex);
    }
  }

  /// Sets the bit at [index] to false.
  void reset(int index) {
    set(index, false);
  }

  /// Flips the bit at [index]. If no index is provided, flips all bits.
  void flip([int? index]) {
    if (index != null) {
      _checkBounds(index);
      final wordIndex = index ~/ 32;
      final bitIndex = index % 32;
      _words[wordIndex] ^= (1 << bitIndex);
    } else {
      for (int i = 0; i < _words.length; i++) {
        _words[i] = ~_words[i];
      }
      _clearUnusedBits();
    }
  }

  /// Returns true if the bit at [index] is set.
  bool test(int index) {
    _checkBounds(index);
    final wordIndex = index ~/ 32;
    final bitIndex = index % 32;
    return (_words[wordIndex] & (1 << bitIndex)) != 0;
  }

  /// Convenience operator for checking a bit.
  bool operator [](int index) => test(index);

  /// Convenience operator for setting a bit.
  void operator []=(int index, bool value) => set(index, value);

  /// Checks if all bits are set to true.
  bool all() {
    if (_length == 0) return true;
    for (int i = 0; i < _words.length - 1; i++) {
      if (_words[i] != 0xFFFFFFFF) return false;
    }
    final remainder = _length % 32;
    final mask = remainder == 0 ? 0xFFFFFFFF : (1 << remainder) - 1;
    return (_words.last & mask) == mask;
  }

  /// Checks if any bit is set to true.
  bool any() {
    for (int word in _words) {
      if (word != 0) return true;
    }
    return false;
  }

  /// Checks if no bits are set (all false).
  bool none() => !any();

  /// Counts the total number of bits set to true.
  int count() {
    int total = 0;
    for (int word in _words) {
      // Kernighan's bit counting or JS-safe loop
      int w = word;
      while (w != 0) {
        w &= (w - 1);
        total++;
      }
    }
    return total;
  }

  void _checkBounds(int index) {
    if (index < 0 || index >= _length) {
      throw RangeError.index(index, this, 'index', 'Index out of bounds', _length);
    }
  }

  void _clearUnusedBits() {
    final remainder = _length % 32;
    if (remainder != 0) {
      final mask = (1 << remainder) - 1;
      _words.last &= mask;
    }
  }

  @override
  String toString() {
    final buffer = StringBuffer();
    for (int i = _length - 1; i >= 0; i--) {
      buffer.write(test(i) ? '1' : '0');
    }
    return buffer.toString();
  }

  @override
  int get hashCode {
    int hash = 17;
    for (int word in _words) {
      hash = hash * 31 + word.hashCode;
    }
    return hash ^ _length.hashCode;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! BitSet || other._length != _length) return false;
    for (int i = 0; i < _words.length; i++) {
      if (_words[i] != other._words[i]) return false;
    }
    return true;
  }
}
