import 'dart:convert';

import 'package:flutter/foundation.dart';

class SVCommentModel {
  String? name;
  String? profileImage;
  String? time;
  int id;
  String? comment;
  List<SVCommentModel>? replies = [];
  int? likeCount;
  bool? isCommentReply;
  bool? like;
  SVCommentModel({
    this.name,
    this.profileImage,
    this.time,
    required this.id,
    this.comment,
    this.replies,
    this.likeCount,
    this.isCommentReply,
    this.like,
  });

  SVCommentModel copyWith({
    String? name,
    String? profileImage,
    String? time,
    int? id,
    String? comment,
    List<SVCommentModel>? replies,
    int? likeCount,
    bool? isCommentReply,
    bool? like,
  }) {
    return SVCommentModel(
      name: name ?? this.name,
      profileImage: profileImage ?? this.profileImage,
      time: time ?? this.time,
      id: id ?? this.id,
      comment: comment ?? this.comment,
      replies: replies ?? this.replies,
      likeCount: likeCount ?? this.likeCount,
      isCommentReply: isCommentReply ?? this.isCommentReply,
      like: like ?? this.like,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (name != null) {
      result.addAll({'name': name});
    }
    if (profileImage != null) {
      result.addAll({'profileImage': profileImage});
    }
    if (time != null) {
      result.addAll({'time': time});
    }
    result.addAll({'id': id});
    if (comment != null) {
      result.addAll({'comment': comment});
    }
    if (replies != null) {
      result.addAll({'replies': replies!.map((x) => x.toMap()).toList()});
    }
    if (likeCount != null) {
      result.addAll({'likeCount': likeCount});
    }
    if (isCommentReply != null) {
      result.addAll({'isCommentReply': isCommentReply});
    }
    if (like != null) {
      result.addAll({'like': like});
    }

    return result;
  }

  factory SVCommentModel.fromMap(Map<String, dynamic> map) {
    return SVCommentModel(
      name: map['userData']['name'],
      profileImage: map['userData']['profileImage'],
      time: map['time'],
      id: map['id']?.toInt() ?? 0,
      comment: map['comment'],
      replies: map['replies'] != null
          ? List<SVCommentModel>.from(
              map['replies']?.map((x) => SVCommentModel.fromMap(x)))
          : null,
      likeCount: map['likeCount']?.toInt(),
      isCommentReply: map['isCommentReply'],
      like: map['like'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SVCommentModel.fromJson(String source) =>
      SVCommentModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SVCommentModel(name: $name, profileImage: $profileImage, time: $time, id: $id, comment: $comment, replies: $replies, likeCount: $likeCount, isCommentReply: $isCommentReply, like: $like)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SVCommentModel &&
        other.name == name &&
        other.profileImage == profileImage &&
        other.time == time &&
        other.id == id &&
        other.comment == comment &&
        listEquals(other.replies, replies) &&
        other.likeCount == likeCount &&
        other.isCommentReply == isCommentReply &&
        other.like == like;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        profileImage.hashCode ^
        time.hashCode ^
        id.hashCode ^
        comment.hashCode ^
        replies.hashCode ^
        likeCount.hashCode ^
        isCommentReply.hashCode ^
        like.hashCode;
  }
}
