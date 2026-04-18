import 'package:stl/stl.dart';

void main() {
  print('--- cmath module Examples ---\n');
  
  // 1. clamp
  print('[1] clamp()');
  print('clamp(5, 0, 10)   = ${clamp(5, 0, 10)}');
  print('clamp(-5, 0, 10)  = ${clamp(-5, 0, 10)}');
  print('clamp(15, 0, 10)  = ${clamp(15, 0, 10)}');
  print('clamp(3.14, 0, 3) = ${clamp(3.14, 0.0, 3.0)}');

  // 2. lerp
  print('\n[2] lerp()');
  print('lerp(0, 10, 0.5)    = ${lerp(0, 10, 0.5)}');
  print('lerp(100, 200, 0.1) = ${lerp(100, 200, 0.1)}');

  // 3. hypot
  print('\n[3] hypot()');
  print('hypot(3, 4)       = ${hypot(3, 4)}'); // 5.0
  print('hypot(2, 3, 6)    = ${hypot(2, 3, 6)}'); // 7.0
}
