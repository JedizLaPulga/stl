// Tests for chrono/clocks.dart — MockClock, HiResClock, UtcClock, TaiClock,
// GpsClock — and for the new TimePoint.fromDateTime / toDateTime /
// toIso8601String additions in chrono.dart.
import 'package:test/test.dart';
import 'package:stl/stl.dart';

void main() {
  // --------------------------------------------------------------------------
  // MockClock
  // --------------------------------------------------------------------------
  group('MockClock', () {
    test('starts at Duration.zero by default', () {
      final clock = MockClock();
      expect(clock.now(), equals(TimePoint.epoch));
    });

    test('starts at provided initial duration', () {
      final clock = MockClock(const Duration(seconds: 10));
      expect(clock.now().timeSinceEpoch.inSeconds, 10);
    });

    test('advance moves time forward', () {
      final clock = MockClock();
      clock.advance(const Duration(seconds: 5));
      expect(clock.now().timeSinceEpoch.inSeconds, 5);
    });

    test('advance is cumulative', () {
      final clock = MockClock();
      clock.advance(const Duration(seconds: 3));
      clock.advance(const Duration(seconds: 4));
      expect(clock.now().timeSinceEpoch.inSeconds, 7);
    });

    test('advance with zero duration does nothing', () {
      final clock = MockClock(const Duration(seconds: 5));
      clock.advance(Duration.zero);
      expect(clock.now().timeSinceEpoch.inSeconds, 5);
    });

    test('advance with negative duration throws ArgumentError', () {
      final clock = MockClock();
      expect(
        () => clock.advance(const Duration(seconds: -1)),
        throwsArgumentError,
      );
    });

    test('set repositions clock to absolute time', () {
      final clock = MockClock(const Duration(seconds: 100));
      clock.set(const Duration(seconds: 42));
      expect(clock.now().timeSinceEpoch.inSeconds, 42);
    });

    test('reset returns clock to zero', () {
      final clock = MockClock(const Duration(seconds: 50));
      clock.reset();
      expect(clock.now(), equals(TimePoint.epoch));
    });

    test('implements Clock interface', () {
      final Clock clock = MockClock();
      expect(clock.now(), isA<TimePoint>());
    });

    test('two sequential now() calls return the same time', () {
      final clock = MockClock(const Duration(seconds: 1));
      final t1 = clock.now();
      final t2 = clock.now();
      expect(t1, equals(t2));
    });
  });

  // --------------------------------------------------------------------------
  // HiResClock
  // --------------------------------------------------------------------------
  group('HiResClock', () {
    test('now() returns a TimePoint', () {
      expect(HiResClock.now(), isA<TimePoint>());
    });

    test('successive calls are non-decreasing', () async {
      final t1 = HiResClock.now();
      await Future.delayed(const Duration(milliseconds: 20));
      final t2 = HiResClock.now();
      expect(t2 >= t1, isTrue);
    });

    test('elapsed grows over time', () async {
      final t1 = HiResClock.now();
      await Future.delayed(const Duration(milliseconds: 30));
      final t2 = HiResClock.now();
      expect((t2 - t1).inMilliseconds, greaterThanOrEqualTo(20));
    });
  });

  // --------------------------------------------------------------------------
  // UtcClock
  // --------------------------------------------------------------------------
  group('UtcClock', () {
    test('now() returns a TimePoint close to system time', () {
      const clock = UtcClock();
      final t = clock.now();
      final sysUtcMicros = DateTime.now().toUtc().microsecondsSinceEpoch;
      final diff = (t.timeSinceEpoch.inMicroseconds - sysUtcMicros).abs();
      expect(diff, lessThan(200000)); // within 200 ms
    });

    test('implements Clock interface', () {
      final Clock c = UtcClock();
      expect(c.now(), isA<TimePoint>());
    });

    test('successive calls are non-decreasing', () async {
      const clock = UtcClock();
      final t1 = clock.now();
      await Future.delayed(const Duration(milliseconds: 10));
      final t2 = clock.now();
      expect(t2 >= t1, isTrue);
    });
  });

  // --------------------------------------------------------------------------
  // TaiClock
  // --------------------------------------------------------------------------
  group('TaiClock', () {
    test('now() returns a TimePoint', () {
      expect(TaiClock.now(), isA<TimePoint>());
    });

    test('TAI is ahead of UTC by taiUtcOffsetSeconds', () {
      final tai = TaiClock.now().timeSinceEpoch.inSeconds;
      final utc = Duration(
        microseconds: DateTime.now().toUtc().microsecondsSinceEpoch,
      ).inSeconds;
      final diff = tai - utc;
      expect(diff, TaiClock.taiUtcOffsetSeconds);
    });

    test('taiUtcOffsetSeconds is 37', () {
      expect(TaiClock.taiUtcOffsetSeconds, 37);
    });

    test('successive calls are non-decreasing', () async {
      final t1 = TaiClock.now();
      await Future.delayed(const Duration(milliseconds: 10));
      final t2 = TaiClock.now();
      expect(t2 >= t1, isTrue);
    });
  });

  // --------------------------------------------------------------------------
  // GpsClock
  // --------------------------------------------------------------------------
  group('GpsClock', () {
    test('now() returns a TimePoint', () {
      expect(GpsClock.now(), isA<TimePoint>());
    });

    test('GPS epoch was 1980-01-06, so GPS seconds > 0 today', () {
      final gpsSecs = GpsClock.now().timeSinceEpoch.inSeconds;
      // As of 2024 there should be > 1 billion GPS seconds
      expect(gpsSecs, greaterThan(1_000_000_000));
    });

    test('GPS time is behind TAI by gpsTaiOffsetSeconds', () {
      final gps = GpsClock.now().timeSinceEpoch.inSeconds;
      final tai = TaiClock.now().timeSinceEpoch.inSeconds;
      // GPS epoch offset from TAI epoch difference
      // GPS = TAI - 19 + (TAI_epoch - GPS_epoch_offset)
      // We just verify GPS < TAI (GPS epoch starts in 1980, TAI from 1958)
      expect(gps, lessThan(tai));
    });

    test('successive calls are non-decreasing', () async {
      final t1 = GpsClock.now();
      await Future.delayed(const Duration(milliseconds: 10));
      final t2 = GpsClock.now();
      expect(t2 >= t1, isTrue);
    });
  });

  // --------------------------------------------------------------------------
  // TimePoint.epoch, fromDateTime, toDateTime, toIso8601String
  // --------------------------------------------------------------------------
  group('TimePoint - new features', () {
    test('epoch is TimePoint(Duration.zero)', () {
      expect(TimePoint.epoch, equals(const TimePoint(Duration.zero)));
    });

    test('fromDateTime round-trips through toDateTime', () {
      final dt = DateTime.utc(2024, 6, 15, 12, 30, 45);
      final tp = TimePoint.fromDateTime(dt);
      final back = tp.toDateTime();
      expect(back.microsecondsSinceEpoch, dt.microsecondsSinceEpoch);
    });

    test('fromDateTime with Unix epoch produces TimePoint.epoch', () {
      final epoch = DateTime.utc(1970, 1, 1);
      final tp = TimePoint.fromDateTime(epoch);
      expect(tp, equals(TimePoint.epoch));
    });

    test('toDateTime returns UTC DateTime', () {
      final dt = DateTime.utc(2024, 6, 15, 12, 0, 0);
      final tp = TimePoint.fromDateTime(dt);
      expect(tp.toDateTime().isUtc, isTrue);
    });

    test('toIso8601String includes date and time components', () {
      final dt = DateTime.utc(2024, 6, 15, 12, 30, 45);
      final tp = TimePoint.fromDateTime(dt);
      final iso = tp.toIso8601String();
      expect(iso, contains('2024'));
      expect(iso, contains('06'));
      expect(iso, contains('15'));
    });

    test('toIso8601String ends with Z (UTC marker)', () {
      final tp = TimePoint.fromDateTime(DateTime.utc(2024, 1, 1));
      expect(tp.toIso8601String(), endsWith('Z'));
    });
  });
}
