import 'package:stl/stl.dart';
import 'dart:math' as math;

void main() {
  print('--- C++ <complex> Class Example ---\n');

  // Initialization
  final c1 = Complex(3, 4);
  final c2 = Complex(-1, 2);
  print('c1 = $c1');
  print('c2 = $c2\n');

  // Math Functions
  print('Magnitude (abs) of c1: ${c1.abs()}');
  print('Phase (arg) of c1: ${c1.arg()} radians');
  print('Squared Magnitude (norm) of c1: ${c1.norm()}');
  print('Conjugate of c1: ${c1.conj()}\n');

  // Arithmetic
  print('c1 + c2 = ${c1 + c2}');
  print('c1 - c2 = ${c1 - c2}');
  print('c1 * c2 = ${c1 * c2}');
  print('c1 / c2 = ${c1 / c2}\n');

  // Polar Representation
  final polar = Complex.polar(5.0, math.pi / 4); // Magnitude 5, Phase 45 degrees
  print('Polar (rho=5, theta=pi/4): $polar');
}
