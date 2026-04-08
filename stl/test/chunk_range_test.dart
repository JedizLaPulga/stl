import 'package:test/test.dart';
import 'package:stl/stl.dart';

void main() {
  group('ChunkRange', () {
    test('chunks evenly divisible list', () {
      final list = [1, 2, 3, 4, 5, 6];
      final chunks = ChunkRange(list, 2).toList();
      
      expect(chunks.length, 3);
      expect(chunks[0], [1, 2]);
      expect(chunks[1], [3, 4]);
      expect(chunks[2], [5, 6]);
    });

    test('chunks non-evenly divisible list (smaller last chunk)', () {
      final list = [1, 2, 3, 4, 5];
      final chunks = ChunkRange(list, 2).toList();
      
      expect(chunks.length, 3);
      expect(chunks[0], [1, 2]);
      expect(chunks[1], [3, 4]);
      expect(chunks[2], [5]);
    });

    test('chunks with size larger than list', () {
      final list = [1, 2, 3];
      final chunks = ChunkRange(list, 10).toList();
      
      expect(chunks.length, 1);
      expect(chunks[0], [1, 2, 3]);
    });

    test('throws ArgumentError on non-positive chunk size', () {
      expect(() => ChunkRange([1, 2], 0), throwsArgumentError);
      expect(() => ChunkRange([1, 2], -5), throwsArgumentError);
    });

    test('empty list returns no chunks', () {
      final chunks = ChunkRange([], 3).toList();
      expect(chunks.isEmpty, isTrue);
    });
  });
}
