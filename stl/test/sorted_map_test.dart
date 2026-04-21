import 'package:test/test.dart';
import 'package:stl/stl.dart';

void main() {
  group('SortedMap Tests', () {
    test('insert and access', () {
      final map = SortedMap<int, String>();
      map.insert(2, 'B');
      map.insert(1, 'A');
      map.insert(3, 'C');
      
      expect(map.size, 3);
      expect(map[1], 'A');
      expect(map[2], 'B');
      expect(map[3], 'C');
    });

    test('iteration order is sorted', () {
      final map = SortedMap<int, String>();
      map.insert(3, 'C');
      map.insert(1, 'A');
      map.insert(2, 'B');

      final keys = map.map((p) => p.first).toList();
      expect(keys, [1, 2, 3]);
    });

    test('erase', () {
      final map = SortedMap<int, String>();
      map.insert(1, 'A');
      map.insert(2, 'B');
      expect(map.erase(1), isTrue);
      expect(map.size, 1);
      expect(map.containsKey(1), isFalse);
    });

    test('clear and empty', () {
      final map = SortedMap<int, String>();
      map.insert(1, 'A');
      expect(map.empty, isFalse);
      map.clear();
      expect(map.empty, isTrue);
      expect(map.size, 0);
    });
  });
}
