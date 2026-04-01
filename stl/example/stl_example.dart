import 'package:stl/stl.dart';

void main() {
  // Showcasing how to initialize a vector
  const v = Vector<int>([1, 2, 3, 4]);
  final w = Vector<int>([1, 2, 3, 5]);

  print('Vector v: $v');
  print('Vector w: $w');

  if(w > v){
    print('w is greater than v');
  }else if(w < v){
    print('w is less than v');
  }else{
    print('w is equal to v');
  }

  print('Element at index 0: ${v[0]}');
  print('Element at index 1: ${w[1]}');
  print('Element at index 2: ${v[2]}');
  print('Element at index 3: ${w[3]}');

  print(w);
  

}
