import 'base.dart';
import 'models/lunar_date.dart';
import 'models/solar_date.dart';
import 'utils.dart';

LunarDate convertSolar2Lunar(int dd, int mm, int yy, double timeZone) {
  int k,
      dayNumber,
      monthStart,
      a11,
      b11,
      lunarDay,
      lunarMonth,
      lunarYear,
      lunarLeap;
  dayNumber = jdFromDate(dd, mm, yy);
  k = toInt((dayNumber - 2415021.076998695) / 29.530588853);
  monthStart = getNewMoonDay(k + 1, timeZone);
  if (monthStart > dayNumber) {
    monthStart = getNewMoonDay(k, timeZone);
  }
  //alert(dayNumber+" -> "+monthStart);
  a11 = getLunarMonth11(yy, timeZone);
  b11 = a11;
  if (a11 >= monthStart) {
    lunarYear = yy;
    a11 = getLunarMonth11(yy - 1, timeZone);
  } else {
    lunarYear = yy + 1;
    b11 = getLunarMonth11(yy + 1, timeZone);
  }
  lunarDay = dayNumber - monthStart + 1;
  final int diff = toInt((monthStart - a11) / 29);
  lunarLeap = 0;
  lunarMonth = diff + 11;
  if (b11 - a11 > 365) {
    final int leapMonthDiff = getLeapMonthOffset(a11, timeZone);
    if (diff >= leapMonthDiff) {
      lunarMonth = diff + 10;
      if (diff == leapMonthDiff) {
        lunarLeap = 1;
      }
    }
  }
  if (lunarMonth > 12) {
    lunarMonth = lunarMonth - 12;
  }
  if (lunarMonth >= 11 && diff < 4) {
    lunarYear -= 1;
  }

  return LunarDate(
    day: lunarDay,
    month: lunarMonth,
    year: lunarYear,
    isLeapMonth: lunarLeap == 1,
  );
}

/* Convert a lunar date to the corresponding solar date */
SolarDate convertLunar2Solar(
  int lunarDay,
  int lunarMonth,
  int lunarYear,
  int lunarLeap,
  double timeZone,
) {
  int k, a11, b11, off, leapOff, leapMonth, monthStart;
  if (lunarMonth < 11) {
    a11 = getLunarMonth11(lunarYear - 1, timeZone);
    b11 = getLunarMonth11(lunarYear, timeZone);
  } else {
    a11 = getLunarMonth11(lunarYear, timeZone);
    b11 = getLunarMonth11(lunarYear + 1, timeZone);
  }
  k = toInt(0.5 + (a11 - 2415021.076998695) / 29.530588853);
  off = lunarMonth - 11;
  if (off < 0) {
    off += 12;
  }
  if (b11 - a11 > 365) {
    leapOff = getLeapMonthOffset(a11, timeZone);
    leapMonth = leapOff - 2;
    if (leapMonth < 0) {
      leapMonth += 12;
    }
    if (lunarLeap != 0 && lunarMonth != leapMonth) {
      return SolarDate(year: 0, month: 0, day: 0);
    } else if (lunarLeap != 0 || off >= leapOff) {
      off += 1;
    }
  }
  monthStart = getNewMoonDay(k + off, timeZone);
  final date = jdToDate(monthStart + lunarDay - 1);
  return SolarDate(year: date[2], month: date[1], day: date[0]);
}
