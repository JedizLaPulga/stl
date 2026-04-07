import 'package:stl/stl.dart';

void main() {
  print('--- NumberLine Examples ---\n');

  // 1. Basic Integer Range
  var basicLine = NumberLine(1, 10);
  print('1. Basic Integer Range (1 to 10):');
  print(basicLine.toList());
  print('');

  // 2. Custom Step
  var stepLine = NumberLine<int>(0, 20, step: 4);
  print('2. Custom Step Increment of 4 (0 to 20):');
  print(stepLine.toList());
  print('');

  // 3. Descending Numbers
  var descendingLine = NumberLine(10, 0, step: -2);
  print('3. Descending Numbers (10 to 0) jumping -2:');
  print(descendingLine.toList());
  print('');

  // 4. Double/Decimals Precision
  var doubleLine = NumberLine<double>(0.0, 3.0, step: 0.5);
  print('4. Double Precision Intervals (0.0 to 3.0):');
  print(doubleLine.toList());
  print('');

  // 5. Using Iterable Methods Out of the Box directly
  var loopLine = NumberLine(1, 6);
  print('5. Native Dart Iterable Extensions (For loop on 1 to 6):');
  for (var n in loopLine) {
    print('  -> Looping number $n');
  }
  print('');

  print('6. Powerful List methods (finding even numbers using .where()):');
  print(NumberLine(1, 10).where((x) => x % 2 == 0).toList());
  print('');

  print('7. Fast Mathematical `.contains()` check WITHOUT generating lists:');
  print(
    'Does NumberLine(0, 20, step: 4) contain 12? -> ${stepLine.contains(12)}',
  );
  print(
    'Does NumberLine(0, 20, step: 4) contain 13? -> ${stepLine.contains(13)}',
  );
}
