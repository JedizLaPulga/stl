import 'package:stl/stl.dart';

void main() {
  print('--- SList Example ---');
  final list = SList<int>();
  list.pushBack(10);
  list.pushFront(5);
  list.pushBack(15);

  print('Front: ${list.front()}'); // 5
  print('Back: ${list.back()}'); // 15
  
  list.reverse();
  
  print('List elements:');
  for (var item in list) {
    print(item);
  }
}
