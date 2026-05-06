// v0.6.4 Extended Iterator Tests
// Covers: empty source ReverseIterator, re-iteration, close() no-ops,
// FrontInsertIterator with SList, BackInsertIterator with empty container,
// InsertIterator at position 0, and InsertIterator at end.
import 'package:test/test.dart';
import 'package:stl/stl.dart';

void main() {
  group('ReverseIterator - edge cases', () {
    test('ReverseIterator on empty list produces no elements', () {
      final iter = ReverseIterator(<int>[]);
      expect(iter.toList(), isEmpty);
    });

    test('ReverseIterator on single-element list', () {
      expect(ReverseIterator([42]).toList(), equals([42]));
    });

    test('ReverseIterator is re-iterable (two passes produce same result)', () {
      final iter = ReverseIterator([1, 2, 3]);
      final first = iter.toList();
      final second = iter.toList();
      expect(first, equals([3, 2, 1]));
      expect(second, equals([3, 2, 1]));
    });

    test('ReverseIterator does not mutate the source list', () {
      final source = [1, 2, 3];
      ReverseIterator(source).toList();
      expect(source, equals([1, 2, 3]));
    });
  });

  group('BackInsertIterator - edge cases', () {
    test('BackInsertIterator on empty list appends correctly', () {
      final list = <int>[];
      final inserter = BackInsertIterator(list);
      inserter.add(1);
      inserter.add(2);
      expect(list, equals([1, 2]));
    });

    test('BackInsertIterator close() is a no-op', () {
      final list = <int>[1];
      final inserter = BackInsertIterator(list);
      inserter.close(); // must not throw
      expect(list, equals([1]));
    });

    test('BackInsertIterator with Deque uses pushBack', () {
      final deque = Deque<String>()..pushBack('a');
      BackInsertIterator(deque).add('b');
      expect(deque.toList(), equals(['a', 'b']));
    });
  });

  group('FrontInsertIterator - edge cases', () {
    test('FrontInsertIterator on empty list produces correct order', () {
      final list = <int>[];
      final inserter = FrontInsertIterator(list);
      inserter.add(3);
      inserter.add(2);
      inserter.add(1);
      // Each add inserts at index 0, so order is reversed
      expect(list, equals([1, 2, 3]));
    });

    test('FrontInsertIterator close() is a no-op', () {
      final list = <int>[5];
      FrontInsertIterator(list).close();
      expect(list, equals([5]));
    });

    test('FrontInsertIterator with SList uses pushFront', () {
      final slist = SList<int>()..pushBack(3);
      FrontInsertIterator(slist).add(1);
      FrontInsertIterator(slist).add(0);
      expect(slist.toList().first, equals(0));
    });
  });

  group('InsertIterator - edge cases', () {
    test('InsertIterator at position 0 prepends', () {
      final list = <int>[3, 4, 5];
      final inserter = InsertIterator(list, 0);
      inserter.add(1);
      inserter.add(2);
      expect(list.sublist(0, 2), equals([1, 2]));
    });

    test('InsertIterator at end appends', () {
      final list = <int>[1, 2, 3];
      final inserter = InsertIterator(list, 3);
      inserter.add(4);
      inserter.add(5);
      expect(list, equals([1, 2, 3, 4, 5]));
    });

    test('InsertIterator auto-advances index after each insert', () {
      final list = <int>[1, 5];
      final inserter = InsertIterator(list, 1);
      inserter.add(2);
      inserter.add(3);
      inserter.add(4);
      expect(list, equals([1, 2, 3, 4, 5]));
    });

    test('InsertIterator close() is a no-op', () {
      final list = <int>[1];
      InsertIterator(list, 0).close();
      expect(list, equals([1]));
    });
  });
}
