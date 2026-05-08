// Tests for chrono/timer.dart (CountdownTimer, Ticker) and the new
// DurationExtension / ChronoIntExtension additions in chrono.dart.
import 'package:test/test.dart';
import 'package:stl/stl.dart';

void main() {
  // --------------------------------------------------------------------------
  // CountdownTimer
  // --------------------------------------------------------------------------
  group('CountdownTimer - construction', () {
    test('positive duration constructs successfully', () {
      expect(() => CountdownTimer(const Duration(seconds: 5)), returnsNormally);
    });

    test('zero duration throws ArgumentError', () {
      expect(() => CountdownTimer(Duration.zero), throwsArgumentError);
    });

    test('negative duration throws ArgumentError', () {
      expect(
        () => CountdownTimer(const Duration(seconds: -1)),
        throwsArgumentError,
      );
    });
  });

  group('CountdownTimer - state before start', () {
    test('isStarted is false', () {
      final t = CountdownTimer(const Duration(seconds: 5));
      expect(t.isStarted, isFalse);
    });

    test('isExpired is false', () {
      final t = CountdownTimer(const Duration(seconds: 5));
      expect(t.isExpired, isFalse);
    });

    test('remaining equals total', () {
      final t = CountdownTimer(const Duration(seconds: 5));
      expect(t.remaining, const Duration(seconds: 5));
    });

    test('elapsed is zero', () {
      final t = CountdownTimer(const Duration(seconds: 5));
      expect(t.elapsed, Duration.zero);
    });

    test('progress is 0.0', () {
      final t = CountdownTimer(const Duration(seconds: 5));
      expect(t.progress, 0.0);
    });
  });

  group('CountdownTimer - after start', () {
    test('isStarted becomes true', () {
      final t = CountdownTimer(const Duration(seconds: 5))..start();
      expect(t.isStarted, isTrue);
    });

    test('elapsed grows after start', () async {
      final t = CountdownTimer(const Duration(seconds: 5))..start();
      await Future.delayed(const Duration(milliseconds: 30));
      expect(t.elapsed.inMilliseconds, greaterThan(0));
    });

    test('remaining decreases after start', () async {
      const total = Duration(seconds: 5);
      final t = CountdownTimer(total)..start();
      await Future.delayed(const Duration(milliseconds: 30));
      expect(t.remaining < total, isTrue);
    });

    test('progress is in [0, 1]', () async {
      final t = CountdownTimer(const Duration(seconds: 1))..start();
      await Future.delayed(const Duration(milliseconds: 50));
      expect(t.progress, greaterThan(0.0));
      expect(t.progress, lessThanOrEqualTo(1.0));
    });

    test('isExpired becomes true after timer duration passes', () async {
      final t = CountdownTimer(const Duration(milliseconds: 30))..start();
      await Future.delayed(const Duration(milliseconds: 60));
      expect(t.isExpired, isTrue);
    });

    test('remaining is Duration.zero once expired', () async {
      final t = CountdownTimer(const Duration(milliseconds: 20))..start();
      await Future.delayed(const Duration(milliseconds: 50));
      expect(t.remaining, Duration.zero);
    });

    test('progress is 1.0 once expired', () async {
      final t = CountdownTimer(const Duration(milliseconds: 20))..start();
      await Future.delayed(const Duration(milliseconds: 60));
      expect(t.progress, 1.0);
    });
  });

  group('CountdownTimer - reset', () {
    test('reset clears started state', () async {
      final t = CountdownTimer(const Duration(seconds: 5))..start();
      await Future.delayed(const Duration(milliseconds: 20));
      t.reset();
      expect(t.isStarted, isFalse);
    });

    test('after reset remaining is total again', () async {
      const total = Duration(seconds: 5);
      final t = CountdownTimer(total)..start();
      await Future.delayed(const Duration(milliseconds: 20));
      t.reset();
      expect(t.remaining, total);
    });
  });

  group('CountdownTimer - toString', () {
    test('contains percentage', () async {
      final t = CountdownTimer(const Duration(seconds: 1))..start();
      await Future.delayed(const Duration(milliseconds: 10));
      expect(t.toString(), contains('%'));
    });
  });

  // --------------------------------------------------------------------------
  // Ticker
  // --------------------------------------------------------------------------
  group('Ticker - construction', () {
    test('positive interval constructs successfully', () {
      expect(() => Ticker(const Duration(milliseconds: 100)), returnsNormally);
    });

    test('zero interval throws ArgumentError', () {
      expect(() => Ticker(Duration.zero), throwsArgumentError);
    });

    test('negative interval throws ArgumentError', () {
      expect(
        () => Ticker(const Duration(milliseconds: -1)),
        throwsArgumentError,
      );
    });
  });

  group('Ticker - tick stream', () {
    test('tick() returns a Stream', () {
      final ticker = Ticker(const Duration(milliseconds: 50));
      expect(ticker.tick(), isA<Stream<Duration>>());
    });

    test('tick() returns same stream on repeated calls', () {
      final ticker = Ticker(const Duration(milliseconds: 50));
      expect(identical(ticker.tick(), ticker.tick()), isTrue);
    });

    test('stream emits Duration values', () async {
      final ticker = Ticker(const Duration(milliseconds: 30));
      final first = await ticker.tick().first;
      expect(first, isA<Duration>());
    });

    test('first emission equals one interval', () async {
      const interval = Duration(milliseconds: 30);
      final ticker = Ticker(interval);
      final first = await ticker.tick().first;
      expect(first, interval);
    });

    test('second emission equals two intervals', () async {
      const interval = Duration(milliseconds: 30);
      final ticker = Ticker(interval);
      final second = await ticker.tick().skip(1).first;
      expect(second, interval * 2);
    });
  });

  // --------------------------------------------------------------------------
  // DurationExtension — humanReadable
  // --------------------------------------------------------------------------
  group('DurationExtension - humanReadable', () {
    test('zero duration is "0s"', () {
      expect(Duration.zero.humanReadable(), '0s');
    });

    test('pure seconds', () {
      expect(const Duration(seconds: 45).humanReadable(), '45s');
    });

    test('hours, minutes, seconds', () {
      expect(
        const Duration(hours: 2, minutes: 30, seconds: 5).humanReadable(),
        '2h 30m 5s',
      );
    });

    test('days only', () {
      expect(const Duration(days: 3).humanReadable(), '3d');
    });

    test('days and hours', () {
      expect(const Duration(days: 1, hours: 12).humanReadable(), '1d 12h');
    });

    test('milliseconds only', () {
      expect(const Duration(milliseconds: 250).humanReadable(), '250ms');
    });

    test('mixed seconds and milliseconds', () {
      expect(
        const Duration(seconds: 1, milliseconds: 500).humanReadable(),
        '1s 500ms',
      );
    });

    test('negative duration prefixed with -', () {
      expect(const Duration(seconds: -5).humanReadable(), '-5s');
    });
  });

  // --------------------------------------------------------------------------
  // DurationExtension — toIso8601
  // --------------------------------------------------------------------------
  group('DurationExtension - toIso8601', () {
    test('zero duration is "PT0S"', () {
      expect(Duration.zero.toIso8601(), 'PT0S');
    });

    test('2h30m5s → PT2H30M5S', () {
      expect(
        const Duration(hours: 2, minutes: 30, seconds: 5).toIso8601(),
        'PT2H30M5S',
      );
    });

    test('3 days → P3D', () {
      expect(const Duration(days: 3).toIso8601(), 'P3D');
    });

    test('negative 5s → -PT5S', () {
      expect(const Duration(seconds: -5).toIso8601(), '-PT5S');
    });

    test('fractional seconds → includes decimal', () {
      final iso = const Duration(seconds: 1, milliseconds: 500).toIso8601();
      expect(iso, contains('1.5'));
    });

    test('1 day 2 hours 30 minutes → P1DT2H30M', () {
      expect(
        const Duration(days: 1, hours: 2, minutes: 30).toIso8601(),
        'P1DT2H30M',
      );
    });
  });

  // --------------------------------------------------------------------------
  // DurationExtension — floor
  // --------------------------------------------------------------------------
  group('DurationExtension - floor', () {
    test('exact multiple floors to itself', () {
      expect(
        const Duration(seconds: 10).floor(const Duration(seconds: 5)),
        const Duration(seconds: 10),
      );
    });

    test('positive non-multiple floors down', () {
      expect(
        const Duration(seconds: 7).floor(const Duration(seconds: 5)),
        const Duration(seconds: 5),
      );
    });

    test('negative floors toward negative infinity', () {
      expect(
        const Duration(seconds: -7).floor(const Duration(seconds: 5)),
        const Duration(seconds: -10),
      );
    });

    test('zero duration floors to zero', () {
      expect(Duration.zero.floor(const Duration(seconds: 5)), Duration.zero);
    });

    test('zero period throws ArgumentError', () {
      expect(
        () => const Duration(seconds: 7).floor(Duration.zero),
        throwsArgumentError,
      );
    });
  });

  // --------------------------------------------------------------------------
  // DurationExtension — ceil
  // --------------------------------------------------------------------------
  group('DurationExtension - ceil', () {
    test('exact multiple ceils to itself', () {
      expect(
        const Duration(seconds: 10).ceil(const Duration(seconds: 5)),
        const Duration(seconds: 10),
      );
    });

    test('positive non-multiple ceils up', () {
      expect(
        const Duration(seconds: 7).ceil(const Duration(seconds: 5)),
        const Duration(seconds: 10),
      );
    });

    test('negative ceils toward zero (positive infinity)', () {
      expect(
        const Duration(seconds: -7).ceil(const Duration(seconds: 5)),
        const Duration(seconds: -5),
      );
    });

    test('zero period throws ArgumentError', () {
      expect(
        () => const Duration(seconds: 7).ceil(Duration.zero),
        throwsArgumentError,
      );
    });
  });

  // --------------------------------------------------------------------------
  // DurationExtension — round
  // --------------------------------------------------------------------------
  group('DurationExtension - round', () {
    test('rounds down when closer to lower multiple', () {
      expect(
        const Duration(seconds: 6).round(const Duration(seconds: 5)),
        const Duration(seconds: 5),
      );
    });

    test('rounds up when closer to upper multiple', () {
      expect(
        const Duration(seconds: 8).round(const Duration(seconds: 5)),
        const Duration(seconds: 10),
      );
    });

    test('exact multiple rounds to itself', () {
      expect(
        const Duration(seconds: 10).round(const Duration(seconds: 5)),
        const Duration(seconds: 10),
      );
    });

    test('zero period throws ArgumentError', () {
      expect(
        () => const Duration(seconds: 7).round(Duration.zero),
        throwsArgumentError,
      );
    });
  });

  // --------------------------------------------------------------------------
  // DurationExtension — isPositive
  // --------------------------------------------------------------------------
  group('DurationExtension - isPositive', () {
    test('positive duration is positive', () {
      expect(const Duration(seconds: 1).isPositive, isTrue);
    });

    test('zero is not positive', () {
      expect(Duration.zero.isPositive, isFalse);
    });

    test('negative is not positive', () {
      expect(const Duration(seconds: -1).isPositive, isFalse);
    });
  });

  // --------------------------------------------------------------------------
  // ChronoIntExtension — new days and weeks
  // --------------------------------------------------------------------------
  group('ChronoIntExtension - days & weeks', () {
    test('1.days equals Duration(days: 1)', () {
      expect(1.days, const Duration(days: 1));
    });

    test('7.days equals 1.weeks', () {
      expect(7.days, 1.weeks);
    });

    test('2.weeks equals Duration(days: 14)', () {
      expect(2.weeks, const Duration(days: 14));
    });

    test('0.days is Duration.zero', () {
      expect(0.days, Duration.zero);
    });

    test('0.weeks is Duration.zero', () {
      expect(0.weeks, Duration.zero);
    });

    test('negative days work', () {
      expect((-3).days, const Duration(days: -3));
    });
  });
}
