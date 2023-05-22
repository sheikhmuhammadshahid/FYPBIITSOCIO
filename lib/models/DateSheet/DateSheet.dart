import 'dart:convert';

class DateSheet {
  String Time;
  String day;
  String examType;
  int id;
  String paper;
  String section;
  String venue;
  DateSheet({
    required this.Time,
    required this.day,
    required this.examType,
    required this.id,
    required this.paper,
    required this.section,
    required this.venue,
  });

  DateSheet copyWith({
    String? Time,
    String? day,
    String? examType,
    int? id,
    String? paper,
    String? section,
    String? venue,
  }) {
    return DateSheet(
      Time: Time ?? this.Time,
      day: day ?? this.day,
      examType: examType ?? this.examType,
      id: id ?? this.id,
      paper: paper ?? this.paper,
      section: section ?? this.section,
      venue: venue ?? this.venue,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'Time': Time});
    result.addAll({'day': day});
    result.addAll({'examType': examType});
    result.addAll({'id': id});
    result.addAll({'paper': paper});
    result.addAll({'section': section});
    result.addAll({'venue': venue});

    return result;
  }

  factory DateSheet.fromMap(Map<String, dynamic> map) {
    return DateSheet(
      Time: map['Time'] ?? '',
      day: map['day'] ?? '',
      examType: map['examType'] ?? '',
      id: map['id']?.toInt() ?? 0,
      paper: map['paper'] ?? '',
      section: map['section'] ?? '',
      venue: map['venue'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory DateSheet.fromJson(String source) =>
      DateSheet.fromMap(json.decode(source));

  @override
  String toString() {
    return 'DateSheet(Time: $Time, day: $day, examType: $examType, id: $id, paper: $paper, section: $section, venue: $venue)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DateSheet &&
        other.Time == Time &&
        other.day == day &&
        other.examType == examType &&
        other.id == id &&
        other.paper == paper &&
        other.section == section &&
        other.venue == venue;
  }

  @override
  int get hashCode {
    return Time.hashCode ^
        day.hashCode ^
        examType.hashCode ^
        id.hashCode ^
        paper.hashCode ^
        section.hashCode ^
        venue.hashCode;
  }
}
