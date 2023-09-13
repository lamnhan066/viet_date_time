import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:viet_date_time/viet_date_time.dart';

class VietEventList<D extends DateTime> extends Equatable {
  final Map<D, List<VietEvent<D>>> events;

  VietEventList({
    required this.events,
  });

  void add(D date, VietEvent<D> event) {
    final eventsOfDate = events[date];
    if (eventsOfDate == null) {
      events[date] = [event];
    } else {
      eventsOfDate.add(event);
    }
  }

  void addAll(D date, List<VietEvent<D>> events) {
    final eventsOfDate = this.events[date];
    if (eventsOfDate == null) {
      this.events[date] = events;
    } else {
      eventsOfDate.addAll(events);
    }
  }

  bool remove(D date, VietEvent<D> event) {
    final eventsOfDate = events[date];
    return eventsOfDate != null ? eventsOfDate.remove(event) : false;
  }

  List<VietEvent<D>> removeAll(D date) {
    return events.remove(date) ?? [];
  }

  void clear() {
    events.clear();
  }

  List<VietEvent<D>> getEvents(D date) {
    return events[date] ?? [];
  }

  /// Map<D in microsecondsSinceEpoch, List of VietEvent>
  Map<String, dynamic> toMap() {
    final Map<String, List<String>> map = {};
    events.forEach((key, value) {
      map.addAll(
          {key.toIso8601String(): value.map((e) => e.toJson()).toList()});
    });

    return {'events': map};
  }

  factory VietEventList.fromMap(Map<String, dynamic> map) {
    final events = VietEventList<D>(events: {});
    final mapEvents = map['events'] as Map<String, dynamic>;
    mapEvents.forEach((key, value) {
      var dateTime = DateTime.parse(key);
      events.addAll(
        (D == DateTime ? dateTime : dateTime.toVietDateTime) as D,
        (value as List)
            .map((e) => VietEvent<D>.fromJson(e.toString()))
            .toList(),
      );
    });
    return events;
  }

  String toJson() => json.encode(toMap());

  factory VietEventList.fromJson(String source) =>
      VietEventList.fromMap(json.decode(source));

  @override
  String toString() => 'VietEventList(events: $events)';

  @override
  List<Object> get props => [events];
}
