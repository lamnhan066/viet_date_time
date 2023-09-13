import 'package:test/test.dart';
import 'package:viet_date_time/viet_date_time.dart';

void main() {
  test('add', () {
    final now = DateTime.now();
    final future4Days = now.add(Duration(days: 4));

    final lunarNow = now.toVietDateTime;
    final lunarFuture4Days = lunarNow.add(Duration(days: 4));

    expect(future4Days.toVietDateTime, equals(lunarFuture4Days));
  });

  test('subtract', () {
    final now = DateTime.now();
    final past4Days = now.subtract(Duration(days: 4));

    final lunarNow = now.toVietDateTime;
    final lunarPast4Days = lunarNow.subtract(Duration(days: 4));

    expect(past4Days.toVietDateTime, equals(lunarPast4Days));
  });

  test('compareTo', () {
    final now = VietDateTime.now();
    final past4Days = now.subtract(Duration(days: 4));

    expect(now.compareTo(past4Days), greaterThan(0));
    expect(now.toDateTime().compareTo(past4Days), greaterThan(0));
  });
}
