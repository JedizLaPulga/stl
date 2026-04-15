import 'dart:math' as math;

/// A high-performance equivalent to C++ `<complex>`.
///
/// Represents a complex number with a real and an imaginary part, providing
/// operations for complex arithmetic and magnitude extraction.
class Complex {
  final double _real;
  final double _imag;

  /// Creates a standard complex number.
  /// If the imaginary part is not provided, it defaults to 0.0.
  const Complex(num real, [num imag = 0.0])
      : _real = real + 0.0,
        _imag = imag + 0.0;

  /// Creates a complex number from polar coordinates.
  /// [rho] is the magnitude, and [theta] is the phase angle in radians.
  factory Complex.polar(num rho, num theta) {
    return Complex(rho * math.cos(theta), rho * math.sin(theta));
  }

  /// Returns the real component of the complex number.
  double real() => _real;

  /// Returns the imaginary component of the complex number.
  double imag() => _imag;

  /// Computes the magnitude (absolute value) of the complex number.
  double abs() => math.sqrt(_real * _real + _imag * _imag);

  /// Computes the phase angle (argument) of the complex number in radians.
  double arg() => math.atan2(_imag, _real);

  /// Computes the squared magnitude of the complex number.
  double norm() => _real * _real + _imag * _imag;

  /// Returns the complex conjugate of the number (real - imag * i).
  Complex conj() => Complex(_real, -_imag);

  // Arithmetic operators
  Complex operator +(Complex other) {
    return Complex(_real + other._real, _imag + other._imag);
  }

  Complex operator -(Complex other) {
    return Complex(_real - other._real, _imag - other._imag);
  }

  Complex operator *(Complex other) {
    return Complex(
      _real * other._real - _imag * other._imag,
      _real * other._imag + _imag * other._real,
    );
  }

  Complex operator /(Complex other) {
    final denominator = other.norm();
    if (denominator == 0.0) {
      throw StateError('Division by zero in Complex arithmetic.');
    }
    return Complex(
      (_real * other._real + _imag * other._imag) / denominator,
      (_imag * other._real - _real * other._imag) / denominator,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Complex && _real == other._real && _imag == other._imag;
  }

  @override
  int get hashCode => Object.hash(_real, _imag);

  @override
  String toString() {
    if (_imag >= 0) {
      return '$_real + ${_imag}i';
    } else {
      return '$_real - ${-_imag}i';
    }
  }
}
