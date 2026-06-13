import 'package:test/test.dart';
import 'package:stl/src/collections/red_black_tree.dart';

void main() {
  group('RedBlackTree', () {
    test('insert and find', () {
      final tree = RedBlackTree<int, String>();
      expect(tree.insert(1, 'one'), isTrue);
      expect(tree.insert(2, 'two'), isTrue);
      expect(tree.insert(1, 'uno'), isFalse); // update
      
      expect(tree.findNode(1)?.value, equals('uno'));
      expect(tree.findNode(2)?.value, equals('two'));
      expect(tree.findNode(3), isNull);
      
      expect(tree.length, equals(2));
    });

    test('erase', () {
      final tree = RedBlackTree<int, String>();
      for (int i = 0; i < 10; i++) {
        tree.insert(i, '$i');
      }
      expect(tree.length, equals(10));
      
      expect(tree.erase(5), isTrue);
      expect(tree.findNode(5), isNull);
      expect(tree.length, equals(9));
      
      expect(tree.erase(5), isFalse); // already removed
    });

    test('iterator order', () {
      final tree = RedBlackTree<int, int>();
      final values = [5, 3, 7, 2, 4, 6, 8, 1, 9];
      for (var v in values) {
        tree.insert(v, v);
      }
      
      final iterated = tree.nodes.map((n) => n.value).toList();
      expect(iterated, equals([1, 2, 3, 4, 5, 6, 7, 8, 9]));
    });

    test('red-black invariants', () {
      final tree = RedBlackTree<int, int>();
      for (int i = 0; i < 100; i++) {
        tree.insert(i, i);
      }
      
      // 1. Root is black
      expect(tree.root!.color, equals(NodeColor.black));
      
      // Check other invariants recursively
      int checkInvariants(RBNode<int, int>? node) {
        if (node == null) return 1; // Black height of null is 1
        
        // 2. No two adjacent red nodes
        if (node.color == NodeColor.red) {
          if (node.left != null) expect(node.left!.color, equals(NodeColor.black));
          if (node.right != null) expect(node.right!.color, equals(NodeColor.black));
        }
        
        // 3. Every path has same black height
        int leftHeight = checkInvariants(node.left);
        int rightHeight = checkInvariants(node.right);
        expect(leftHeight, equals(rightHeight));
        
        return leftHeight + (node.color == NodeColor.black ? 1 : 0);
      }
      
      checkInvariants(tree.root);
    });
  });
}
