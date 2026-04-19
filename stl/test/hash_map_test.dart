import 'package:test/test.dart';
import 'package:stl/stl.dart';

void main() {
  group('HashMap', () {
    test('Initialization and basic operations', () {
      final map = HashMap<String, int>();
      expect(map.empty, isTrue);
      expect(map.size, equals(0));

      map.insert('apple', 1);
      expect(map.empty, isFalse);
      expect(map.size, equals(1));
      expect(map.contains('apple'), isTrue);
      expect(map['apple'], equals(1));
    });

    test('operator [] and []=', () {
      final map = HashMap<String, int>();
      map['banana'] = 2;
      expect(map['banana'], equals(2));
      
      map['banana'] = 3; // Update
      expect(map['banana'], equals(3));
      expect(map.size, equals(1));
    });

    test('erase() removes element correctly', () {
      final map = HashMap<String, int>();
      map.insert('apple', 1);
      map.insert('banana', 2);

      expect(map.erase('apple'), isTrue);
      expect(map.contains('apple'), isFalse);
      expect(map.size, equals(1));

      expect(map.erase('apple'), isFalse); // Already removed
    });

    test('clear() empties the map', () {
      final map = HashMap<String, int>();
      map.insert('apple', 1);
      map.insert('banana', 2);
      map.clear();

      expect(map.empty, isTrue);
      expect(map.size, equals(0));
      expect(map.contains('apple'), isFalse);
    });

    test('Iteration yields Pair<K, V>', () {
      final map = HashMap<String, int>();
      map.insert('apple', 1);
      map.insert('banana', 2);

      int count = 0;
      bool hasApple = false;
      bool hasBanana = false;

      for (var pair in map) {
        count++;
        if (pair.first == 'apple' && pair.second == 1) hasApple = true;
        if (pair.first == 'banana' && pair.second == 2) hasBanana = true;
      }

      expect(count, equals(2));
      expect(hasApple, isTrue);
      expect(hasBanana, isTrue);
    });

    test('Equality operator and hashCode', () {
      final map1 = HashMap<String, int>();
      map1.insert('apple', 1);
      map1.insert('banana', 2);

      final map2 = HashMap<String, int>();
      map2.insert('banana', 2);
      map2.insert('apple', 1);

      expect(map1, equals(map2));
      expect(map1.hashCode, equals(map2.hashCode));

      map2.insert('cherry', 3);
      expect(map1, isNot(equals(map2)));
      expect(map1.hashCode, isNot(equals(map2.hashCode)));
    });

    test('swap() exchanges contents', () {
      final map1 = HashMap<String, int>();
      map1.insert('apple', 1);

      final map2 = HashMap<String, int>();
      map2.insert('banana', 2);

      map1.swap(map2);

      expect(map1.contains('banana'), isTrue);
      expect(map1.contains('apple'), isFalse);
      expect(map2.contains('apple'), isTrue);
      expect(map2.contains('banana'), isFalse);
    });
  });
}
