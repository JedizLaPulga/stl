import 'package:stl/stl.dart';
import 'package:test/test.dart';

void main() {
  // ── Constructor: Span(List<T>) ─────────────────────────────────────────────
  group('Span — full constructor', () {
    test('wraps an int list correctly', () {
      final s = Span([1, 2, 3, 4, 5]);
      expect(s.length, 5);
      expect(s.isEmpty, isFalse);
      expect(s.isNotEmpty, isTrue);
    });

    test('wraps a string list correctly', () {
      final s = Span(['a', 'b', 'c']);
      expect(s.length, 3);
    });

    test('empty list produces empty span', () {
      final s = Span<int>([]);
      expect(s.length, 0);
      expect(s.isEmpty, isTrue);
      expect(s.isNotEmpty, isFalse);
    });

    test('single-element list', () {
      final s = Span([42]);
      expect(s.length, 1);
      expect(s.first, 42);
      expect(s.last, 42);
    });
  });

  // ── Constructor: Span.subspan ─────────────────────────────────────────────
  group('Span — named constructor Span.subspan', () {
    test('creates a window in the middle of the source', () {
      final s = Span.subspan([10, 20, 30, 40, 50], 1, 3);
      expect(s.length, 3);
      expect(s[0], 20);
      expect(s[1], 30);
      expect(s[2], 40);
    });

    test('window starting at 0', () {
      final s = Span.subspan([1, 2, 3, 4], 0, 2);
      expect(s.toList(), [1, 2]);
    });

    test('window reaching the end', () {
      final s = Span.subspan([1, 2, 3, 4], 2, 2);
      expect(s.toList(), [3, 4]);
    });

    test('zero-length window is valid', () {
      final s = Span.subspan([1, 2, 3], 1, 0);
      expect(s.isEmpty, isTrue);
      expect(s.length, 0);
    });

    test('throws RangeError on negative offset', () {
      expect(() => Span.subspan([1, 2, 3], -1, 2), throwsRangeError);
    });

    test('throws RangeError on negative count', () {
      expect(() => Span.subspan([1, 2, 3], 0, -1), throwsRangeError);
    });

    test('throws RangeError when window exceeds source length', () {
      expect(() => Span.subspan([1, 2, 3], 2, 3), throwsRangeError);
    });

    test('exact-fit window is valid', () {
      final s = Span.subspan([1, 2, 3], 0, 3);
      expect(s.toList(), [1, 2, 3]);
    });
  });

  // ── operator[] ──────────────────────────────────────────────────────────────
  group('Span — operator[]', () {
    test('reads element at each index', () {
      final s = Span([10, 20, 30]);
      expect(s[0], 10);
      expect(s[1], 20);
      expect(s[2], 30);
    });

    test('throws RangeError for negative index', () {
      final s = Span([1, 2, 3]);
      expect(() => s[-1], throwsRangeError);
    });

    test('throws RangeError for index equal to length', () {
      final s = Span([1, 2, 3]);
      expect(() => s[3], throwsRangeError);
    });

    test('works correctly on a subspan', () {
      final s = Span.subspan([10, 20, 30, 40], 1, 2);
      expect(s[0], 20);
      expect(s[1], 30);
    });
  });

  // ── first / last ─────────────────────────────────────────────────────────────
  group('Span — first and last', () {
    test('first returns the first element', () {
      expect(Span([5, 6, 7]).first, 5);
    });

    test('last returns the last element', () {
      expect(Span([5, 6, 7]).last, 7);
    });

    test('first == last on single-element span', () {
      final s = Span([99]);
      expect(s.first, s.last);
    });

    test('first throws StateError on empty span', () {
      expect(() => Span<int>([]).first, throwsStateError);
    });

    test('last throws StateError on empty span', () {
      expect(() => Span<int>([]).last, throwsStateError);
    });

    test('first on subspan reflects offset', () {
      final s = Span.subspan([10, 20, 30], 1, 2);
      expect(s.first, 20);
    });

    test('last on subspan reflects offset', () {
      final s = Span.subspan([10, 20, 30], 1, 2);
      expect(s.last, 30);
    });
  });

  // ── firstSpan ───────────────────────────────────────────────────────────────
  group('Span — firstSpan', () {
    test('returns span of first n elements', () {
      final s = Span([10, 20, 30, 40, 50]);
      expect(s.firstSpan(3).toList(), [10, 20, 30]);
    });

    test('firstSpan(0) returns empty span', () {
      final s = Span([1, 2, 3]);
      expect(s.firstSpan(0).isEmpty, isTrue);
    });

    test('firstSpan(length) returns full span', () {
      final s = Span([1, 2, 3]);
      expect(s.firstSpan(3).toList(), [1, 2, 3]);
    });

    test('throws RangeError when count exceeds length', () {
      final s = Span([1, 2, 3]);
      expect(() => s.firstSpan(4), throwsRangeError);
    });

    test('throws RangeError for negative count', () {
      final s = Span([1, 2, 3]);
      expect(() => s.firstSpan(-1), throwsRangeError);
    });
  });

  // ── lastSpan ─────────────────────────────────────────────────────────────────
  group('Span — lastSpan', () {
    test('returns span of last n elements', () {
      final s = Span([10, 20, 30, 40, 50]);
      expect(s.lastSpan(2).toList(), [40, 50]);
    });

    test('lastSpan(0) returns empty span', () {
      final s = Span([1, 2, 3]);
      expect(s.lastSpan(0).isEmpty, isTrue);
    });

    test('lastSpan(length) returns full span', () {
      final s = Span([1, 2, 3]);
      expect(s.lastSpan(3).toList(), [1, 2, 3]);
    });

    test('throws RangeError when count exceeds length', () {
      final s = Span([1, 2, 3]);
      expect(() => s.lastSpan(4), throwsRangeError);
    });

    test('throws RangeError for negative count', () {
      final s = Span([1, 2, 3]);
      expect(() => s.lastSpan(-1), throwsRangeError);
    });
  });

  // ── subspan (instance method) ────────────────────────────────────────────────
  group('Span — subspan (instance method)', () {
    test('middle slice', () {
      final s = Span([10, 20, 30, 40, 50]);
      expect(s.subspan(1, 3).toList(), [20, 30, 40]);
    });

    test('omitting count extends to end', () {
      final s = Span([10, 20, 30, 40, 50]);
      expect(s.subspan(3).toList(), [40, 50]);
    });

    test('subspan(0) is the full span', () {
      final s = Span([1, 2, 3]);
      expect(s.subspan(0).toList(), [1, 2, 3]);
    });

    test('subspan of a subspan', () {
      final s = Span([10, 20, 30, 40, 50]);
      final mid = s.subspan(1, 3); // [20, 30, 40]
      expect(mid.subspan(1, 1).toList(), [30]);
    });

    test('throws RangeError when out of bounds', () {
      final s = Span([1, 2, 3]);
      expect(() => s.subspan(2, 2), throwsRangeError);
    });

    test('throws RangeError for negative offset', () {
      final s = Span([1, 2, 3]);
      expect(() => s.subspan(-1), throwsRangeError);
    });

    test('zero-length subspan is valid', () {
      final s = Span([1, 2, 3]);
      expect(s.subspan(1, 0).isEmpty, isTrue);
    });
  });

  // ── contains ────────────────────────────────────────────────────────────────
  group('Span — contains', () {
    test('returns true for a present element', () {
      expect(Span([1, 2, 3]).contains(2), isTrue);
    });

    test('returns false for an absent element', () {
      expect(Span([1, 2, 3]).contains(99), isFalse);
    });

    test('returns false on empty span', () {
      expect(Span<int>([]).contains(1), isFalse);
    });

    test('only checks within the span window', () {
      final s = Span.subspan([10, 20, 30, 40], 1, 2); // [20, 30]
      expect(s.contains(10), isFalse);
      expect(s.contains(40), isFalse);
      expect(s.contains(20), isTrue);
    });
  });

  // ── indexOf ──────────────────────────────────────────────────────────────────
  group('Span — indexOf', () {
    test('returns index of first occurrence', () {
      expect(Span([10, 20, 30, 20]).indexOf(20), 1);
    });

    test('returns -1 when element is absent', () {
      expect(Span([1, 2, 3]).indexOf(99), -1);
    });

    test('respects start parameter', () {
      expect(Span([10, 20, 30, 20]).indexOf(20, 2), 3);
    });

    test('start beyond length returns -1', () {
      expect(Span([1, 2, 3]).indexOf(2, 10), -1);
    });

    test('negative start treated as 0', () {
      expect(Span([10, 20, 30]).indexOf(10, -5), 0);
    });

    test('index is relative to span start', () {
      final s = Span.subspan([10, 20, 30, 20], 1, 3); // [20, 30, 20]
      expect(s.indexOf(20), 0);
      expect(s.indexOf(20, 1), 2);
    });
  });

  // ── toList ───────────────────────────────────────────────────────────────────
  group('Span — toList', () {
    test('produces a copy of the elements', () {
      final src = [1, 2, 3, 4, 5];
      final s = Span(src);
      final list = s.toList();
      expect(list, [1, 2, 3, 4, 5]);

      // Mutating the copy does not affect the source
      list[0] = 99;
      expect(src[0], 1);
    });

    test('toList on a subspan copies only the window', () {
      final s = Span.subspan([10, 20, 30, 40, 50], 1, 3);
      expect(s.toList(), [20, 30, 40]);
    });

    test('growable: false returns an unmodifiable list', () {
      final s = Span([1, 2, 3]);
      final list = s.toList(growable: false);
      expect(() => list.add(4), throwsUnsupportedError);
    });
  });

  // ── Iterable integration ─────────────────────────────────────────────────────
  group('Span — Iterable integration', () {
    test('for-in loop iterates all elements', () {
      final results = <int>[];
      for (final e in Span([1, 2, 3])) {
        results.add(e);
      }
      expect(results, [1, 2, 3]);
    });

    test('map works correctly', () {
      final s = Span([1, 2, 3]);
      expect(s.map((e) => e * 2).toList(), [2, 4, 6]);
    });

    test('where filters elements', () {
      final s = Span([1, 2, 3, 4, 5]);
      expect(s.where((e) => e.isEven).toList(), [2, 4]);
    });

    test('reduce sums elements', () {
      final s = Span([1, 2, 3, 4, 5]);
      expect(s.reduce((a, b) => a + b), 15);
    });

    test('fold with initial value', () {
      final s = Span([1, 2, 3]);
      expect(s.fold(10, (acc, e) => acc + e), 16);
    });

    test('empty span has empty iterator', () {
      final s = Span<int>([]);
      expect(s.toList(), isEmpty);
    });

    test('subspan iterates only its window', () {
      final s = Span.subspan([10, 20, 30, 40, 50], 1, 3);
      expect(s.toList(), [20, 30, 40]);
    });
  });

  // ── Equality & hashCode ──────────────────────────────────────────────────────
  group('Span — equality and hashCode', () {
    test('equal spans produce true', () {
      final a = Span([1, 2, 3]);
      final b = Span([1, 2, 3]);
      expect(a == b, isTrue);
    });

    test('same elements in different windows are equal', () {
      final a = Span([1, 2, 3, 4, 5]).subspan(1, 3); // [2, 3, 4]
      final b = Span([2, 3, 4]);
      expect(a == b, isTrue);
    });

    test('different elements produce false', () {
      expect(Span([1, 2, 3]) == Span([1, 2, 4]), isFalse);
    });

    test('different lengths produce false', () {
      expect(Span([1, 2]) == Span([1, 2, 3]), isFalse);
    });

    test('identical span is equal to itself', () {
      final s = Span([1, 2, 3]);
      expect(s == s, isTrue);
    });

    test('equal spans have equal hashCodes', () {
      final a = Span([1, 2, 3]);
      final b = Span([1, 2, 3]);
      expect(a.hashCode, b.hashCode);
    });
  });

  // ── toString ─────────────────────────────────────────────────────────────────
  group('Span — toString', () {
    test('formats int elements correctly', () {
      expect(Span([1, 2, 3]).toString(), 'Span[1, 2, 3]');
    });

    test('formats empty span correctly', () {
      expect(Span<int>([]).toString(), 'Span[]');
    });

    test('formats subspan correctly', () {
      final s = Span.subspan([10, 20, 30, 40], 1, 2);
      expect(s.toString(), 'Span[20, 30]');
    });
  });

  // ── Zero-copy guarantee ───────────────────────────────────────────────────────
  group('Span — zero-copy guarantee', () {
    test('mutation of source is reflected in span', () {
      final src = [1, 2, 3];
      final s = Span(src);
      src[1] = 99;
      expect(s[1], 99);
    });

    test('subspan reflects mutations to source', () {
      final src = [10, 20, 30, 40];
      final s = Span.subspan(src, 1, 2); // [20, 30]
      src[2] = 99;
      expect(s[1], 99);
    });

    test('chained subspans share the same source', () {
      final src = [1, 2, 3, 4, 5];
      final a = Span(src).subspan(1); // [2, 3, 4, 5]
      final b = a.subspan(1, 2); // [3, 4]
      src[2] = 77;
      expect(b[0], 77);
    });
  });
}
