// chrono_example.dart — comprehensive showcase of the expanded chrono module.
//
// Run with:  dart example/chrono_example.dart
import 'package:stl/stl.dart';

void main() async {
  _section('1. Duration Literals (ChronoIntExtension)');
  _durationLiterals();

  _section('2. DurationExtension — humanReadable & ISO 8601');
  _durationFormatting();

  _section('3. DurationExtension — floor / ceil / round');
  _durationRounding();

  _section('4. SystemClock & SteadyClock');
  _clocksBasic();

  _section('5. TimePoint — epoch, fromDateTime, toDateTime, toIso8601String');
  _timePointExtended();

  _section('6. MockClock — deterministic time for tests');
  _mockClock();

  _section('7. HiResClock, UtcClock, TaiClock, GpsClock');
  await _additionalClocks();

  _section('8. Calendar — Month & Weekday');
  _calendarEnums();

  _section('9. ChronoDate');
  _chronoDate();

  _section('10. ChronoTime');
  _chronoTime();

  _section('11. ChronoDateTime');
  _chronoDateTime();

  _section('12. TimeInterval');
  _timeInterval();

  _section('13. LapStopwatch');
  await _lapStopwatch();

  _section('14. CountdownTimer');
  await _countdownTimer();

  _section('15. Ticker (first 3 ticks)');
  await _ticker();
}

// ---------------------------------------------------------------------------
// 1. Duration literals
// ---------------------------------------------------------------------------
void _durationLiterals() {
  print('500.nanoseconds  → ${500.nanoseconds}');
  print('250.microseconds → ${250.microseconds}');
  print('100.milliseconds → ${100.milliseconds}');
  print('30.seconds       → ${30.seconds}');
  print('5.minutes        → ${5.minutes}');
  print('2.hours          → ${2.hours}');
  print('3.days           → ${3.days}');
  print('2.weeks          → ${2.weeks}  (= ${2.weeks.inDays} days)');
}

// ---------------------------------------------------------------------------
// 2. Duration formatting
// ---------------------------------------------------------------------------
void _durationFormatting() {
  final d1 = const Duration(hours: 2, minutes: 30, seconds: 5);
  print('humanReadable: ${d1.humanReadable()}'); // 2h 30m 5s
  print('toIso8601:     ${d1.toIso8601()}'); // PT2H30M5S

  final d2 = const Duration(days: 1, hours: 6, minutes: 30);
  print('humanReadable: ${d2.humanReadable()}'); // 1d 6h 30m
  print('toIso8601:     ${d2.toIso8601()}'); // P1DT6H30M

  final d3 = const Duration(seconds: 1, milliseconds: 500);
  print('humanReadable: ${d3.humanReadable()}'); // 1s 500ms
  print('toIso8601:     ${d3.toIso8601()}'); // PT1.5S

  final d4 = const Duration(seconds: -45);
  print('negative humanReadable: ${d4.humanReadable()}'); // -45s
  print('negative toIso8601:     ${d4.toIso8601()}'); // -PT45S

  print('Duration.zero humanReadable: ${Duration.zero.humanReadable()}');
  print('Duration.zero toIso8601:     ${Duration.zero.toIso8601()}');
}

// ---------------------------------------------------------------------------
// 3. Duration rounding
// ---------------------------------------------------------------------------
void _durationRounding() {
  const d = Duration(seconds: 7);
  const period = Duration(seconds: 5);
  print('floor(7s, 5s) = ${d.floor(period)}'); // 5s
  print('ceil(7s, 5s)  = ${d.ceil(period)}'); // 10s
  print('round(7s, 5s) = ${d.round(period)}'); // 5s
  print('round(8s, 5s) = ${const Duration(seconds: 8).round(period)}'); // 10s

  const neg = Duration(seconds: -7);
  print('floor(-7s, 5s) = ${neg.floor(period)}'); // -10s
  print('ceil(-7s, 5s)  = ${neg.ceil(period)}'); // -5s
}

// ---------------------------------------------------------------------------
// 4. Basic clocks
// ---------------------------------------------------------------------------
void _clocksBasic() {
  final t1 = SteadyClock.now();
  final t2 = SystemClock.now();
  print('SteadyClock.now()  → $t1');
  print('SystemClock.now()  → $t2');

  // Measure elapsed time
  final before = SteadyClock.now();
  var sum = 0;
  for (var i = 0; i < 1000000; i++) {
    sum += i;
  }
  final elapsed = SteadyClock.now() - before;
  print('Sum loop ($sum iterations): ${elapsed.humanReadable()} elapsed');
}

