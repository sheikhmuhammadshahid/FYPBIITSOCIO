import 'dart:convert';

class TimeTableModel {
  String slot;
  String monday;
  String tuesday;
  String wednesday;
  String thursday;
  String friday;

  String section;
  String teacherName;
  String courseName;
  int id;
  TimeTableModel({
    required this.slot,
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday,
    required this.friday,
    required this.section,
    required this.teacherName,
    required this.courseName,
    required this.id,
  });

  TimeTableModel copyWith({
    String? slot,
    String? monday,
    String? tuesday,
    String? wednesday,
    String? thursday,
    String? friday,
    String? section,
    String? teacherName,
    String? courseName,
    int? id,
  }) {
    return TimeTableModel(
      slot: slot ?? this.slot,
      monday: monday ?? this.monday,
      tuesday: tuesday ?? this.tuesday,
      wednesday: wednesday ?? this.wednesday,
      thursday: thursday ?? this.thursday,
      friday: friday ?? this.friday,
      section: section ?? this.section,
      teacherName: teacherName ?? this.teacherName,
      courseName: courseName ?? this.courseName,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'slot': slot});
    result.addAll({'monday': monday});
    result.addAll({'tuesday': tuesday});
    result.addAll({'wednesday': wednesday});
    result.addAll({'thursday': thursday});
    result.addAll({'friday': friday});
    result.addAll({'section': section});
    result.addAll({'teacherName': teacherName});
    result.addAll({'courseName': courseName});
    result.addAll({'id': id});

    return result;
  }

  factory TimeTableModel.fromMap(Map<String, dynamic> map) {
    return TimeTableModel(
      slot: map['slot'] ?? '',
      monday: map['monday'] ?? '',
      tuesday: map['tuesday'] ?? '',
      wednesday: map['wednesday'] ?? '',
      thursday: map['thursday'] ?? '',
      friday: map['friday'] ?? '',
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
    return 'TimeTableModel(slot: $slot, monday: $monday, tuesday: $tuesday, wednesday: $wednesday, thursday: $thursday, friday: $friday, section: $section, teacherName: $teacherName, courseName: $courseName, id: $id)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TimeTableModel &&
        other.slot == slot &&
        other.monday == monday &&
        other.tuesday == tuesday &&
        other.wednesday == wednesday &&
        other.thursday == thursday &&
        other.friday == friday &&
        other.section == section &&
        other.teacherName == teacherName &&
        other.courseName == courseName &&
        other.id == id;
  }

  @override
  int get hashCode {
    return slot.hashCode ^
        monday.hashCode ^
        tuesday.hashCode ^
        wednesday.hashCode ^
        thursday.hashCode ^
        friday.hashCode ^
        section.hashCode ^
        teacherName.hashCode ^
        courseName.hashCode ^
        id.hashCode;
  }
}
