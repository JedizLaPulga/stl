import 'package:test/test.dart';
import 'package:stl/stl.dart';

void main() {
  group('Chrono Tests', () {
    test('SystemClock.now() returns current time', () {
      final t1 = SystemClock.now();
      final now = DateTime.now();
      // Ensure it's very close
      final diff = t1.timeSinceEpoch.inMicroseconds - now.microsecondsSinceEpoch;
      expect(diff.abs(), lessThan(100000)); // Within 100ms
    });

    test('SteadyClock.now() returns monotonic time', () async {
      final t1 = SteadyClock.now();
      await Future.delayed(const Duration(milliseconds: 50));
      final t2 = SteadyClock.now();
      expect(t2 > t1, isTrue);
      
      final diff = t2 - t1;
      expect(diff.inMilliseconds, greaterThanOrEqualTo(40)); // Allow some scheduling slop
    });

    test('TimePoint operations', () {
      final t1 = TimePoint(const Duration(seconds: 10));
      final t2 = TimePoint(const Duration(seconds: 15));
      
      expect(t2 - t1, equals(const Duration(seconds: 5)));
      expect(t1 + const Duration(seconds: 5), equals(t2));
      
      expect(t1 < t2, isTrue);
      expect(t2 > t1, isTrue);
      expect(t1 <= t2, isTrue);
      expect(t2 >= t1, isTrue);
      expect(t1 == TimePoint(const Duration(seconds: 10)), isTrue);
    });

    test('ChronoIntExtension duration helpers', () {
      expect(10.microseconds, equals(const Duration(microseconds: 10)));
      expect(15.milliseconds, equals(const Duration(milliseconds: 15)));
      expect(2.seconds, equals(const Duration(seconds: 2)));
      expect(5.minutes, equals(const Duration(minutes: 5)));
      expect(3.hours, equals(const Duration(hours: 3)));
    });
  });
}
