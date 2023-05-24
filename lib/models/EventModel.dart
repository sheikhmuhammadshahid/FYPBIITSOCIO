import 'dart:convert';

import 'package:flutter/material.dart';

class EventModel {
  String startDate;
  int id;
  String endDate;
  String Name;
  Color? color;
  int colorId;
  EventModel({
    required this.startDate,
    required this.id,
    required this.endDate,
    required this.Name,
    this.color,
    required this.colorId,
  });

  EventModel copyWith({
    String? startDate,
    int? id,
    String? endDate,
    String? Name,
    Color? color,
    int? colorId,
  }) {
    return EventModel(
      startDate: startDate ?? this.startDate,
      id: id ?? this.id,
      endDate: endDate ?? this.endDate,
      Name: Name ?? this.Name,
      color: color ?? this.color,
      colorId: colorId ?? this.colorId,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'startDate': startDate});
    result.addAll({'id': id});
    result.addAll({'endDate': endDate});
    result.addAll({'Name': Name});
    if (color != null) {
      result.addAll({'color': color!.value});
    }
    result.addAll({'colorId': colorId});

    return result;
  }

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      startDate: map['startDate'] ?? '',
      id: map['id']?.toInt() ?? 0,
      endDate: map['endDate'] ?? '',
      Name: map['Name'] ?? '',
      color: map['color'] != null ? Color(map['color']) : null,
      colorId: map['colorId']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory EventModel.fromJson(String source) =>
      EventModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'EventModel(startDate: $startDate, id: $id, endDate: $endDate, Name: $Name, color: $color, colorId: $colorId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EventModel &&
        other.startDate == startDate &&
        other.id == id &&
        other.endDate == endDate &&
        other.Name == Name &&
        other.color == color &&
        other.colorId == colorId;
  }

  @override
  int get hashCode {
    return startDate.hashCode ^
        id.hashCode ^
        endDate.hashCode ^
        Name.hashCode ^
        color.hashCode ^
        colorId.hashCode;
  }
}