// ---------------------------------------------------------------------------
// 5. Extended TimePoint
// ---------------------------------------------------------------------------
void _timePointExtended() {
  print('TimePoint.epoch         = ${TimePoint.epoch}');

  final birthday = DateTime.utc(1991, 8, 22, 0, 0, 0);
  final tp = TimePoint.fromDateTime(birthday);
  print('fromDateTime(birthday)  = $tp');
  print('toDateTime()            = ${tp.toDateTime()}');
  print('toIso8601String()       = ${tp.toIso8601String()}');

  // Arithmetic
  final now = SystemClock.now();
  final future = now + 7.days;
  final elapsed = future - now;
  print('now + 7.days in ${elapsed.humanReadable()}');
}

// ---------------------------------------------------------------------------
// 6. MockClock
// ---------------------------------------------------------------------------
void _mockClock() {
  final clock = MockClock();
  print('Initial:          ${clock.now()}');

  clock.advance(10.seconds);
  print('After +10s:       ${clock.now()}');

  clock.advance(5.minutes);
  print('After +5min:      ${clock.now()}');

  clock.set(Duration.zero);
  print('After set(0):     ${clock.now()}');

  clock.reset();
  print('After reset():    ${clock.now()}');

  // Use as injectable Clock
  final elapsed = _measureWithClock(clock, () => clock.advance(1.hours));
  print('measureWithClock: $elapsed');
}

Duration _measureWithClock(Clock clock, void Function() work) {
  final before = clock.now();
  work();
  return clock.now() - before;
}

// ---------------------------------------------------------------------------
// 7. Additional clocks
// ---------------------------------------------------------------------------
Future<void> _additionalClocks() async {
  print('HiResClock.now()    = ${HiResClock.now()}');

  const utcClock = UtcClock();
  print('UtcClock.now()      = ${utcClock.now()}');
  print('UtcClock ISO        = ${utcClock.now().toIso8601String()}');

  print('TaiClock.now()      = ${TaiClock.now()}');
  print('TAI–UTC offset      = ${TaiClock.taiUtcOffsetSeconds}s');

  print('GpsClock.now()      = ${GpsClock.now()}');
  print('GPS seconds         ≈ ${GpsClock.now().timeSinceEpoch.inSeconds}');
}

// ---------------------------------------------------------------------------
// 8. Calendar enums
// ---------------------------------------------------------------------------
void _calendarEnums() {
  // Month
  final m = Month.june;
  print('Month.june.value      = ${m.value}');
  print('June days in 2024     = ${m.daysIn(2024)}');
  print('June + 3              = ${m + 3}'); // September
  print('January - 1           = ${Month.january - 1}'); // December

  // Weekday
  final wd = Weekday.friday;
  print('Weekday.friday.isoValue = ${wd.isoValue}');
  print('Friday + 2              = ${wd + 2}'); // Sunday
  print('Friday.isWeekend        = ${wd.isWeekend}');
  print('Friday.isWeekday        = ${wd.isWeekday}');
  print('Saturday.isWeekend      = ${Weekday.saturday.isWeekend}');

  // isLeapYear
  print('isLeapYear(2024)   = ${isLeapYear(2024)}');
  print('isLeapYear(1900)   = ${isLeapYear(1900)}');
  print('daysInYear(2024)   = ${daysInYear(2024)}');
}

// ---------------------------------------------------------------------------
// 9. ChronoDate
// ---------------------------------------------------------------------------
void _chronoDate() {
  final today = ChronoDate.today();
  print('Today:              $today');
  print('Weekday:            ${today.weekday}');
  print('Day of year:        ${today.dayOfYear}');
  print('Is leap year:       ${today.isLeap}');

  final d = ChronoDate(2024, Month.january, 31);
  print('Jan 31 + 1 month    → ${d.addMonths(1)}'); // Feb 29 (2024 leap)
  print('Jan 31 + 1 year     → ${d.addYears(1)}'); // Jan 31 2025

  final start = ChronoDate(2024, Month.january, 1);
  final end = ChronoDate(2024, Month.december, 31);
  print('Days in 2024:       ${end.differenceInDays(start) + 1}');

  print('ISO 8601:           ${d.toIso8601()}');
}

