import 'package:stl/stl.dart';

void main() {
  print('--- RedBlackTree Example ---');
  
  // 1. Direct Usage of the Core Data Structure
  // Usually, users will use SortedSet or SortedMap, but RedBlackTree is available natively!
  final rbTree = RedBlackTree<int, String>();
  
  // 2. Insertions are strictly balanced to O(log n) worst-case time
  rbTree.insert(50, 'Fifty');
  rbTree.insert(20, 'Twenty');
  rbTree.insert(80, 'Eighty');
  rbTree.insert(10, 'Ten');
  rbTree.insert(30, 'Thirty');
  
  print('Tree length: ${rbTree.length}'); // 5
  
  // 3. Finding elements in guaranteed O(log n) time
  final node = rbTree.findNode(30);
  if (node != null) {
    print('Found: ${node.key} -> ${node.value}');
  }
  
  // 4. In-order non-mutating traversal via the Iterable interface
  print('In-order keys:');
  for (final n in rbTree.nodes) {
    print('- ${n.key} (Color: ${n.color.name})');
  }
  
  // 5. Deletions with Red-Black fixup
  rbTree.erase(20);
  print('After erasing 20, length: ${rbTree.length}');
  
  // Note: SortedMap and SortedSet are the high-level wrappers for this exact data structure!
}
