import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'User/UserModel.dart';

class Group {
  int id;
  String description;
  String Admin;
  String name;
  String profile;
  String? date;
  int? memberCount;
  bool? isMuted;
  List<User>? enreolledUsers = [];
  bool? isOfficial;
  Group({
    required this.id,
    required this.description,
    required this.Admin,
    required this.name,
    required this.profile,
    this.date,
    this.memberCount,
    this.isMuted,
    this.enreolledUsers,
    this.isOfficial,
  });

  Group copyWith({
    int? id,
    String? description,
    String? Admin,
    String? name,
    String? profile,
    String? date,
    int? memberCount,
    bool? isMuted,
    List<User>? enreolledUsers,
    bool? isOfficial,
  }) {
    return Group(
      id: id ?? this.id,
      description: description ?? this.description,
      Admin: Admin ?? this.Admin,
      name: name ?? this.name,
      profile: profile ?? this.profile,
      date: date ?? this.date,
      memberCount: memberCount ?? this.memberCount,
      isMuted: isMuted ?? this.isMuted,
      enreolledUsers: enreolledUsers ?? this.enreolledUsers,
      isOfficial: isOfficial ?? this.isOfficial,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'description': description});
    result.addAll({'Admin': Admin});
    result.addAll({'name': name});
    result.addAll({'profile': profile});
    if (date != null) {
      result.addAll({'date': date});
    }
    if (memberCount != null) {
      result.addAll({'memberCount': memberCount});
    }
    if (isMuted != null) {
      result.addAll({'isMuted': isMuted});
    }
    if (enreolledUsers != null) {
      result.addAll(
          {'enreolledUsers': enreolledUsers!.map((x) => x.toMap()).toList()});
    }
    if (isOfficial != null) {
      result.addAll({'isOfficial': isOfficial});
    }

    return result;
  }

  factory Group.fromMap(Map<String, dynamic> map) {
    return Group(
      id: map['id']?.toInt() ?? 0,
      description: map['description'] ?? '',
      Admin: map['Admin'] ?? '',
      name: map['name'] ?? '',
      profile: map['profile'] ?? '',
      date: map['date'],
      memberCount: map['memberCount']?.toInt(),
      isMuted: map['isMuted'],
      enreolledUsers: map['enreolledUsers'] != null
          ? List<User>.from(map['enreolledUsers']?.map((x) => User.fromMap(x)))
          : null,
      isOfficial: map['isOfficial'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Group.fromJson(String source) => Group.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Group(id: $id, description: $description, Admin: $Admin, name: $name, profile: $profile, date: $date, memberCount: $memberCount, isMuted: $isMuted, enreolledUsers: $enreolledUsers, isOfficial: $isOfficial)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Group &&
        other.id == id &&
        other.description == description &&
        other.Admin == Admin &&
        other.name == name &&
        other.profile == profile &&
        other.date == date &&
        other.memberCount == memberCount &&
        other.isMuted == isMuted &&
        listEquals(other.enreolledUsers, enreolledUsers) &&
        other.isOfficial == isOfficial;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        description.hashCode ^
        Admin.hashCode ^
        name.hashCode ^
        profile.hashCode ^
        date.hashCode ^
        memberCount.hashCode ^
        isMuted.hashCode ^
        enreolledUsers.hashCode ^
        isOfficial.hashCode;
  }
}
