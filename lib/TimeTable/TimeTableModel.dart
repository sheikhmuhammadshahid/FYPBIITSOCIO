import 'dart:convert';

class TimeTableModel {
  String Day;
  String slot;
  String section;
  String teacherName;
  String courseName;
  int id;
  TimeTableModel({
    required this.Day,
    required this.slot,
    required this.section,
    required this.teacherName,
    required this.courseName,
    required this.id,
  });

  TimeTableModel copyWith({
    String? Day,
    String? slot,
    String? section,
    String? teacherName,
    String? courseName,
    int? id,
  }) {
    return TimeTableModel(
      Day: Day ?? this.Day,
      slot: slot ?? this.slot,
      section: section ?? this.section,
      teacherName: teacherName ?? this.teacherName,
      courseName: courseName ?? this.courseName,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'Day': Day});
    result.addAll({'slot': slot});
    result.addAll({'section': section});
    result.addAll({'teacherName': teacherName});
    result.addAll({'courseName': courseName});
    result.addAll({'id': id});

    return result;
  }

  factory TimeTableModel.fromMap(Map<String, dynamic> map) {
    return TimeTableModel(
      Day: map['Day'] ?? '',
      slot: map['slot'] ?? '',
      section: map['section'] ?? '',
      teacherName: map['teacherName'] ?? '',
      courseName: map['courseName'] ?? '',
      id: map['id']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory TimeTableModel.fromJson(String source) =>
      TimeTableModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TimeTableModel(Day: $Day, slot: $slot, section: $section, teacherName: $teacherName, courseName: $courseName, id: $id)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TimeTableModel &&
        other.Day == Day &&
        other.slot == slot &&
        other.section == section &&
        other.teacherName == teacherName &&
        other.courseName == courseName &&
        other.id == id;
  }

  @override
  int get hashCode {
    return Day.hashCode ^
        slot.hashCode ^
        section.hashCode ^
        teacherName.hashCode ^
        courseName.hashCode ^
        id.hashCode;
  }
}
