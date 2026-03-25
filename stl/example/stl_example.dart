import 'package:stl/stl.dart' as stl;

void main() {
  const vec = stl.Vector([10, 20, 30, 40, 50]);

  final boolList = vec.toList<bool>();
  print(boolList);
}
