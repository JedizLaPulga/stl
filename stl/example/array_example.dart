import 'package:stl/stl.dart';

void main() {
  print('--- Array<T> System Boot Sequence ---\n');

  // Launching an array explicitly sized mathematically to 10
  var fixedArray = Array<int>(10, 0);

  print('Structure created. Fixed bounds size set strictly natively: ${fixedArray.size()}');
  print('Memory buffer instantiated natively: $fixedArray');

  // Let's modify data without breaking bounding walls
  fixedArray[4] = 99;
  fixedArray[9] = 100;
  
  print('\nMemory buffer modified internally linearly: $fixedArray');

  print('\n[Testing Boundary Guard Constraints]');
  try {
     fixedArray.add(5);
  } catch (e) {
     print('Strict Mathematical Safety Triggered: $e');
  }

  print('\n[Testing structural + arithmetic operations natively]');
  // Append dynamically generating an actively unbound sequence temporarily
  var newUnboundList = fixedArray + [1, 2, 3];
  
  print('Returned scaling sequence conceptually unbound securely: $newUnboundList');
  print('Original native Array boundaries mathematically untouched explicitly! -> ${fixedArray.size()}');
}
