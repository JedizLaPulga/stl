/// Calendar types: Month, Weekday, ChronoDate, ChronoTime, ChronoDateTime.
///
/// Inspired by C++20 `<chrono>` calendar types (`std::chrono::year`,
/// `std::chrono::month`, `std::chrono::day`, `std::chrono::year_month_day`,
/// `std::chrono::hh_mm_ss`) and the ISO 8601 standard.
library;

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// Returns `true` if [year] is a proleptic Gregorian leap year.
///
/// A year is a leap year if it is divisible by 4, except for century years
/// which must be divisible by 400.
bool isLeapYear(int year) =>
    (year % 4 == 0 && year % 100 != 0) || year % 400 == 0;

/// Returns the number of days in [year] (365 or 366).
int daysInYear(int year) => isLeapYear(year) ? 366 : 365;

// ---------------------------------------------------------------------------
// Month
// ---------------------------------------------------------------------------

/// The twelve months of the proleptic Gregorian calendar.
///
/// Analogous to `std::chrono::month` in C++20.
enum Month {
  /// The first month of the year (ISO value 1).
  january(1),

  /// The second month of the year (ISO value 2).
  february(2),

  /// The third month of the year (ISO value 3).
  march(3),

  /// The fourth month of the year (ISO value 4).
  april(4),

  /// The fifth month of the year (ISO value 5).
  may(5),

  /// The sixth month of the year (ISO value 6).
  june(6),

  /// The seventh month of the year (ISO value 7).
  july(7),

  /// The eighth month of the year (ISO value 8).
  august(8),

  /// The ninth month of the year (ISO value 9).
  september(9),

  /// The tenth month of the year (ISO value 10).
  october(10),

  /// The eleventh month of the year (ISO value 11).
  november(11),

  /// The twelfth and final month of the year (ISO value 12).
  december(12);

  const Month(this.value);

  /// ISO month number (1 = January … 12 = December).
  final int value;

  /// Constructs a [Month] from its ISO number [v] (1–12).
  ///
  /// Throws [RangeError] if [v] is outside `[1, 12]`.
  factory Month.fromValue(int v) {
    if (v < 1 || v > 12) throw RangeError.range(v, 1, 12, 'month');
    return Month.values[v - 1];
  }

  /// Number of days in this month for the given [year].
  ///
  /// Accounts for leap years when called on [Month.february].
  int daysIn(int year) {
    switch (this) {
      case Month.january:
        return 31;
      case Month.february:
        return isLeapYear(year) ? 29 : 28;
      case Month.march:
        return 31;
      case Month.april:
        return 30;
      case Month.may:
        return 31;
      case Month.june:
        return 30;
      case Month.july:
        return 31;
      case Month.august:
        return 31;
      case Month.september:
        return 30;
      case Month.october:
        return 31;
      case Month.november:
        return 30;
      case Month.december:
        return 31;
    }
  }

  /// Returns the [Month] that is [n] months after this one (wraps around).
  Month operator +(int n) {
    final newValue = ((value - 1 + (n % 12) + 12) % 12) + 1;
    return Month.fromValue(newValue);
  }

  /// Returns the [Month] that is [n] months before this one (wraps around).
  Month operator -(int n) => this + (-n);

  /// Returns the capitalised English name of this month (e.g. `"January"`).
  @override
  String toString() => name[0].toUpperCase() + name.substring(1);
}

// ---------------------------------------------------------------------------
// Weekday
// ---------------------------------------------------------------------------

/// The seven days of the week, using ISO 8601 numbering (1 = Monday).
///
/// Analogous to `std::chrono::weekday` in C++20.
enum Weekday {
  /// Monday — the first day of the ISO week (ISO value 1).
  monday(1),

  /// Tuesday — the second day of the ISO week (ISO value 2).
  tuesday(2),

  /// Wednesday — the third day of the ISO week (ISO value 3).
  wednesday(3),

  /// Thursday — the fourth day of the ISO week (ISO value 4).
  thursday(4),

  /// Friday — the fifth day of the ISO week (ISO value 5).
  friday(5),

  /// Saturday — the sixth day of the ISO week (ISO value 6); a weekend day.
  saturday(6),

  /// Sunday — the seventh day of the ISO week (ISO value 7); a weekend day.
  sunday(7);

  const Weekday(this.isoValue);

  /// ISO weekday number (1 = Monday … 7 = Sunday).
  final int isoValue;

  /// Constructs a [Weekday] from its ISO number [v] (1–7).
  ///
  /// Throws [RangeError] if [v] is outside `[1, 7]`.
  factory Weekday.fromIso(int v) {
    if (v < 1 || v > 7) throw RangeError.range(v, 1, 7, 'weekday');
    return Weekday.values[v - 1];
  }