// ---------------------------------------------------------------------------
// 10. ChronoTime
// ---------------------------------------------------------------------------
void _chronoTime() {
  final t = ChronoTime(hour: 14, minute: 30, second: 45, microsecond: 123456);
  print('ChronoTime:         $t');
  print('ISO 8601:           ${t.toIso8601()}');
  print('totalMicroseconds:  ${t.totalMicroseconds}');
  print('toDuration:         ${t.toDuration()}');

  print('midnight:           ${ChronoTime.midnight}');
  print('noon:               ${ChronoTime.noon}');

  final a = ChronoTime(hour: 9);
  final b = ChronoTime(hour: 17, minute: 30);
  print('9:00 < 17:30 =      ${a < b}');
}

// ---------------------------------------------------------------------------
// 11. ChronoDateTime
// ---------------------------------------------------------------------------
void _chronoDateTime() {
  final now = ChronoDateTime.now();
  print('ChronoDateTime.now():  $now');
  print('ISO 8601:              ${now.toIso8601()}');

  final release = ChronoDateTime(
    ChronoDate(2025, Month.january, 1),
    ChronoTime(hour: 0),
  );
  print('New year 2025:         $release');
  print('now < 2025-01-01:      ${now < release}');
}

// ---------------------------------------------------------------------------
// 12. TimeInterval
// ---------------------------------------------------------------------------
void _timeInterval() {
  final now = SteadyClock.now();
  final in5 = now + 5.seconds;
  final in10 = now + 10.seconds;
  final in15 = now + 15.seconds;

  final meeting = TimeInterval(now, in10);
  final briefing = TimeInterval(in5, in15);

  print('meeting:            $meeting');
  print('briefing:           $briefing');
  print('duration:           ${meeting.duration.humanReadable()}');
  print('overlaps:           ${meeting.overlaps(briefing)}');
  print('intersection:       ${meeting.intersection(briefing)}');
  print('hull:               ${meeting.hull(briefing)}');

  final a = TimeInterval(now, in5);
  final b = TimeInterval(in10, in15);
  print('gap(a, b):          ${a.gap(b)}');
  print('a.contains(now):    ${a.contains(now)}');
  print('a.contains(in10):   ${a.contains(in10)}');
}

// ---------------------------------------------------------------------------
// 13. LapStopwatch
// ---------------------------------------------------------------------------
Future<void> _lapStopwatch() async {
  final sw = LapStopwatch()..start();

  for (var i = 0; i < 3; i++) {
    await Future.delayed(const Duration(milliseconds: 20));
    final rec = sw.lap();
    print('  $rec');
  }
  sw.stop();

  print('Total elapsed:   ${sw.elapsed.humanReadable()}');
  print('Fastest lap:     ${sw.fastestLap?.humanReadable()}');
  print('Slowest lap:     ${sw.slowestLap?.humanReadable()}');
  print('Average lap:     ${sw.averageLap?.humanReadable()}');
  print(sw);
}

// ---------------------------------------------------------------------------
// 14. CountdownTimer
// ---------------------------------------------------------------------------
Future<void> _countdownTimer() async {
  final timer = CountdownTimer(const Duration(milliseconds: 100));
  timer.start();
  print('started: ${timer.isStarted}');
  print('$timer');

  await Future.delayed(const Duration(milliseconds: 50));
  print(
    '~50ms in → remaining: ${timer.remaining.humanReadable()}, '
    'progress: ${(timer.progress * 100).toStringAsFixed(0)}%',
  );

  await Future.delayed(const Duration(milliseconds: 70));
  print('expired: ${timer.isExpired}');
  print('remaining: ${timer.remaining}');
}

// ---------------------------------------------------------------------------
// 15. Ticker
// ---------------------------------------------------------------------------
Future<void> _ticker() async {
  const interval = Duration(milliseconds: 30);
  final ticker = Ticker(interval);
  var count = 0;
  await for (final elapsed in ticker.tick()) {
    print('  tick $count: $elapsed');
    if (++count >= 3) break;
  }
}

// ---------------------------------------------------------------------------
// Helper
// ---------------------------------------------------------------------------
void _section(String title) {
  print('\n${'=' * 60}');
  print('  $title');
  // print('${'=' * 60}'); feel free to uncomment.
}
