import 'dart:convert';

import 'package:biit_social/models/User/UserModel.dart';

class Post {
  int? id;
  String postedBy;
  String dateTime;
  String description;
  String text;
  int? likes;
  String user;
  User? userPosted;
  bool? isPinned;
  String postFor;
  bool? isFriend = false;
  bool? isLiked = false;
  String type;
  int? likesCount;
  int? CommentsCount;
  String fromWall;
  Post({
    this.id,
    required this.postedBy,
    required this.dateTime,
    required this.description,
    required this.text,
    this.likes,
    required this.user,
    this.userPosted,
    this.isPinned,
    required this.postFor,
    this.isFriend,
    this.isLiked,
    required this.type,
    this.likesCount,
    this.CommentsCount,
    required this.fromWall,
  });

  Post copyWith({
    int? id,
    String? postedBy,
    String? dateTime,
    String? description,
    String? text,
    int? likes,
    String? user,
    User? userPosted,
    bool? isPinned,
    String? postFor,
    bool? isFriend,
    bool? isLiked,
    String? type,
    int? likesCount,
    int? CommentsCount,
    String? fromWall,
  }) {
    return Post(
      id: id ?? this.id,
      postedBy: postedBy ?? this.postedBy,
      dateTime: dateTime ?? this.dateTime,
      description: description ?? this.description,
      text: text ?? this.text,
      likes: likes ?? this.likes,
      user: user ?? this.user,
      userPosted: userPosted ?? this.userPosted,
      isPinned: isPinned ?? this.isPinned,
      postFor: postFor ?? this.postFor,
      isFriend: isFriend ?? this.isFriend,
      isLiked: isLiked ?? this.isLiked,
      type: type ?? this.type,
      likesCount: likesCount ?? this.likesCount,
      CommentsCount: CommentsCount ?? this.CommentsCount,
      fromWall: fromWall ?? this.fromWall,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (id != null) {
      result.addAll({'id': id});
    }
    result.addAll({'postedBy': postedBy});
    result.addAll({'dateTime': dateTime});
    result.addAll({'description': description});
    result.addAll({'text': text});
    if (likes != null) {
      result.addAll({'likes': likes});
    }
    result.addAll({'user': user});
    if (userPosted != null) {
      result.addAll({'userPosted': userPosted!.toMap()});
    }
    if (isPinned != null) {
      result.addAll({'isPinned': isPinned});
    }
    result.addAll({'postFor': postFor});
    if (isFriend != null) {
      result.addAll({'isFriend': isFriend});
    }
    if (isLiked != null) {
      result.addAll({'isLiked': isLiked});
    }
    result.addAll({'type': type});
    if (likesCount != null) {
      result.addAll({'likesCount': likesCount});
    }
    if (CommentsCount != null) {
      result.addAll({'CommentsCount': CommentsCount});
    }
    result.addAll({'fromWall': fromWall});

    return result;
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id']?.toInt(),
      postedBy: map['postedBy'] ?? '',
      dateTime: map['dateTime'] ?? '',
      description: map['description'] ?? '',
      text: map['text'] ?? '',
      likes: map['likes']?.toInt(),
      user: map['user'] ?? '',
      userPosted:
          map['user'] != null ? User.fromMap(jsonDecode(map['user'])) : null,
      isPinned: map['isPinned'],
      postFor: map['postFor'] ?? '',
      isFriend: map['isFriend'],
      isLiked: map['isLiked'],
      type: map['type'] ?? '',
      likesCount: map['likesCount']?.toInt(),
      CommentsCount: map['CommentsCount']?.toInt(),
      fromWall: map['fromWall'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Post.fromJson(String source) => Post.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Post(id: $id, postedBy: $postedBy, dateTime: $dateTime, description: $description, text: $text, likes: $likes, user: $user, userPosted: $userPosted, isPinned: $isPinned, postFor: $postFor, isFriend: $isFriend, isLiked: $isLiked, type: $type, likesCount: $likesCount, CommentsCount: $CommentsCount, fromWall: $fromWall)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Post &&
        other.id == id &&
        other.postedBy == postedBy &&
        other.dateTime == dateTime &&
        other.description == description &&
        other.text == text &&
        other.likes == likes &&
        other.user == user &&
        other.userPosted == userPosted &&
        other.isPinned == isPinned &&
        other.postFor == postFor &&
        other.isFriend == isFriend &&
        other.isLiked == isLiked &&
        other.type == type &&
        other.likesCount == likesCount &&
        other.CommentsCount == CommentsCount &&
        other.fromWall == fromWall;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        postedBy.hashCode ^
        dateTime.hashCode ^
        description.hashCode ^
        text.hashCode ^
        likes.hashCode ^
        user.hashCode ^
        userPosted.hashCode ^
        isPinned.hashCode ^
        postFor.hashCode ^
        isFriend.hashCode ^
        isLiked.hashCode ^
        type.hashCode ^
        likesCount.hashCode ^
        CommentsCount.hashCode ^
        fromWall.hashCode;
  }
}
