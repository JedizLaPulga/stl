import 'package:stl/stl.dart';

void main() {
  print('--- RepeatRange with finite bounds ---');
  final finite = RepeatRange('Flutter', 3);
  print(finite.toList()); 

  print('\n--- RepeatRange mimicking infinite stream ---');
  // Useful for generators or filling a buffer dynamically
  final infinite = RepeatRange(0);
  
  // Notice we use the standard Dart `.take()` iterable method seamlessly!
  final zeros = infinite.take(10).toList();
  print('10 zeros: $zeros');
}
