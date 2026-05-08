// Tests for chrono/lap_stopwatch.dart — LapRecord, LapStopwatch.
import 'package:test/test.dart';
import 'package:stl/stl.dart';

void main() {
  // --------------------------------------------------------------------------
  // LapRecord
  // --------------------------------------------------------------------------
  group('LapRecord', () {
    test('stores all fields correctly', () {
      const rec = LapRecord(
        number: 1,
        elapsed: Duration(seconds: 5),
        lapTime: Duration(seconds: 5),
      );
      expect(rec.number, 1);
      expect(rec.elapsed, const Duration(seconds: 5));
      expect(rec.lapTime, const Duration(seconds: 5));
    });

    test('toString includes lap number', () {
      const rec = LapRecord(
        number: 3,
        elapsed: Duration(seconds: 30),
        lapTime: Duration(seconds: 10),
      );
      expect(rec.toString(), contains('3'));
    });
  });

  // --------------------------------------------------------------------------
  // LapStopwatch — lifecycle
  // --------------------------------------------------------------------------
  group('LapStopwatch - lifecycle', () {
    test('starts not running', () {
      final sw = LapStopwatch();
      expect(sw.isRunning, isFalse);
    });

    test('start sets isRunning to true', () {
      final sw = LapStopwatch()..start();
      expect(sw.isRunning, isTrue);
      sw.stop();
    });

    test('stop sets isRunning to false', () {
      final sw = LapStopwatch()
        ..start()
        ..stop();
      expect(sw.isRunning, isFalse);
    });

    test('elapsed is zero before start', () {
      final sw = LapStopwatch();
      expect(sw.elapsed, Duration.zero);
    });

    test('elapsed grows after start', () async {
      final sw = LapStopwatch()..start();
      await Future.delayed(const Duration(milliseconds: 30));
      expect(sw.elapsed.inMilliseconds, greaterThan(0));
      sw.stop();
    });

    test('reset clears elapsed and laps', () async {
      final sw = LapStopwatch()..start();
      await Future.delayed(const Duration(milliseconds: 20));
      sw.lap();
      sw.stop();
      sw.reset();
      expect(sw.elapsed, Duration.zero);
      expect(sw.laps, isEmpty);
      expect(sw.isRunning, isFalse);
    });
  });

  // --------------------------------------------------------------------------
  // LapStopwatch — lap recording
  // --------------------------------------------------------------------------
  group('LapStopwatch - laps', () {
    test('no laps recorded initially', () {
      expect(LapStopwatch().laps, isEmpty);
    });

    test('lap returns LapRecord with correct number', () async {
      final sw = LapStopwatch()..start();
      await Future.delayed(const Duration(milliseconds: 10));
      final rec = sw.lap();
      sw.stop();
      expect(rec.number, 1);
    });

    test('second lap has number 2', () async {
      final sw = LapStopwatch()..start();
      await Future.delayed(const Duration(milliseconds: 10));
      sw.lap();
      await Future.delayed(const Duration(milliseconds: 10));
      final rec = sw.lap();
      sw.stop();
      expect(rec.number, 2);
    });

    test('laps list length matches recorded laps', () async {
      final sw = LapStopwatch()..start();
      for (var i = 0; i < 3; i++) {
        await Future.delayed(const Duration(milliseconds: 10));
        sw.lap();
      }
      sw.stop();
      expect(sw.laps.length, 3);
    });

    test('lap elapsed is non-decreasing', () async {
      final sw = LapStopwatch()..start();
      await Future.delayed(const Duration(milliseconds: 10));
      final r1 = sw.lap();
      await Future.delayed(const Duration(milliseconds: 10));
      final r2 = sw.lap();
      sw.stop();
      expect(r2.elapsed >= r1.elapsed, isTrue);
    });

    test('sum of lapTimes approximates total elapsed', () async {
      final sw = LapStopwatch()..start();
      await Future.delayed(const Duration(milliseconds: 20));
      sw.lap();
      await Future.delayed(const Duration(milliseconds: 20));
      sw.lap();
      sw.stop();
      final total = sw.laps.fold(Duration.zero, (acc, r) => acc + r.lapTime);
      // Allow ±20ms scheduling slack
      expect(
        (total.inMicroseconds - sw.laps.last.elapsed.inMicroseconds).abs(),
        lessThan(20000),
      );
    });

    test('laps returns unmodifiable list', () async {
      final sw = LapStopwatch()..start();
      await Future.delayed(const Duration(milliseconds: 10));
      sw.lap();
      sw.stop();
      expect(() => sw.laps.add(sw.laps.first), throwsUnsupportedError);
    });

    test('currentLapElapsed resets after lap()', () async {
      final sw = LapStopwatch()..start();
      await Future.delayed(const Duration(milliseconds: 20));
      final beforeLap = sw.currentLapElapsed;
      sw.lap();
      final afterLap = sw.currentLapElapsed;
      sw.stop();
      expect(beforeLap.inMicroseconds, greaterThan(0));
      expect(afterLap.inMicroseconds, lessThan(beforeLap.inMicroseconds));
    });
  });

  // --------------------------------------------------------------------------
  // LapStopwatch — statistics
  // --------------------------------------------------------------------------
  group('LapStopwatch - statistics', () {
    test('fastestLap is null with no laps', () {
      expect(LapStopwatch().fastestLap, isNull);
    });

    test('slowestLap is null with no laps', () {
      expect(LapStopwatch().slowestLap, isNull);
    });

    test('averageLap is null with no laps', () {
      expect(LapStopwatch().averageLap, isNull);
    });

    test('fastestLap == slowestLap with single lap', () async {
      final sw = LapStopwatch()..start();
      await Future.delayed(const Duration(milliseconds: 20));
      sw.lap();
      sw.stop();
      expect(sw.fastestLap, equals(sw.slowestLap));
    });

    test('fastestLap <= slowestLap with multiple laps', () async {
      final sw = LapStopwatch()..start();
      await Future.delayed(const Duration(milliseconds: 10));
      sw.lap();
      await Future.delayed(const Duration(milliseconds: 30));
      sw.lap();
      sw.stop();
      expect(sw.fastestLap! <= sw.slowestLap!, isTrue);
    });

    test('averageLap is between fastest and slowest', () async {
      final sw = LapStopwatch()..start();
      await Future.delayed(const Duration(milliseconds: 10));
      sw.lap();
      await Future.delayed(const Duration(milliseconds: 30));
      sw.lap();
      sw.stop();
      final avg = sw.averageLap!;
      expect(avg >= sw.fastestLap!, isTrue);
      expect(avg <= sw.slowestLap!, isTrue);
    });
  });

  // --------------------------------------------------------------------------
  // toString
  // --------------------------------------------------------------------------
  group('LapStopwatch - toString', () {
    test('toString mentions running state', () {
      final sw = LapStopwatch();
      expect(sw.toString(), contains('running'));
    });

    test('toString mentions laps count', () async {
      final sw = LapStopwatch()..start();
      await Future.delayed(const Duration(milliseconds: 10));
      sw.lap();
      sw.stop();
      expect(sw.toString(), contains('1'));
    });
  });
}
