import 'package:test/test.dart';
import 'package:stl/stl.dart';
import 'dart:math' as math;

void main() {
  group('Complex Numbers', () {
    test('Constructors and Accessors', () {
      final c1 = Complex(3.0, 4.0);
      expect(c1.real(), equals(3.0));
      expect(c1.imag(), equals(4.0));
      
      final c2 = Complex(5);
      expect(c2.real(), equals(5.0));
      expect(c2.imag(), equals(0.0));
    });

    test('Polar representation', () {
      final c = Complex.polar(2.0, math.pi / 2); // 2i
      expect(c.real(), closeTo(0.0, 1e-10));
      expect(c.imag(), closeTo(2.0, 1e-10));
    });

    test('Math functions (abs, arg, norm, conj)', () {
      final c = Complex(3.0, 4.0);
      expect(c.abs(), equals(5.0)); // 3-4-5 triangle
      expect(c.arg(), closeTo(0.927295218, 1e-8)); // atan(4/3)
      expect(c.norm(), equals(25.0));
      
      final conjugate = c.conj();
      expect(conjugate.real(), equals(3.0));
      expect(conjugate.imag(), equals(-4.0));
    });

    test('Arithmetic operations (+, -, *, /)', () {
      final c1 = Complex(1.0, 2.0);
      final c2 = Complex(3.0, 4.0);
      
      // Addition
      final sum = c1 + c2;
      expect(sum, equals(Complex(4.0, 6.0)));
      
      // Subtraction
      final diff = c2 - c1;
      expect(diff, equals(Complex(2.0, 2.0)));
      
      // Multiplication
      // (1+2i)(3+4i) = 3 + 4i + 6i + 8i^2 = 3 + 10i - 8 = -5 + 10i
      final prod = c1 * c2;
      expect(prod, equals(Complex(-5.0, 10.0)));
      
      // Division
      // c1 / c2 = (1+2i)/(3+4i) = (1+2i)(3-4i) / 25 = (3 - 4i + 6i + 8) / 25 = (11 + 2i) / 25
      final div = c1 / c2;
      expect(div.real(), closeTo(11.0 / 25.0, 1e-10));
      expect(div.imag(), closeTo(2.0 / 25.0, 1e-10));
    });

    test('Equality and toString', () {
      final c1 = Complex(1, 2);
      final c2 = Complex(1.0, 2.0);
      expect(c1, equals(c2));
      
      expect(c1.toString(), equals('1.0 + 2.0i'));
      
      final c3 = Complex(1.0, -2.0);
      expect(c3.toString(), equals('1.0 - 2.0i'));
    });
  });
}
