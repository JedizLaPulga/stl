import 'package:stl/stl.dart';

void main() {
  print('--- StringView Example ---');
  String largeText = "Hello, world! Welcome to the STL StringView.";
  
  // Creates a view over "world!" without allocating a new string
  var view = StringView.substring(largeText, 7, 13);
  
  print('View length: ${view.length}'); // 6
  print('Contains "or": ${view.contains("or")}'); // true
  print('Extracted string: ${view.toString()}'); // "world!"
}