  /// Returns `true` if this is Saturday or Sunday.
  bool get isWeekend => this == saturday || this == sunday;

  /// Returns `true` if this is Monday through Friday.
  bool get isWeekday => !isWeekend;

  /// Returns the [Weekday] that is [n] days after this one (wraps around).
  Weekday operator +(int n) {
    final newValue = ((isoValue - 1 + (n % 7) + 7) % 7) + 1;
    return Weekday.fromIso(newValue);
  }

  /// Returns the [Weekday] that is [n] days before this one (wraps around).
  Weekday operator -(int n) => this + (-n);

  /// Returns the capitalised English name of this weekday (e.g. `"Monday"`).
  @override
  String toString() => name[0].toUpperCase() + name.substring(1);
}

// ---------------------------------------------------------------------------
// ChronoDate
// ---------------------------------------------------------------------------

/// A calendar date in the proleptic Gregorian calendar.
///
/// Analogous to `std::chrono::year_month_day` in C++20. Stores year, [Month],
/// and day-of-month. All three components are validated at construction time.
class ChronoDate implements Comparable<ChronoDate> {
  /// The year component (may be negative for BCE dates).
  final int year;

  /// The month of the year.
  final Month month;

  /// The day of the month (1-based).
  final int day;

  /// Creates a [ChronoDate].
  ///
  /// Throws [RangeError] if [day] is outside the valid range for [month] and
  /// [year] (accounts for leap years in February).
  ChronoDate(this.year, this.month, this.day) {
    final maxDay = month.daysIn(year);
    if (day < 1 || day > maxDay) {
      throw RangeError.range(day, 1, maxDay, 'day');
    }
  }

  /// Creates a [ChronoDate] from a Dart [DateTime].
  factory ChronoDate.fromDateTime(DateTime dt) =>
      ChronoDate(dt.year, Month.fromValue(dt.month), dt.day);

  /// Today's date in local time.
  factory ChronoDate.today() => ChronoDate.fromDateTime(DateTime.now());

  /// Today's date in UTC.
  factory ChronoDate.todayUtc() =>
      ChronoDate.fromDateTime(DateTime.now().toUtc());

  // ---- Computed properties ------------------------------------------------

  /// The day of the week for this date.
  Weekday get weekday =>
      Weekday.fromIso(DateTime(year, month.value, day).weekday);

  /// The ordinal day of the year (1–365 or 1–366).
  int get dayOfYear {
    var d = 0;
    for (var m = 1; m < month.value; m++) {
      d += Month.fromValue(m).daysIn(year);
    }
    return d + day;
  }

  /// Returns `true` if this date's year is a leap year.
  bool get isLeap => isLeapYear(year);

  // ---- Conversions ---------------------------------------------------------

  /// Converts to a Dart [DateTime] at midnight local time.
  DateTime toDateTime() => DateTime(year, month.value, day);

  /// Converts to a Dart [DateTime] at midnight UTC.
  DateTime toUtcDateTime() => DateTime.utc(year, month.value, day);

  // ---- Arithmetic ----------------------------------------------------------

  /// Returns a new [ChronoDate] offset by [days] calendar days.
  ChronoDate addDays(int days) =>
      ChronoDate.fromDateTime(DateTime(year, month.value, day + days));

  /// Returns a new [ChronoDate] offset by [months] calendar months.
  ///
  /// If the resulting month has fewer days than the original day, the day is
  /// clamped to the last valid day of the new month (e.g. Jan 31 + 1 month
  /// → Feb 28/29).
  ChronoDate addMonths(int months) {
    final totalMonths = (month.value - 1) + months;
    // floorDiv to handle negative months correctly
    final newYear = year + _floorDiv(totalMonths, 12);
    final newMonthValue = ((totalMonths % 12) + 12) % 12 + 1;
    final newMonth = Month.fromValue(newMonthValue);
    final maxDay = newMonth.daysIn(newYear);
    return ChronoDate(newYear, newMonth, day.clamp(1, maxDay));
  }

  /// Returns a new [ChronoDate] offset by [years] calendar years.
  ///
  /// If the original date is February 29 and the new year is not a leap year,
  /// the day is clamped to February 28.
  ChronoDate addYears(int years) {
    final newYear = year + years;
    final maxDay = month.daysIn(newYear);
    return ChronoDate(newYear, month, day.clamp(1, maxDay));
  }

  /// Returns the signed number of days from [other] to this date.
  ///
  /// Positive if this date is after [other]; negative if before.
  int differenceInDays(ChronoDate other) =>
      toDateTime().difference(other.toDateTime()).inDays;

  // ---- Comparison ----------------------------------------------------------

