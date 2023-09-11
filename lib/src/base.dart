/* Compute the (integral) Julian day number of day dd/mm/yyyy, i.e., the number
 * of days between 1/1/4713 BC (Julian calendar) and dd/mm/yyyy.
 * Formula from http://www.tondering.dk/claus/calendar.html
 */
import 'dart:math';

import 'package:viet_date_time/src/utils.dart';

int jdFromDate(int dd, int mm, int yy) {
  int a, y, m, jd;
  a = toInt((14 - mm) / 12);
  y = yy + 4800 - a;
  m = mm + 12 * a - 3;
  jd = dd +
      toInt((153 * m + 2) / 5) +
      365 * y +
      toInt(y / 4) -
      toInt(y / 100) +
      toInt(y / 400) -
      32045;
  if (jd < 2299161) {
    jd = dd + toInt((153 * m + 2) / 5) + 365 * y + toInt(y / 4) - 32083;
  }
  return jd;
}

/* Convert a Julian day number to day/month/year. Parameter jd is an integer */
List<int> jdToDate(int jd) {
  int a, b, c, d, e, m, day, month, year;
  if (jd > 2299160) {
    // After 5/10/1582, Gregorian calendar
    a = jd + 32044;
    b = toInt((4 * a + 3) / 146097);
    c = a - toInt((b * 146097) / 4);
  } else {
    b = 0;
    c = jd + 32082;
  }
  d = toInt((4 * c + 3) / 1461);
  e = c - toInt((1461 * d) / 4);
  m = toInt((5 * e + 2) / 153);
  day = e - toInt((153 * m + 2) / 5) + 1;
  month = m + 3 - 12 * toInt(m / 10);
  year = b * 100 + d - 4800 + toInt(m / 10);
  return <int>[day, month, year];
}

/* Compute the time of the k-th new moon after the new moon of 1/1/1900 13:52 UCT
 * (measured as the number of days since 1/1/4713 BC noon UCT, e.g., 2451545.125 is 1/1/2000 15:00 UTC).
 * Returns a floating number, e.g., 2415079.9758617813 for k=2 or 2414961.935157746 for k=-2
 * Algorithm from: "Astronomical Algorithms" by Jean Meeus, 1998
 */
double newMoon(int k) {
  double t, t2, t3, dr, jd1, m, mpr, f, c1, deltat, jdNew;
  t = k / 1236.85; // Time in Julian centuries from 1900 January 0.5
  t2 = t * t;
  t3 = t2 * t;
  dr = pi / 180;
  jd1 = 2415020.75933 + 29.53058868 * k + 0.0001178 * t2 - 0.000000155 * t3;
  jd1 = jd1 +
      0.00033 *
          sin((166.56 + 132.87 * t - 0.009173 * t2) * dr); // Mean new moon
  m = 359.2242 +
      29.10535608 * k -
      0.0000333 * t2 -
      0.00000347 * t3; // Sun's mean anomaly
  mpr = 306.0253 +
      385.81691806 * k +
      0.0107306 * t2 +
      0.00001236 * t3; // Moon's mean anomaly
  f = 21.2964 +
      390.67050646 * k -
      0.0016528 * t2 -
      0.00000239 * t3; // Moon's argument of latitude
  c1 = (0.1734 - 0.000393 * t) * sin(m * dr) + 0.0021 * sin(2 * dr * m);
  c1 = c1 - 0.4068 * sin(mpr * dr) + 0.0161 * sin(dr * 2 * mpr);
  c1 = c1 - 0.0004 * sin(dr * 3 * mpr);
  c1 = c1 + 0.0104 * sin(dr * 2 * f) - 0.0051 * sin(dr * (m + mpr));
  c1 = c1 - 0.0074 * sin(dr * (m - mpr)) + 0.0004 * sin(dr * (2 * f + m));
  c1 = c1 - 0.0004 * sin(dr * (2 * f - m)) - 0.0006 * sin(dr * (2 * f + mpr));
  c1 = c1 + 0.0010 * sin(dr * (2 * f - mpr)) + 0.0005 * sin(dr * (2 * mpr + m));
  if (t < -11) {
    deltat = 0.001 +
        0.000839 * t +
        0.0002261 * t2 -
        0.00000845 * t3 -
        0.000000081 * t * t3;
  } else {
    deltat = -0.000278 + 0.000265 * t + 0.000262 * t2;
  }

  jdNew = jd1 + c1 - deltat;
  return jdNew;
}

/* Compute the longitude of the sun at any time.
 * Parameter: floating number jdn, the number of days since 1/1/4713 BC noon
 * Algorithm from: "Astronomical Algorithms" by Jean Meeus, 1998
 */
double sunLongitude(double jdn) {
  double t, t2, dr, m, l0, dL, l;
  t = (jdn - 2451545.0) /
      36525; // Time in Julian centuries from 2000-01-01 12:00:00 GMT
  t2 = t * t;
  dr = pi / 180; // degree to radian
  m = 357.52910 +
      35999.05030 * t -
      0.0001559 * t2 -
      0.00000048 * t * t2; // mean anomaly, degree
  l0 = 280.46645 + 36000.76983 * t + 0.0003032 * t2; // mean longitude, degree
  dL = (1.914600 - 0.004817 * t - 0.000014 * t2) * sin(dr * m);
  dL = dL +
      (0.019993 - 0.000101 * t) * sin(dr * 2 * m) +
      0.000290 * sin(dr * 3 * m);
  l = l0 + dL; // true longitude, degree
  l = l * dr;
  l = l - pi * 2 * (toInt(l / (pi * 2))); // Normalize to (0, 2*pi)
  return l;
}

/* Compute sun position at midnight of the day with the given Julian day number.
 * The time zone if the time difference between local time and UTC: 7.0 for UTC+7:00.
 * The  returns a number between 0 and 11.
 * From the day after March equinox and the 1st major term after March equinox, 0 is returned.
 * After that, return 1, 2, 3 ...
 */
int getSunLongitude(int dayNumber, double timeZone) {
  return toInt(sunLongitude(dayNumber - 0.5 - timeZone / 24) / pi * 6);
}

/* Compute the day of the k-th new moon in the given time zone.
 * The time zone if the time difference between local time and UTC: 7.0 for UTC+7:00
 */
int getNewMoonDay(int k, double timeZone) {
  return toInt(newMoon(k) + 0.5 + timeZone / 24);
}

/* Find the day that starts the luner month 11 of the given year for the given time zone */
int getLunarMonth11(int yy, double timeZone) {
  int k, off, nm, sunLong;
  //off = jdFromDate(31, 12, yy) - 2415021.076998695;
  off = jdFromDate(31, 12, yy) - 2415021;
  k = toInt(off / 29.530588853);
  nm = getNewMoonDay(k, timeZone);
  sunLong = getSunLongitude(nm, timeZone); // sun longitude at local midnight
  if (sunLong >= 9) {
    nm = getNewMoonDay(k - 1, timeZone);
  }
  return nm;
}

/* Find the index of the leap month after the month starting on the day a11. */
int getLeapMonthOffset(int a11, double timeZone) {
  int k, last, arc, i;
  k = toInt((a11 - 2415021.076998695) / 29.530588853 + 0.5);
  last = 0;
  i = 1; // We start with the month following lunar month 11
  arc = getSunLongitude(getNewMoonDay(k + i, timeZone), timeZone);
  do {
    last = arc;
    i++;
    arc = getSunLongitude(getNewMoonDay(k + i, timeZone), timeZone);
  } while (arc != last && i < 14);
  return i - 1;
}
