import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:viet_date_time/viet_date_time.dart';

class VietEvent<D extends DateTime> extends Equatable {
  final D date;
  final String? title;
  final String? description;
  final String? location;
  final int? id;
  VietEvent({
    this.id,
    required this.date,
    this.title,
    this.description,
    this.location,
  });

  VietEvent copyWith({
    D? date,
    String? title,
    String? description,
    String? location,
    int? id,
  }) {
    return VietEvent(
      date: date ?? this.date,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'title': title,
      'description': description,
      'location': location,
      'id': id,
    };
  }

  factory VietEvent.fromMap(Map<String, dynamic> map) {
    final date = DateTime.parse(map['date']);
    return VietEvent(
      date: (D == DateTime ? date : date.toVietDateTime) as D,
      title: map['title'],
      description: map['description'],
      location: map['location'],
      id: map['id']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory VietEvent.fromJson(String source) =>
      VietEvent.fromMap(json.decode(source));

  @override
  String toString() {
    return 'VietEvent(date: $date, title: $title, description: $description, location: $location, id: $id)';
  }

  @override
  List<Object> get props {
    return [
      date,
      title ?? '',
      description ?? '',
      location ?? '',
      id ?? '',
    ];
  }
}
