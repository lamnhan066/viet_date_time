import 'package:viet_date_time/src/base.dart';
import 'package:viet_date_time/src/can_chi.dart';
import 'package:viet_date_time/src/converter.dart';
import 'package:viet_date_time/src/events/lunar_events.dart';
import 'package:viet_date_time/src/events/solar_events.dart';
import 'package:viet_date_time/viet_date_time.dart';

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

  /// Danh sách các ngày lễ âm lịch, thời gian ở đây sẽ sử dụng [VietDateTime].
  static VietEventList<VietEvent> get lunarEvents => getLunarEvents;

  /// Danh sách các ngày lễ dương lịch, thời gian ở đây sẽ sử dụng [DateTime].
  static VietEventList<VietEvent> get solarEvents => getSolarEvents;

  static VietDateTime parse(String formattedString) {
    return VietDateTime.fromDateTime(DateTime.parse(formattedString));
  }

  static VietDateTime? tryParse(String formattedString) {
    final parsed = DateTime.tryParse(formattedString);
    return parsed == null ? null : VietDateTime.fromDateTime(parsed);
  }

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

  /// Giá trị ngày Julian.
  int get julianDayNumber {
    final solar = toDateTime();
    return jdFromDate(solar.day, solar.month, solar.year);
  }

  /// Can chi của năm hiện tại.
  String get canChiOfYear => getCanChiOfYear(year);

  /// Can chi của tháng hiện tại.
  String get canChiOfMonth => getCanChiMonth(month, year);

  /// Can của giờ hiện tại.
  String get canOfHour => getCanOfHour(julianDayNumber);

  /// Can chi của ngày hiện tại.
  String get canChiOfDay => getCanChiOfDay(julianDayNumber);

  /// Giờ hoàng đạo.
  String get luckyHour => getLuckyHour(julianDayNumber);

  /// Tiết khí.
  String get solarTerms => getSolarTerms(julianDayNumber);

  /// Lưu [timeZoneOffset] khi chuyển từ [DateTime], đồng
  Duration? _timeZoneOffset;

  VietDateTime(
    this.isLeapMonth,
    this.year, [
    this.month = 1,
    this.day = 1,
    this.hour = 0,
    this.minute = 0,
    this.second = 0,
    this.millisecond = 0,
    this.microsecond = 0,
  ]);

  factory VietDateTime.fromDateTime(DateTime dateTime) {
    final lunarDate = convertSolar2Lunar(
      dateTime.day,
      dateTime.month,
      dateTime.year,
      dateTime.timeZoneOffset.inMilliseconds / (1000.0 * 60.0 * 60.0),
    );

    return VietDateTime(
      lunarDate.isLeapMonth,
      lunarDate.year,
      lunarDate.month,
      lunarDate.day,
      dateTime.hour,
      dateTime.minute,
      dateTime.second,
      dateTime.millisecond,
      dateTime.microsecond,
    ).._timeZoneOffset = dateTime.timeZoneOffset;
  }

  factory VietDateTime.now() => VietDateTime.fromDateTime(DateTime.now());

  /// Chuyển đổi từ [VietDateTime] sang [DateTime] với tham số [timeZoneOffset]
  /// là độ chênh lệch giữa Local và UTC, mặc định sẽ sử dụng giá trị từ
  /// [DateTime.now].
  DateTime toDateTime([Duration? timeZoneOffset]) {
    timeZoneOffset ??= this.timeZoneOffset;
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
    return VietDateTime.fromDateTime(toDateTime().add(duration));
  }

  @override
  VietDateTime subtract(Duration duration) {
    return VietDateTime.fromDateTime(toDateTime().subtract(duration));
  }

  @override
  int compareTo(DateTime other) {
    DateTime dateTime = other;
    if (other is VietDateTime) {
      dateTime = other.toDateTime();
    }

    return toDateTime().compareTo(dateTime);
  }

  @override
  Duration difference(DateTime other) {
    DateTime dateTime = other;
    if (other is VietDateTime) {
      dateTime = other.toDateTime();
    }

    return toDateTime().difference(dateTime);
  }

  @override
  bool isAfter(DateTime other) {
    DateTime dateTime = other;
    if (other is VietDateTime) {
      dateTime = other.toDateTime();
    }

    return toDateTime().isAfter(dateTime);
  }

  @override
  bool isAtSameMomentAs(DateTime other) {
    DateTime dateTime = other;
    if (other is VietDateTime) {
      dateTime = other.toDateTime();
    }

    return toDateTime().isAtSameMomentAs(dateTime);
  }

  @override
  bool isBefore(DateTime other) {
    DateTime dateTime = other;
    if (other is VietDateTime) {
      dateTime = other.toDateTime();
    }

    return toDateTime().isBefore(dateTime);
  }

  @override
  bool get isUtc => toDateTime().isUtc;

  @override
  int get microsecondsSinceEpoch => toDateTime().microsecondsSinceEpoch;

  @override
  int get millisecondsSinceEpoch => toDateTime().millisecondsSinceEpoch;

  @override
  String get timeZoneName => toDateTime().timeZoneName;

  @override
  Duration get timeZoneOffset =>
      _timeZoneOffset ?? DateTime.now().timeZoneOffset;

  @override
  String toIso8601String() {
    return toDateTime().toIso8601String();
  }

  @override
  DateTime toLocal() {
    return toDateTime().toLocal();
  }

  @override
  DateTime toUtc() {
    return toDateTime().toUtc();
  }

  @override
  int get weekday => toDateTime().weekday;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is VietDateTime &&
        other.isLeapMonth == isLeapMonth &&
        other.year == year &&
        other.month == month &&
        other.day == day &&
        other.hour == hour &&
        other.minute == minute &&
        other.second == second &&
        other.millisecond == millisecond &&
        other.microsecond == microsecond &&
        other._timeZoneOffset == _timeZoneOffset;
  }

  @override
  int get hashCode {
    return isLeapMonth.hashCode ^
        year.hashCode ^
        month.hashCode ^
        day.hashCode ^
        hour.hashCode ^
        minute.hashCode ^
        second.hashCode ^
        millisecond.hashCode ^
        microsecond.hashCode ^
        _timeZoneOffset.hashCode;
  }
}
