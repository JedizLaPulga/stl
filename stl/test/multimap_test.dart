import 'package:test/test.dart';
import 'package:stl/stl.dart';

void main() {
  group('MultiMap Tests', () {
    test('insert multiple values for same key', () {
      final map = MultiMap<String, int>();
      map.insert('A', 1);
      map.insert('A', 2);
      map.insert('B', 3);
      
      expect(map.size, 3);
      expect(map.count('A'), 2);
      expect(map.count('B'), 1);
      expect(map.equalRange('A').toList(), [1, 2]);
    });

    test('erase removes all values for key', () {
      final map = MultiMap<String, int>();
      map.insert('A', 1);
      map.insert('A', 2);
      
      expect(map.erase('A'), 2);
      expect(map.size, 0);
      expect(map.containsKey('A'), isFalse);
    });

    test('iteration order is sorted by key', () {
      final map = MultiMap<int, String>();
      map.insert(2, 'B');
      map.insert(1, 'A1');
      map.insert(1, 'A2');

      final pairs = map.toList();
      expect(pairs[0].first, 1);
      expect(pairs[0].second, 'A1');
      expect(pairs[1].first, 1);
      expect(pairs[1].second, 'A2');
      expect(pairs[2].first, 2);
    });
  });
}
