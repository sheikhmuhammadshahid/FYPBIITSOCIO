import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'Stories.dart';

class Society {
  int id;
  String name;
  String profileImage;
  List<Stories>? stories;
  int storiesCount;
  Society({
    required this.id,
    required this.name,
    required this.profileImage,
    this.stories,
    required this.storiesCount,
  });

  Society copyWith({
    int? id,
    String? name,
    String? profileImage,
    List<Stories>? stories,
    int? storiesCount,
  }) {
    return Society(
      id: id ?? this.id,
      name: name ?? this.name,
      profileImage: profileImage ?? this.profileImage,
      stories: stories ?? this.stories,
      storiesCount: storiesCount ?? this.storiesCount,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'name': name});
    result.addAll({'profileImage': profileImage});
    if (stories != null) {
      result.addAll({'stories': stories!.map((x) => x.toMap()).toList()});
    }
    result.addAll({'storiesCount': storiesCount});

    return result;
  }

  factory Society.fromMap(Map<String, dynamic> map) {
    return Society(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      profileImage: map['profileImage'] ?? '',
      stories: map['stories'] != null
          ? List<Stories>.from(map['stories']?.map((x) => Stories.fromMap(x)))
          : null,
      storiesCount: map['storiesCount']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Society.fromJson(String source) =>
      Society.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Society(id: $id, name: $name, profileImage: $profileImage, stories: $stories, storiesCount: $storiesCount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Society &&
        other.id == id &&
        other.name == name &&
        other.profileImage == profileImage &&
        listEquals(other.stories, stories) &&
        other.storiesCount == storiesCount;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        profileImage.hashCode ^
        stories.hashCode ^
        storiesCount.hashCode;
  }
}
