import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:biit_social/models/User/UserModel.dart';

class DropDownModel {
  String category;
  List<String> data = [];
  List<User> users = [];
  bool isString;
  DropDownModel({
    required this.category,
    required this.data,
    required this.users,
    required this.isString,
  });

  DropDownModel copyWith({
    String? category,
    List<String>? data,
    List<User>? users,
    bool? isString,
  }) {
    return DropDownModel(
      category: category ?? this.category,
      data: data ?? this.data,
      users: users ?? this.users,
      isString: isString ?? this.isString,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'category': category});
    result.addAll({'data': data});
    result.addAll({'users': users.map((x) => x.toMap()).toList()});
    result.addAll({'isString': isString});

    return result;
  }

  factory DropDownModel.fromMap(Map<String, dynamic> map) {
    return DropDownModel(
      category: map['category'] ?? '',
      data: List<String>.from(map['data']),
      users: List<User>.from(map['users']?.map((x) => User.fromMap(x))),
      isString: map['isString'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory DropDownModel.fromJson(String source) =>
      DropDownModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'DropDownModel(category: $category, data: $data, users: $users, isString: $isString)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DropDownModel &&
        other.category == category &&
        listEquals(other.data, data) &&
        listEquals(other.users, users) &&
        other.isString == isString;
  }

  @override
  int get hashCode {
    return category.hashCode ^
        data.hashCode ^
        users.hashCode ^
        isString.hashCode;
  }
}
