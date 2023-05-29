import 'dart:convert';

import 'package:flutter/foundation.dart';

class TimeTableSlot {
  String data;
  String slot;
  TimeTableSlot({
    required this.data,
    required this.slot,
  });

  TimeTableSlot copyWith({
    String? data,
    String? slot,
  }) {
    return TimeTableSlot(
      data: data ?? this.data,
      slot: slot ?? this.slot,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'data': data});
    result.addAll({'slot': slot});

    return result;
  }

  factory TimeTableSlot.fromMap(Map<String, dynamic> map) {
    return TimeTableSlot(
      data: map['data'] ?? '',
      slot: map['slot'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory TimeTableSlot.fromJson(String source) =>
      TimeTableSlot.fromMap(json.decode(source));

  @override
  String toString() => 'TimeTableSlot(data: $data, slot: $slot)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TimeTableSlot && other.data == data && other.slot == slot;
  }

  @override
  int get hashCode => data.hashCode ^ slot.hashCode;
}

class TimeTableModel {
  List<String> slot = [];
  List<String>? venue = [];
  List<String>? teacher = [];
  List<TimeTableSlot> monday = [];
  List<TimeTableSlot> tuesday = [];
  List<TimeTableSlot> wednesday = [];
  List<TimeTableSlot> thursday = [];
  List<TimeTableSlot> friday = [];
  TimeTableModel({
    required this.slot,
    this.venue,
    this.teacher,
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday,
    required this.friday,
  });

  TimeTableModel copyWith({
    List<String>? slot,
    List<String>? venue,
    List<String>? teacher,
    List<TimeTableSlot>? monday,
    List<TimeTableSlot>? tuesday,
    List<TimeTableSlot>? wednesday,
    List<TimeTableSlot>? thursday,
    List<TimeTableSlot>? friday,
  }) {
    return TimeTableModel(
      slot: slot ?? this.slot,
      venue: venue ?? this.venue,
      teacher: teacher ?? this.teacher,
      monday: monday ?? this.monday,
      tuesday: tuesday ?? this.tuesday,
      wednesday: wednesday ?? this.wednesday,
      thursday: thursday ?? this.thursday,
      friday: friday ?? this.friday,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'slot': slot});
    if (venue != null) {
      result.addAll({'venue': venue});
    }
    if (teacher != null) {
      result.addAll({'teacher': teacher});
    }
    result.addAll({'monday': monday.map((x) => x.toMap()).toList()});
    result.addAll({'tuesday': tuesday.map((x) => x.toMap()).toList()});
    result.addAll({'wednesday': wednesday.map((x) => x.toMap()).toList()});
    result.addAll({'thursday': thursday.map((x) => x.toMap()).toList()});
    result.addAll({'friday': friday.map((x) => x.toMap()).toList()});

    return result;
  }

  factory TimeTableModel.fromMap(Map<String, dynamic> map) {
    return TimeTableModel(
      slot: List<String>.from(map['slot']),
      venue: List<String>.from(map['venue']),
      teacher: List<String>.from(map['teacher']),
      monday: List<TimeTableSlot>.from(
          map['monday']?.map((x) => TimeTableSlot.fromMap(x))),
      tuesday: List<TimeTableSlot>.from(
          map['tuesday']?.map((x) => TimeTableSlot.fromMap(x))),
      wednesday: List<TimeTableSlot>.from(
          map['wednesday']?.map((x) => TimeTableSlot.fromMap(x))),
      thursday: List<TimeTableSlot>.from(
          map['thursday']?.map((x) => TimeTableSlot.fromMap(x))),
      friday: List<TimeTableSlot>.from(
          map['friday']?.map((x) => TimeTableSlot.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory TimeTableModel.fromJson(String source) =>
      TimeTableModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TimeTableModel(slot: $slot, venue: $venue, teacher: $teacher, monday: $monday, tuesday: $tuesday, wednesday: $wednesday, thursday: $thursday, friday: $friday)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TimeTableModel &&
        listEquals(other.slot, slot) &&
        listEquals(other.venue, venue) &&
        listEquals(other.teacher, teacher) &&
        listEquals(other.monday, monday) &&
        listEquals(other.tuesday, tuesday) &&
        listEquals(other.wednesday, wednesday) &&
        listEquals(other.thursday, thursday) &&
        listEquals(other.friday, friday);
  }

  @override
  int get hashCode {
    return slot.hashCode ^
        venue.hashCode ^
        teacher.hashCode ^
        monday.hashCode ^
        tuesday.hashCode ^
        wednesday.hashCode ^
        thursday.hashCode ^
        friday.hashCode;
  }
}
