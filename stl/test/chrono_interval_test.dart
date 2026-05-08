// Tests for chrono/time_interval.dart — TimeInterval.
import 'package:test/test.dart';
import 'package:stl/stl.dart';

const _t0 = TimePoint(Duration.zero);
const _t5 = TimePoint(Duration(seconds: 5));
const _t10 = TimePoint(Duration(seconds: 10));
const _t15 = TimePoint(Duration(seconds: 15));
const _t20 = TimePoint(Duration(seconds: 20));

void main() {
  // --------------------------------------------------------------------------
  // Construction
  // --------------------------------------------------------------------------
  group('TimeInterval - construction', () {
    test('valid interval constructs successfully', () {
      expect(() => TimeInterval(_t0, _t10), returnsNormally);
    });

    test('empty interval (start == end) is allowed', () {
      expect(() => TimeInterval(_t5, _t5), returnsNormally);
    });

    test('end before start throws ArgumentError', () {
      expect(() => TimeInterval(_t10, _t5), throwsArgumentError);
    });

    test('fromDuration constructs end correctly', () {
      final iv = TimeInterval.fromDuration(_t0, const Duration(seconds: 10));
      expect(iv.start, _t0);
      expect(iv.end, _t10);
    });
  });

  // --------------------------------------------------------------------------
  // Properties
  // --------------------------------------------------------------------------
  group('TimeInterval - properties', () {
    test('duration equals end - start', () {
      final iv = TimeInterval(_t0, _t10);
      expect(iv.duration, const Duration(seconds: 10));
    });

    test('isEmpty is true when start == end', () {
      expect(TimeInterval(_t5, _t5).isEmpty, isTrue);
    });

    test('isEmpty is false when interval is non-empty', () {
      expect(TimeInterval(_t0, _t10).isNotEmpty, isTrue);
    });

    test('isNotEmpty is true for non-empty interval', () {
      expect(TimeInterval(_t0, _t5).isNotEmpty, isTrue);
    });
  });

  // --------------------------------------------------------------------------
  // contains (half-open)
  // --------------------------------------------------------------------------
  group('TimeInterval - contains', () {
    final iv = TimeInterval(_t0, _t10);

    test('start point is contained', () => expect(iv.contains(_t0), isTrue));
    test('interior point is contained', () => expect(iv.contains(_t5), isTrue));
    test('end point is NOT contained (half-open)', () {
      expect(iv.contains(_t10), isFalse);
    });
    test('point before start is not contained', () {
      final before = const TimePoint(Duration(seconds: -1));
      expect(iv.contains(before), isFalse);
    });
    test('point after end is not contained', () {
      expect(iv.contains(_t15), isFalse);
    });
  });

  // --------------------------------------------------------------------------
  // containsClosed
  // --------------------------------------------------------------------------
  group('TimeInterval - containsClosed', () {
    final iv = TimeInterval(_t0, _t10);

    test('end point IS contained in closed interval', () {
      expect(iv.containsClosed(_t10), isTrue);
    });
    test('start is contained', () => expect(iv.containsClosed(_t0), isTrue));
    test('outside point not contained', () {
      expect(iv.containsClosed(_t15), isFalse);
    });
  });

  // --------------------------------------------------------------------------
  // overlaps
  // --------------------------------------------------------------------------
  group('TimeInterval - overlaps', () {
    test('overlapping intervals return true', () {
      final a = TimeInterval(_t0, _t10);
      final b = TimeInterval(_t5, _t15);
      expect(a.overlaps(b), isTrue);
      expect(b.overlaps(a), isTrue);
    });

    test('adjacent intervals (touching) do not overlap', () {
      final a = TimeInterval(_t0, _t5);
      final b = TimeInterval(_t5, _t10);
      expect(a.overlaps(b), isFalse);
    });

    test('disjoint intervals do not overlap', () {
      final a = TimeInterval(_t0, _t5);
      final b = TimeInterval(_t10, _t15);
      expect(a.overlaps(b), isFalse);
    });

    test('contained interval overlaps container', () {
      final outer = TimeInterval(_t0, _t20);
      final inner = TimeInterval(_t5, _t15);
      expect(outer.overlaps(inner), isTrue);
    });

    test('identical intervals overlap', () {
      final a = TimeInterval(_t0, _t10);
      expect(a.overlaps(a), isTrue);
    });
  });

  // --------------------------------------------------------------------------
  // intersection
  // --------------------------------------------------------------------------
  group('TimeInterval - intersection', () {
    test('returns overlap of two overlapping intervals', () {
      final a = TimeInterval(_t0, _t10);
      final b = TimeInterval(_t5, _t15);
      final result = a.intersection(b);
      expect(result, isNotNull);
      expect(result!.start, _t5);
      expect(result.end, _t10);
    });

    test('returns null for non-overlapping intervals', () {
      final a = TimeInterval(_t0, _t5);
      final b = TimeInterval(_t10, _t15);
      expect(a.intersection(b), isNull);
    });

    test('returns null for adjacent intervals', () {
      final a = TimeInterval(_t0, _t5);
      final b = TimeInterval(_t5, _t10);
      expect(a.intersection(b), isNull);
    });

    test('intersection of contained interval is the inner interval', () {
      final outer = TimeInterval(_t0, _t20);
      final inner = TimeInterval(_t5, _t15);
      final result = outer.intersection(inner);
      expect(result, equals(inner));
    });

    test('is commutative', () {
      final a = TimeInterval(_t0, _t10);
      final b = TimeInterval(_t5, _t15);
      expect(a.intersection(b), equals(b.intersection(a)));
    });
  });

  // --------------------------------------------------------------------------
  // hull
  // --------------------------------------------------------------------------
  group('TimeInterval - hull', () {
    test('hull of disjoint intervals spans both', () {
      final a = TimeInterval(_t0, _t5);
      final b = TimeInterval(_t10, _t15);
      final h = a.hull(b);
      expect(h.start, _t0);
      expect(h.end, _t15);
    });

    test('hull of overlapping intervals is the span', () {
      final a = TimeInterval(_t0, _t10);
      final b = TimeInterval(_t5, _t15);
      final h = a.hull(b);
      expect(h.start, _t0);
      expect(h.end, _t15);
    });

    test('hull of identical intervals is the same interval', () {
      final a = TimeInterval(_t0, _t10);
      expect(a.hull(a), equals(a));
    });

    test('is commutative', () {
      final a = TimeInterval(_t0, _t5);
      final b = TimeInterval(_t10, _t20);
      expect(a.hull(b), equals(b.hull(a)));
    });
  });

  // --------------------------------------------------------------------------
  // gap
  // --------------------------------------------------------------------------
  group('TimeInterval - gap', () {
    test('returns gap between disjoint intervals', () {
      final a = TimeInterval(_t0, _t5);
      final b = TimeInterval(_t10, _t15);
      final g = a.gap(b);
      expect(g, isNotNull);
      expect(g!.start, _t5);
      expect(g.end, _t10);
    });

    test('returns null for adjacent intervals', () {
      final a = TimeInterval(_t0, _t5);
      final b = TimeInterval(_t5, _t10);
      expect(a.gap(b), isNull);
    });

    test('returns null for overlapping intervals', () {
      final a = TimeInterval(_t0, _t10);
      final b = TimeInterval(_t5, _t15);
      expect(a.gap(b), isNull);
    });

    test('is commutative', () {
      final a = TimeInterval(_t0, _t5);
      final b = TimeInterval(_t10, _t15);
      expect(a.gap(b), equals(b.gap(a)));
    });
  });

  // --------------------------------------------------------------------------
  // Equality and toString
  // --------------------------------------------------------------------------
  group('TimeInterval - equality & toString', () {
    test('equal intervals are equal', () {
      final a = TimeInterval(_t0, _t10);
      final b = TimeInterval(_t0, _t10);
      expect(a, equals(b));
    });

    test('different intervals are not equal', () {
      final a = TimeInterval(_t0, _t10);
      final b = TimeInterval(_t0, _t15);
      expect(a, isNot(equals(b)));
    });

    test('equal intervals have equal hashCodes', () {
      final a = TimeInterval(_t0, _t10);
      final b = TimeInterval(_t0, _t10);
      expect(a.hashCode, b.hashCode);
    });

    test('toString contains start and end', () {
      final iv = TimeInterval(_t0, _t10);
      expect(iv.toString(), contains('TimeInterval'));
    });
  });
}
