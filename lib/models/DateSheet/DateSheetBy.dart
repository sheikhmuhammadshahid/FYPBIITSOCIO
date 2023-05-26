import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:biit_social/models/DateSheet/DateSheet.dart';

class DateSheetBy {
  List<DateSheet> dateSheet = [];

  String time;
  String venue;
  DateSheetBy({
    required this.dateSheet,
    required this.time,
    required this.venue,
  });

  DateSheetBy copyWith({
    List<DateSheet>? dateSheet,
    String? time,
    String? venue,
  }) {
    return DateSheetBy(
      dateSheet: dateSheet ?? this.dateSheet,
      time: time ?? this.time,
      venue: venue ?? this.venue,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'dateSheet': dateSheet.map((x) => x.toMap()).toList()});
    result.addAll({'time': time});
    result.addAll({'venue': venue});

    return result;
  }

  factory DateSheetBy.fromMap(Map<String, dynamic> map) {
    return DateSheetBy(
      dateSheet: List<DateSheet>.from(
          map['dateSheet']?.map((x) => DateSheet.fromMap(x))),
      time: map['time'] ?? '',
      venue: map['venue'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory DateSheetBy.fromJson(String source) =>
      DateSheetBy.fromMap(json.decode(source));

  @override
  String toString() =>
      'DateSheetBy(dateSheet: $dateSheet, time: $time, venue: $venue)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DateSheetBy &&
        listEquals(other.dateSheet, dateSheet) &&
        other.time == time &&
        other.venue == venue;
  }

  @override
  int get hashCode => dateSheet.hashCode ^ time.hashCode ^ venue.hashCode;
}
