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

  group('Events', () {
    test('VietEvent', () {
      final event =
          VietEvent<DateTime>(date: DateTime.now(), title: 'test title');
      final json = event.toJson();

      final event1 = VietEvent<VietDateTime>(
          date: VietDateTime.now(), title: 'test 1 title');
      final json1 = event1.toJson();

      expect(VietEvent<DateTime>.fromJson(json), equals(event));
      expect(VietEvent<VietDateTime>.fromJson(json1), equals(event1));
    });

    test('VietEventList', () {
      final events = VietEventList<DateTime>(
        events: {
          DateTime.now(): [VietEvent(date: DateTime.now())]
        },
      );

      final json = events.toJson();

      final events1 = VietEventList<VietDateTime>(
        events: {
          VietDateTime.now(): [VietEvent(date: VietDateTime.now())]
        },
      );
      final json1 = events.toJson();

      expect(VietEventList<DateTime>.fromJson(json), equals(events));
      expect(VietEventList<VietDateTime>.fromJson(json1), equals(events1));
    });
  });
}
