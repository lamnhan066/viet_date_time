import 'package:viet_date_time/src/base.dart';
import 'package:viet_date_time/src/can_chi.dart';
import 'package:viet_date_time/src/converter.dart';

class VietDateTime implements DateTime {
  // Weekday constants that are returned by [weekday] method:
  static const int monday = 1;
  static const int tuesday = 2;
  static const int wednesday = 3;
  static const int thursday = 4;
  static const int friday = 5;
  static const int saturday = 6;
  static const int sunday = 7;
  static const int daysPerWeek = 7;

  // Month constants that are returned by the [month] getter.
  static const int january = 1;
  static const int february = 2;
  static const int march = 3;
  static const int april = 4;
  static const int may = 5;
  static const int june = 6;
  static const int july = 7;
  static const int august = 8;
  static const int september = 9;
  static const int october = 10;
  static const int november = 11;
  static const int december = 12;
  static const int monthsPerYear = 12;

  /// Nếu `true` thí tháng hiện tại là tháng nhuần
  final bool isLeapMonth;
  @override
  final int year;
  @override
  final int month;
  @override
  final int day;
  @override
  final int hour;
  @override
  final int minute;
  @override
  final int second;
  @override
  final int millisecond;
  @override
  final int microsecond;

  int get judianDayNumber {
    final solar = toSolar();
    return jdFromDate(solar.day, solar.month, solar.year);
  }

  /// Can chi của năm hiện tại
  String get canChiOfYear => getCanChiOfYear(year);

  /// can chi của tháng hiện tại
  String get canChiOfMonth => getCanChiMonth(month, year);

  /// Can của giờ hiện tại
  String get canOfHour => getCanOfHour(judianDayNumber);

  /// Can chi của ngày hiện tại
  String get canChiOfDay => getCanChiOfDay(judianDayNumber);

  /// Giờ hoàng đạo
  String get luckyHour => getLuckyHour(judianDayNumber);

  /// Tiết khí
  String get solarTerms => getSolarTerms(judianDayNumber);

  VietDateTime({
    required this.isLeapMonth,
    required this.year,
    required this.month,
    required this.day,
    this.hour = 0,
    this.minute = 0,
    this.second = 0,
    this.millisecond = 0,
    this.microsecond = 0,
  });

  factory VietDateTime.fromSolar(DateTime dateTime) {
    final lunarDate = convertSolar2Lunar(
      dateTime.day,
      dateTime.month,
      dateTime.year,
      dateTime.timeZoneOffset.inMilliseconds / (1000.0 * 60.0 * 60.0),
    );

    return VietDateTime(
      isLeapMonth: lunarDate.isLeapMonth,
      year: lunarDate.year,
      month: lunarDate.month,
      day: lunarDate.day,
      hour: dateTime.hour,
      minute: dateTime.minute,
      second: dateTime.second,
      millisecond: dateTime.millisecond,
      microsecond: dateTime.microsecond,
    );
  }

  DateTime toSolar() {
    final solar = convertLunar2Solar(
      day,
      month,
      year,
      isLeapMonth == true ? 1 : 0,
      timeZoneOffset.inMilliseconds / (1000.0 * 60.0 * 60.0),
    );

    return DateTime(
      solar.year,
      solar.month,
      solar.day,
      hour,
      minute,
      second,
      millisecond,
      microsecond,
    );
  }

  @override
  VietDateTime add(Duration duration) {
    return VietDateTime.fromSolar(toSolar().add(duration));
  }

  @override
  int compareTo(DateTime other) {
    return toSolar().compareTo(other);
  }

  @override
  Duration difference(DateTime other) {
    return toSolar().difference(other);
  }

  @override
  bool isAfter(DateTime other) {
    return toSolar().isAfter(other);
  }

  @override
  bool isAtSameMomentAs(DateTime other) {
    return toSolar().isAtSameMomentAs(other);
  }

  @override
  bool isBefore(DateTime other) {
    return toSolar().isBefore(other);
  }

  @override
  bool get isUtc => toSolar().isUtc;

  @override
  int get microsecondsSinceEpoch => toSolar().microsecondsSinceEpoch;

  @override
  int get millisecondsSinceEpoch => toSolar().millisecondsSinceEpoch;

  @override
  VietDateTime subtract(Duration duration) {
    return VietDateTime.fromSolar(toSolar().subtract(duration));
  }

  @override
  String get timeZoneName => toSolar().timeZoneName;

  @override
  Duration get timeZoneOffset => toSolar().timeZoneOffset;

  @override
  String toIso8601String() {
    return toSolar().toIso8601String();
  }

  @override
  DateTime toLocal() {
    return toSolar().toLocal();
  }

  @override
  DateTime toUtc() {
    return toSolar().toUtc();
  }

  @override
  int get weekday => toSolar().weekday;
}