  @override
  int compareTo(ChronoDate other) {
    final yearCmp = year.compareTo(other.year);
    if (yearCmp != 0) return yearCmp;
    final monthCmp = month.value.compareTo(other.month.value);
    if (monthCmp != 0) return monthCmp;
    return day.compareTo(other.day);
  }

  /// Returns `true` if this date is strictly before [other].
  bool operator <(ChronoDate other) => compareTo(other) < 0;

  /// Returns `true` if this date is strictly after [other].
  bool operator >(ChronoDate other) => compareTo(other) > 0;

  /// Returns `true` if this date is before or equal to [other].
  bool operator <=(ChronoDate other) => compareTo(other) <= 0;

  /// Returns `true` if this date is after or equal to [other].
  bool operator >=(ChronoDate other) => compareTo(other) >= 0;

  /// Returns `true` if [other] is a [ChronoDate] with the same year, month,
  /// and day.
  @override
  bool operator ==(Object other) =>
      other is ChronoDate &&
      year == other.year &&
      month == other.month &&
      day == other.day;

  /// Hash code consistent with [operator ==]: equal dates share the same hash.
  @override
  int get hashCode => Object.hash(year, month, day);

  // ---- Formatting ----------------------------------------------------------

  /// Formats as ISO 8601 date string `YYYY-MM-DD`.
  String toIso8601() =>
      '${year.toString().padLeft(4, '0')}-'
      '${month.value.toString().padLeft(2, '0')}-'
      '${day.toString().padLeft(2, '0')}';

  /// Returns a human-readable representation, e.g. `"ChronoDate(2024-06-15)"`.
  @override
  String toString() => 'ChronoDate(${toIso8601()})';
}

// ---------------------------------------------------------------------------
// ChronoTime
// ---------------------------------------------------------------------------

/// A time of day with microsecond precision.
///
/// Analogous to `std::chrono::hh_mm_ss` in C++20. All components are
/// validated at construction time.
class ChronoTime implements Comparable<ChronoTime> {
  /// Hour of day (0–23).
  final int hour;

  /// Minute of hour (0–59).
  final int minute;

  /// Second of minute (0–59).
  final int second;

  /// Sub-second microseconds (0–999 999).
  final int microsecond;

  /// Creates a [ChronoTime].
  ///
  /// Throws [RangeError] if any component is out of its valid range.
  ChronoTime({
    this.hour = 0,
    this.minute = 0,
    this.second = 0,
    this.microsecond = 0,
  }) {
    if (hour < 0 || hour > 23) throw RangeError.range(hour, 0, 23, 'hour');
    if (minute < 0 || minute > 59) {
      throw RangeError.range(minute, 0, 59, 'minute');
    }
    if (second < 0 || second > 59) {
      throw RangeError.range(second, 0, 59, 'second');
    }
    if (microsecond < 0 || microsecond > 999999) {
      throw RangeError.range(microsecond, 0, 999999, 'microsecond');
    }
  }

  /// Creates a [ChronoTime] from a Dart [DateTime], extracting its time-of-day
  /// components.
  factory ChronoTime.fromDateTime(DateTime dt) => ChronoTime(
    hour: dt.hour,
    minute: dt.minute,
    second: dt.second,
    microsecond: dt.millisecond * 1000 + dt.microsecond,
  );

  /// Midnight — `00:00:00`.
  static ChronoTime get midnight => ChronoTime();

  /// Noon — `12:00:00`.
  static ChronoTime get noon => ChronoTime(hour: 12);

  // ---- Computed properties ------------------------------------------------

  /// Total microseconds elapsed since midnight.
  int get totalMicroseconds =>
      (hour * 3600 + minute * 60 + second) * 1000000 + microsecond;

  /// Converts to a [Duration] representing elapsed time since midnight.
  Duration toDuration() => Duration(microseconds: totalMicroseconds);

  // ---- Comparison ----------------------------------------------------------

  @override
  int compareTo(ChronoTime other) =>
      totalMicroseconds.compareTo(other.totalMicroseconds);

  /// Returns `true` if this time is strictly before [other].
  bool operator <(ChronoTime other) => compareTo(other) < 0;

  /// Returns `true` if this time is strictly after [other].
  bool operator >(ChronoTime other) => compareTo(other) > 0;

  /// Returns `true` if this time is before or equal to [other].
  bool operator <=(ChronoTime other) => compareTo(other) <= 0;

  /// Returns `true` if this time is after or equal to [other].
  bool operator >=(ChronoTime other) => compareTo(other) >= 0;

  /// Returns `true` if [other] is a [ChronoTime] representing the same
  /// time of day (comparison is based on [totalMicroseconds]).
  @override
  bool operator ==(Object other) =>
      other is ChronoTime && totalMicroseconds == other.totalMicroseconds;

