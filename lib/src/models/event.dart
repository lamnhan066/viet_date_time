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
