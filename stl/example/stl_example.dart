import 'package:stl/stl.dart';

void main() {
  // Showcasing how to initialize a vector
  const v = Vector<int>([1, 2, 3]);
  final w = Vector<int>([1, 2, 3]);

  print('Vector v: $v');
  print('Vector w: $w');
  
  // Notice: Right now in your code, v == w will print 'false' 
  // because we haven't implemented an 'operator ==' override in Vector yet!
  print('Are they equal in memory? ${v == w}'); 
}
