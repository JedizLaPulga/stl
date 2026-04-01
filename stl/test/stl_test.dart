import 'package:test/test.dart';
import 'package:stl/stl.dart';

void main() {
  group('Vector Initialization', () {
    
    test('Can initialize with final', () {
      final vec = Vector<int>([1, 2, 3]);
      // We expect the operation to succeed without crashing
      expect(vec, isNotNull);
    });

    test('Can initialize with const', () {
      const vec = Vector<int>([10, 20]);
      expect(vec, isNotNull);
    });

  });
}
