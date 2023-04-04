import 'dart:convert';

class Group {
  int id;
  String Admin;
  String name;
  String profile;
  bool? isOfficial;
  Group({
    required this.id,
    required this.Admin,
    required this.name,
    required this.profile,
    this.isOfficial,
  });

  Group copyWith({
    int? id,
    String? Admin,
    String? name,
    String? profile,
    bool? isOfficial,
  }) {
    return Group(
      id: id ?? this.id,
      Admin: Admin ?? this.Admin,
      name: name ?? this.name,
      profile: profile ?? this.profile,
      isOfficial: isOfficial ?? this.isOfficial,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'Admin': Admin});
    result.addAll({'name': name});
    result.addAll({'profile': profile});
    if (isOfficial != null) {
      result.addAll({'isOfficial': isOfficial});
    }

    return result;
  }

  factory Group.fromMap(Map<String, dynamic> map) {
    return Group(
      id: map['id']?.toInt() ?? 0,
      Admin: map['Admin'] ?? '',
      name: map['name'] ?? '',
      profile: map['profile'] ?? '',
      isOfficial: map['isOfficial'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Group.fromJson(String source) => Group.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Group(id: $id, Admin: $Admin, name: $name, profile: $profile, isOfficial: $isOfficial)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Group &&
        other.id == id &&
        other.Admin == Admin &&
        other.name == name &&
        other.profile == profile &&
        other.isOfficial == isOfficial;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        Admin.hashCode ^
        name.hashCode ^
        profile.hashCode ^
        isOfficial.hashCode;
  }
}