  /// Hash code consistent with [operator ==]: equal times share the same hash.
  @override
  int get hashCode => totalMicroseconds.hashCode;

  // ---- Formatting ----------------------------------------------------------

  /// Formats as `HH:MM:SS`, or `HH:MM:SS.uuuuuu` if [microsecond] > 0.
  String toIso8601() {
    final base =
        '${hour.toString().padLeft(2, '0')}:'
        '${minute.toString().padLeft(2, '0')}:'
        '${second.toString().padLeft(2, '0')}';
    if (microsecond == 0) return base;
    return '$base.${microsecond.toString().padLeft(6, '0')}';
  }

  /// Returns a human-readable representation,
  /// e.g. `"ChronoTime(14:30:45.123456)"`.
  @override
  String toString() => 'ChronoTime(${toIso8601()})';
}

// ---------------------------------------------------------------------------
// ChronoDateTime
// ---------------------------------------------------------------------------

/// A combined calendar date and time of day.
///
/// Combines [ChronoDate] and [ChronoTime] into a single point in local or UTC
/// calendar time. For monotonic time measurement use [SteadyClock]/[TimePoint]
/// instead.
class ChronoDateTime implements Comparable<ChronoDateTime> {
  /// The date component.
  final ChronoDate date;

  /// The time-of-day component.
  final ChronoTime time;

  /// Creates a [ChronoDateTime] from a [date] and a [time].
  const ChronoDateTime(this.date, this.time);

  /// Creates a [ChronoDateTime] from a Dart [DateTime].
  factory ChronoDateTime.fromDateTime(DateTime dt) =>
      ChronoDateTime(ChronoDate.fromDateTime(dt), ChronoTime.fromDateTime(dt));

  /// The current local date and time.
  factory ChronoDateTime.now() => ChronoDateTime.fromDateTime(DateTime.now());

  /// The current UTC date and time.
  factory ChronoDateTime.nowUtc() =>
      ChronoDateTime.fromDateTime(DateTime.now().toUtc());

  // ---- Conversions ---------------------------------------------------------

  /// Converts to a Dart [DateTime] in local time.
  DateTime toDateTime() => DateTime(
    date.year,
    date.month.value,
    date.day,
    time.hour,
    time.minute,
    time.second,
    time.microsecond ~/ 1000,
    time.microsecond % 1000,
  );

  /// Converts to a Dart [DateTime] in UTC.
  DateTime toUtcDateTime() => DateTime.utc(
    date.year,
    date.month.value,
    date.day,
    time.hour,
    time.minute,
    time.second,
    time.microsecond ~/ 1000,
    time.microsecond % 1000,
  );

  // ---- Formatting ----------------------------------------------------------

  /// Formats as ISO 8601: `YYYY-MM-DDTHH:MM:SS[.uuuuuu]`.
  String toIso8601() => '${date.toIso8601()}T${time.toIso8601()}';

  // ---- Comparison ----------------------------------------------------------

  @override
  int compareTo(ChronoDateTime other) {
    final dateCmp = date.compareTo(other.date);
    if (dateCmp != 0) return dateCmp;
    return time.compareTo(other.time);
  }

  /// Returns `true` if this date-time is strictly before [other].
  bool operator <(ChronoDateTime other) => compareTo(other) < 0;

  /// Returns `true` if this date-time is strictly after [other].
  bool operator >(ChronoDateTime other) => compareTo(other) > 0;

  /// Returns `true` if this date-time is before or equal to [other].
  bool operator <=(ChronoDateTime other) => compareTo(other) <= 0;

  /// Returns `true` if this date-time is after or equal to [other].
  bool operator >=(ChronoDateTime other) => compareTo(other) >= 0;

  /// Returns `true` if [other] is a [ChronoDateTime] with the same [date]
  /// and [time] components.
  @override
  bool operator ==(Object other) =>
      other is ChronoDateTime && date == other.date && time == other.time;

  /// Hash code consistent with [operator ==]: equal instances share the same
  /// hash.
  @override
  int get hashCode => Object.hash(date, time);

  /// Returns a human-readable representation,
  /// e.g. `"ChronoDateTime(2024-06-15T14:30:45)"`.
  @override
  String toString() => 'ChronoDateTime(${toIso8601()})';
}

// ---------------------------------------------------------------------------
// Internal helpers
// ---------------------------------------------------------------------------

/// Floor division (toward negative infinity).
int _floorDiv(int a, int b) {
  final q = a ~/ b;
  // If signs differ and there is a remainder, adjust one step down.
  return (a ^ b) < 0 && q * b != a ? q - 1 : q;
}
