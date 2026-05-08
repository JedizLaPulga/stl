// Tests for chrono/calendar.dart — Month, Weekday, ChronoDate, ChronoTime,
// ChronoDateTime, isLeapYear, daysInYear helpers.
import 'package:test/test.dart';
import 'package:stl/stl.dart';

void main() {
  // --------------------------------------------------------------------------
  // isLeapYear / daysInYear
  // --------------------------------------------------------------------------
  group('isLeapYear', () {
    test('divisible by 4 but not 100 is a leap year', () {
      expect(isLeapYear(2024), isTrue);
      expect(isLeapYear(2020), isTrue);
    });
    test('century year not divisible by 400 is not a leap year', () {
      expect(isLeapYear(1900), isFalse);
      expect(isLeapYear(2100), isFalse);
    });
    test('divisible by 400 is a leap year', () {
      expect(isLeapYear(2000), isTrue);
      expect(isLeapYear(1600), isTrue);
    });
    test('common year is not a leap year', () {
      expect(isLeapYear(2023), isFalse);
      expect(isLeapYear(2019), isFalse);
    });
  });

  group('daysInYear', () {
    test('leap year has 366 days', () => expect(daysInYear(2000), 366));
    test('common year has 365 days', () => expect(daysInYear(2023), 365));
  });

  // --------------------------------------------------------------------------
  // Month
  // --------------------------------------------------------------------------
  group('Month', () {
    test('fromValue 1 is January', () {
      expect(Month.fromValue(1), Month.january);
    });
    test('fromValue 12 is December', () {
      expect(Month.fromValue(12), Month.december);
    });
    test('fromValue out of range throws RangeError', () {
      expect(() => Month.fromValue(0), throwsRangeError);
      expect(() => Month.fromValue(13), throwsRangeError);
    });
    test('daysIn non-leap February is 28', () {
      expect(Month.february.daysIn(2023), 28);
    });
    test('daysIn leap February is 29', () {
      expect(Month.february.daysIn(2024), 29);
    });
    test('daysIn January is 31', () {
      expect(Month.january.daysIn(2024), 31);
    });
    test('daysIn April is 30', () {
      expect(Month.april.daysIn(2024), 30);
    });
    test('operator + wraps from December to January', () {
      expect(Month.december + 1, Month.january);
    });
    test('operator + stays within range', () {
      expect(Month.january + 3, Month.april);
    });
    test('operator - wraps from January to December', () {
      expect(Month.january - 1, Month.december);
    });
    test('toString is capitalized name', () {
      expect(Month.january.toString(), 'January');
      expect(Month.september.toString(), 'September');
    });
    test('value matches ISO month number', () {
      expect(Month.may.value, 5);
      expect(Month.october.value, 10);
    });
  });

  // --------------------------------------------------------------------------
  // Weekday
  // --------------------------------------------------------------------------
  group('Weekday', () {
    test('fromIso 1 is Monday', () {
      expect(Weekday.fromIso(1), Weekday.monday);
    });
    test('fromIso 7 is Sunday', () {
      expect(Weekday.fromIso(7), Weekday.sunday);
    });
    test('fromIso out of range throws RangeError', () {
      expect(() => Weekday.fromIso(0), throwsRangeError);
      expect(() => Weekday.fromIso(8), throwsRangeError);
    });
    test('Saturday and Sunday are weekends', () {
      expect(Weekday.saturday.isWeekend, isTrue);
      expect(Weekday.sunday.isWeekend, isTrue);
    });
    test('Monday through Friday are weekdays', () {
      expect(Weekday.monday.isWeekday, isTrue);
      expect(Weekday.friday.isWeekday, isTrue);
    });
    test('operator + wraps from Sunday to Monday', () {
      expect(Weekday.sunday + 1, Weekday.monday);
    });
    test('operator + advances correctly', () {
      expect(Weekday.monday + 4, Weekday.friday);
    });
    test('operator - wraps from Monday to Sunday', () {
      expect(Weekday.monday - 1, Weekday.sunday);
    });
    test('toString is capitalized name', () {
      expect(Weekday.wednesday.toString(), 'Wednesday');
    });
    test('isoValue matches ISO day number', () {
      expect(Weekday.monday.isoValue, 1);
      expect(Weekday.sunday.isoValue, 7);
    });
  });

  // --------------------------------------------------------------------------
  // ChronoDate
  // --------------------------------------------------------------------------
  group('ChronoDate', () {
    test('constructs valid date', () {
      final d = ChronoDate(2024, Month.june, 15);
      expect(d.year, 2024);
      expect(d.month, Month.june);
      expect(d.day, 15);
    });
    test('invalid day throws RangeError', () {
      expect(() => ChronoDate(2023, Month.february, 29), throwsRangeError);
      expect(() => ChronoDate(2024, Month.january, 0), throwsRangeError);
      expect(() => ChronoDate(2024, Month.january, 32), throwsRangeError);
    });
    test('leap day Feb 29 is valid on leap year', () {
      expect(() => ChronoDate(2024, Month.february, 29), returnsNormally);
    });
    test('fromDateTime extracts date components', () {
      final dt = DateTime(2024, 6, 15);
      final d = ChronoDate.fromDateTime(dt);
      expect(d.year, 2024);
      expect(d.month, Month.june);
      expect(d.day, 15);
    });
    test('weekday returns correct day', () {
      // 2024-06-17 is a Monday
      final d = ChronoDate(2024, Month.june, 17);
      expect(d.weekday, Weekday.monday);
    });
    test('dayOfYear for January 1 is 1', () {
      expect(ChronoDate(2024, Month.january, 1).dayOfYear, 1);
    });
    test('dayOfYear for December 31 on leap year is 366', () {
      expect(ChronoDate(2024, Month.december, 31).dayOfYear, 366);
    });
    test('dayOfYear for December 31 on common year is 365', () {
      expect(ChronoDate(2023, Month.december, 31).dayOfYear, 365);
    });
    test('isLeap is true on leap year', () {
      expect(ChronoDate(2024, Month.january, 1).isLeap, isTrue);
    });
    test('isLeap is false on common year', () {
      expect(ChronoDate(2023, Month.january, 1).isLeap, isFalse);
    });
    test('toDateTime produces correct DateTime', () {
      final d = ChronoDate(2024, Month.june, 15);
      final dt = d.toDateTime();
      expect(dt.year, 2024);
      expect(dt.month, 6);
      expect(dt.day, 15);
    });
    test('addDays advances by days', () {
      final d = ChronoDate(2024, Month.january, 30);
      final result = d.addDays(3);
      expect(result, ChronoDate(2024, Month.february, 2));
    });
    test('addDays can go negative', () {
      final d = ChronoDate(2024, Month.february, 1);
      final result = d.addDays(-1);
      expect(result, ChronoDate(2024, Month.january, 31));
    });
    test('addMonths advances by one month', () {
      final d = ChronoDate(2024, Month.january, 31);
      // Jan 31 + 1 month → Feb 29 (clamped, 2024 is a leap year)
      final result = d.addMonths(1);
      expect(result, ChronoDate(2024, Month.february, 29));
    });
    test('addMonths wraps year', () {
      final d = ChronoDate(2023, Month.december, 15);
      final result = d.addMonths(1);
      expect(result, ChronoDate(2024, Month.january, 15));
    });
    test('addYears preserves date, clamping Feb 29', () {
      final d = ChronoDate(2024, Month.february, 29);
      final result = d.addYears(1);
      // 2025 is not a leap year → clamped to Feb 28
      expect(result, ChronoDate(2025, Month.february, 28));
    });
    test('differenceInDays is positive when this is after other', () {
      final d1 = ChronoDate(2024, Month.january, 10);
      final d2 = ChronoDate(2024, Month.january, 1);
      expect(d1.differenceInDays(d2), 9);
    });
    test('differenceInDays is negative when this is before other', () {
      final d1 = ChronoDate(2024, Month.january, 1);
      final d2 = ChronoDate(2024, Month.january, 10);
      expect(d1.differenceInDays(d2), -9);
    });
    test('equality holds for same components', () {
      final d1 = ChronoDate(2024, Month.june, 15);
      final d2 = ChronoDate(2024, Month.june, 15);
      expect(d1, equals(d2));
    });
    test('equality fails for different day', () {
      final d1 = ChronoDate(2024, Month.june, 15);
      final d2 = ChronoDate(2024, Month.june, 16);
      expect(d1, isNot(equals(d2)));
    });
    test('hashCode is equal for equal dates', () {
      final d1 = ChronoDate(2024, Month.june, 15);
      final d2 = ChronoDate(2024, Month.june, 15);
      expect(d1.hashCode, d2.hashCode);
    });
    test('compareTo orders correctly', () {
      final d1 = ChronoDate(2024, Month.january, 1);
      final d2 = ChronoDate(2024, Month.june, 15);
      expect(d1.compareTo(d2), isNegative);
      expect(d2.compareTo(d1), isPositive);
      expect(d1.compareTo(d1), 0);
    });
    test('operators <, >, <=, >= work', () {
      final d1 = ChronoDate(2024, Month.january, 1);
      final d2 = ChronoDate(2024, Month.june, 15);
      expect(d1 < d2, isTrue);
      expect(d2 > d1, isTrue);
      expect(d1 <= d1, isTrue);
      expect(d2 >= d2, isTrue);
    });
    test('toIso8601 formats correctly', () {
      expect(ChronoDate(2024, Month.june, 5).toIso8601(), '2024-06-05');
      expect(ChronoDate(2000, Month.january, 1).toIso8601(), '2000-01-01');
    });
    test('toString wraps ISO string', () {
      final d = ChronoDate(2024, Month.june, 15);
      expect(d.toString(), contains('2024-06-15'));
    });
  });

  // --------------------------------------------------------------------------
  // ChronoTime
  // --------------------------------------------------------------------------
  group('ChronoTime', () {
    test('constructs with all components', () {
      final t = ChronoTime(
        hour: 14,
        minute: 30,
        second: 45,
        microsecond: 123456,
      );
      expect(t.hour, 14);
      expect(t.minute, 30);
      expect(t.second, 45);
      expect(t.microsecond, 123456);
    });
    test('default constructor is midnight', () {
      final t = ChronoTime();
      expect(t.totalMicroseconds, 0);
    });
    test('invalid hour throws RangeError', () {
      expect(() => ChronoTime(hour: 24), throwsRangeError);
      expect(() => ChronoTime(hour: -1), throwsRangeError);
    });
    test('invalid minute throws RangeError', () {
      expect(() => ChronoTime(minute: 60), throwsRangeError);
    });
    test('invalid second throws RangeError', () {
      expect(() => ChronoTime(second: 60), throwsRangeError);
    });
    test('invalid microsecond throws RangeError', () {
      expect(() => ChronoTime(microsecond: 1000000), throwsRangeError);
    });
    test('midnight getter is 00:00:00', () {
      expect(ChronoTime.midnight.totalMicroseconds, 0);
    });
    test('noon getter is 12:00:00', () {
      expect(ChronoTime.noon.hour, 12);
    });
    test('totalMicroseconds is computed correctly', () {
      final t = ChronoTime(hour: 1, minute: 1, second: 1, microsecond: 1);
      expect(t.totalMicroseconds, (3600 + 60 + 1) * 1000000 + 1);
    });
    test('toDuration matches totalMicroseconds', () {
      final t = ChronoTime(hour: 2, minute: 30);
      expect(t.toDuration(), Duration(hours: 2, minutes: 30));
    });
    test('equality and hashCode', () {
      final t1 = ChronoTime(hour: 12, minute: 30, second: 0);
      final t2 = ChronoTime(hour: 12, minute: 30, second: 0);
      expect(t1, equals(t2));
      expect(t1.hashCode, t2.hashCode);
    });
    test('compareTo orders correctly', () {
      final t1 = ChronoTime(hour: 8);
      final t2 = ChronoTime(hour: 12);
      expect(t1.compareTo(t2), isNegative);
      expect(t2.compareTo(t1), isPositive);
    });
    test('toIso8601 without microseconds is HH:MM:SS', () {
      expect(ChronoTime(hour: 9, minute: 5, second: 3).toIso8601(), '09:05:03');
    });
    test('toIso8601 with microseconds appends .uuuuuu', () {
      expect(
        ChronoTime(
          hour: 9,
          minute: 5,
          second: 3,
          microsecond: 500000,
        ).toIso8601(),
        '09:05:03.500000',
      );
    });
    test('toString wraps ISO string', () {
      final t = ChronoTime(hour: 14, minute: 30);
      expect(t.toString(), contains('14:30:00'));
    });
    test('fromDateTime extracts time components', () {
      final dt = DateTime(2024, 1, 1, 14, 30, 45, 123, 456);
      final t = ChronoTime.fromDateTime(dt);
      expect(t.hour, 14);
      expect(t.minute, 30);
      expect(t.second, 45);
      // microsecond = ms*1000 + us = 123*1000+456 = 123456
      expect(t.microsecond, 123 * 1000 + 456);
    });
  });

  // --------------------------------------------------------------------------
  // ChronoDateTime
  // --------------------------------------------------------------------------
  group('ChronoDateTime', () {
    test('constructs from date and time', () {
      final dt = ChronoDateTime(
        ChronoDate(2024, Month.june, 15),
        ChronoTime(hour: 12, minute: 30),
      );
      expect(dt.date.year, 2024);
      expect(dt.time.hour, 12);
    });
    test('fromDateTime round-trips correctly', () {
      final dart = DateTime(2024, 6, 15, 12, 30, 45);
      final cdt = ChronoDateTime.fromDateTime(dart);
      expect(cdt.date, ChronoDate(2024, Month.june, 15));
      expect(cdt.time.hour, 12);
      expect(cdt.time.minute, 30);
      expect(cdt.time.second, 45);
    });
    test('toDateTime produces equivalent DateTime', () {
      final cdt = ChronoDateTime(
        ChronoDate(2024, Month.june, 15),
        ChronoTime(hour: 12, minute: 30, second: 45),
      );
      final dt = cdt.toDateTime();
      expect(dt.year, 2024);
      expect(dt.month, 6);
      expect(dt.day, 15);
      expect(dt.hour, 12);
      expect(dt.minute, 30);
      expect(dt.second, 45);
    });
    test('compareTo orders by date then time', () {
      final a = ChronoDateTime(
        ChronoDate(2024, Month.june, 15),
        ChronoTime(hour: 8),
      );
      final b = ChronoDateTime(
        ChronoDate(2024, Month.june, 15),
        ChronoTime(hour: 12),
      );
      final c = ChronoDateTime(
        ChronoDate(2024, Month.june, 16),
        ChronoTime(hour: 8),
      );
      expect(a.compareTo(b), isNegative);
      expect(b.compareTo(a), isPositive);
      expect(a.compareTo(c), isNegative);
      expect(a.compareTo(a), 0);
    });
    test('operators <, >, <=, >= work', () {
      final a = ChronoDateTime(
        ChronoDate(2024, Month.january, 1),
        ChronoTime(hour: 0),
      );
      final b = ChronoDateTime(
        ChronoDate(2024, Month.december, 31),
        ChronoTime(hour: 23),
      );
      expect(a < b, isTrue);
      expect(b > a, isTrue);
      expect(a <= a, isTrue);
      expect(b >= b, isTrue);
    });
    test('equality and hashCode', () {
      final a = ChronoDateTime(
        ChronoDate(2024, Month.june, 15),
        ChronoTime(hour: 12),
      );
      final b = ChronoDateTime(
        ChronoDate(2024, Month.june, 15),
        ChronoTime(hour: 12),
      );
      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
    });
    test('toIso8601 formats as YYYY-MM-DDTHH:MM:SS', () {
      final cdt = ChronoDateTime(
        ChronoDate(2024, Month.june, 5),
        ChronoTime(hour: 9, minute: 5, second: 3),
      );
      expect(cdt.toIso8601(), '2024-06-05T09:05:03');
    });
    test('toString wraps toIso8601', () {
      final cdt = ChronoDateTime(
        ChronoDate(2024, Month.june, 15),
        ChronoTime(hour: 12),
      );
      expect(cdt.toString(), contains('2024-06-15'));
    });
  });
}
