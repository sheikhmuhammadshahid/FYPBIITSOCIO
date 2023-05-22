import 'dart:convert';

import 'package:flutter/material.dart';

class EventModel {
  String startDate;
  int id;
  String endDate;
  String Name;
  Color? color;
  EventModel({
    required this.startDate,
    required this.id,
    required this.endDate,
    required this.Name,
    this.color,
  });

  EventModel copyWith({
    String? startDate,
    int? id,
    String? endDate,
    String? Name,
  }) {
    return EventModel(
      startDate: startDate ?? this.startDate,
      id: id ?? this.id,
      endDate: endDate ?? this.endDate,
      Name: Name ?? this.Name,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'startDate': startDate});
    result.addAll({'id': id});
    result.addAll({'endDate': endDate});
    result.addAll({'Name': Name});

    return result;
  }

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      startDate: map['startDate'] ?? '',
      id: map['id']?.toInt() ?? 0,
      endDate: map['endDate'] ?? '',
      Name: map['Name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory EventModel.fromJson(String source) =>
      EventModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'EventModel(startDate: $startDate, id: $id, endDate: $endDate, Name: $Name)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EventModel &&
        other.startDate == startDate &&
        other.id == id &&
        other.endDate == endDate &&
        other.Name == Name;
  }

  @override
  int get hashCode {
    return startDate.hashCode ^ id.hashCode ^ endDate.hashCode ^ Name.hashCode;
  }
}
