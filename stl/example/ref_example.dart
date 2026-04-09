import 'package:stl/stl.dart';

void main() {
  print('--- Ref<T> Demonstration ---\n');

  // We are creating a functional 'Pointer-like' semantic graph
  var nodeA = Ref('Payload A');
  var nodeB = Ref('Payload B');

  // Create a pointer traversing nodes dynamically
  var activePointer = Ref('Null');
  print('Pointer starts tracking: ${activePointer()}');

  print('\n[Binding pointer to Node A]');
  activePointer.rebind(nodeA);
  print('Pointer now points at: ${activePointer()}');

  print('\n[Binding pointer to Node B]');
  activePointer.rebind(nodeB);
  print('Pointer now points at: ${activePointer()}');

  print('\n[Mutating underlying structure tightly]');
  activePointer.set('Modified Payload B');
  // It mutated its internal bound value, acting exclusively as the reference
  print('Pointer after mutation: ${activePointer()}');
}
