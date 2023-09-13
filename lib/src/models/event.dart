import 'dart:convert';

class VietEvent {
  final DateTime date;
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
    DateTime? date,
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
      'date': date.millisecondsSinceEpoch,
      'title': title,
      'description': description,
      'location': location,
      'id': id,
    };
  }

  factory VietEvent.fromMap(Map<String, dynamic> map) {
    return VietEvent(
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
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
  bool operator ==(dynamic other) {
    return date == other.date &&
        title == other.title &&
        description == other.description &&
        location == other.location &&
        id == other.id;
  }

  @override
  int get hashCode => Object.hash(date, description, location, title, id);
}
