// v0.6.4 Extended Chrono Tests
// Covers gaps identified in the audit: hashCode, negative duration subtraction,
// toString, days extension, compareTo, and reflexive equality.
import 'package:test/test.dart';
import 'package:stl/stl.dart';

void main() {
  group('TimePoint - equality and hashCode', () {
    test('identical TimePoints are equal', () {
      const t = TimePoint(Duration(seconds: 10));
      expect(t == t, isTrue);
    });

    test('TimePoints with same duration are equal', () {
      final t1 = TimePoint(const Duration(milliseconds: 500));
      final t2 = TimePoint(const Duration(milliseconds: 500));
      expect(t1, equals(t2));
    });

    test('TimePoints with different durations are not equal', () {
      final t1 = TimePoint(const Duration(seconds: 1));
      final t2 = TimePoint(const Duration(seconds: 2));
      expect(t1, isNot(equals(t2)));
    });

    test('equal TimePoints have equal hashCodes', () {
      final t1 = TimePoint(const Duration(seconds: 5));
      final t2 = TimePoint(const Duration(seconds: 5));
      expect(t1.hashCode, equals(t2.hashCode));
    });

    test('TimePoint is not equal to non-TimePoint', () {
      final t = TimePoint(const Duration(seconds: 1));
      // ignore: unrelated_type_equality_checks
      expect(t == 'not a TimePoint', isFalse);
    });
  });

  group('TimePoint - arithmetic and comparison', () {
    test('subtraction yields negative duration when t1 < t2', () {
      final t1 = TimePoint(const Duration(seconds: 3));
      final t2 = TimePoint(const Duration(seconds: 10));
      final diff = t1 - t2;
      expect(diff.isNegative, isTrue);
      expect(diff.inSeconds, equals(-7));
    });

    test('subtraction of equal TimePoints yields zero duration', () {
      final t = TimePoint(const Duration(minutes: 1));
      expect((t - t).inSeconds, equals(0));
    });

    test('addition produces correct future TimePoint', () {
      final t = TimePoint(const Duration(seconds: 5));
      final result = t + const Duration(seconds: 3);
      expect(result, equals(TimePoint(const Duration(seconds: 8))));
    });

    test('compareTo returns 0 for equal TimePoints', () {
      final t = TimePoint(const Duration(seconds: 1));
      expect(t.compareTo(t), equals(0));
    });

    test('compareTo returns negative when this < other', () {
      final t1 = TimePoint(const Duration(seconds: 1));
      final t2 = TimePoint(const Duration(seconds: 2));
      expect(t1.compareTo(t2), isNegative);
    });

    test('compareTo returns positive when this > other', () {
      final t1 = TimePoint(const Duration(seconds: 5));
      final t2 = TimePoint(const Duration(seconds: 3));
      expect(t1.compareTo(t2), isPositive);
    });

    test('relational operators <= and >= with equal values', () {
      final t = TimePoint(const Duration(seconds: 10));
      expect(t <= t, isTrue);
      expect(t >= t, isTrue);
      expect(t < t, isFalse);
      expect(t > t, isFalse);
    });
  });

  group('TimePoint - toString', () {
    test('toString includes the duration representation', () {
      final t = TimePoint(const Duration(seconds: 42));
      expect(t.toString(), contains('42'));
    });

    test('toString starts with TimePoint(', () {
      final t = TimePoint(const Duration(milliseconds: 100));
      expect(t.toString(), startsWith('TimePoint('));
    });
  });

  group('ChronoIntExtension - edge cases', () {
    test('0.microseconds is zero duration', () {
      expect(0.microseconds, equals(Duration.zero));
    });

    test('0.milliseconds is zero duration', () {
      expect(0.milliseconds, equals(Duration.zero));
    });

    test('0.seconds is zero duration', () {
      expect(0.seconds, equals(Duration.zero));
    });

    test('0.minutes is zero duration', () {
      expect(0.minutes, equals(Duration.zero));
    });

    test('0.hours is zero duration', () {
      expect(0.hours, equals(Duration.zero));
    });

    test('negative duration helpers work correctly', () {
      expect((-5).seconds, equals(const Duration(seconds: -5)));
      expect((-100).milliseconds, equals(const Duration(milliseconds: -100)));
    });
  });

  group('SteadyClock - monotonicity invariant', () {
    test('SteadyClock.now() never returns earlier than a previous call', () {
      final t1 = SteadyClock.now();
      final t2 = SteadyClock.now();
      // May be equal (within the same microsecond) but must not decrease
      expect(t2 >= t1, isTrue);
    });
  });
}
