import 'dart:convert';

class SVNotificationModel {
  int? id;
  String? name;
  String? secondName;
  String? profileImage;
  String? dateTime;
  String? notificationType;
  String? postImage;
  bool? ifOfficial;
  String? birthDate;
  String? body;
  String? day;
  int? status;

  SVNotificationModel({
    this.id,
    this.name,
    this.secondName,
    this.profileImage,
    this.dateTime,
    this.notificationType,
    this.postImage,
    this.ifOfficial,
    this.birthDate,
    this.body,
    this.day,
    this.status,
  });

  SVNotificationModel copyWith({
    int? id,
    String? name,
    String? secondName,
    String? profileImage,
    String? dateTime,
    String? notificationType,
    String? postImage,
    bool? ifOfficial,
    String? birthDate,
    String? body,
    String? day,
    int? status,
  }) {
    return SVNotificationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      secondName: secondName ?? this.secondName,
      profileImage: profileImage ?? this.profileImage,
      dateTime: dateTime ?? this.dateTime,
      notificationType: notificationType ?? this.notificationType,
      postImage: postImage ?? this.postImage,
      ifOfficial: ifOfficial ?? this.ifOfficial,
      birthDate: birthDate ?? this.birthDate,
      body: body ?? this.body,
      day: day ?? this.day,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (id != null) {
      result.addAll({'id': id});
    }
    if (name != null) {
      result.addAll({'name': name});
    }
    if (secondName != null) {
      result.addAll({'secondName': secondName});
    }
    if (profileImage != null) {
      result.addAll({'profileImage': profileImage});
    }
    if (dateTime != null) {
      result.addAll({'dateTime': dateTime});
    }
    if (notificationType != null) {
      result.addAll({'notificationType': notificationType});
    }
    if (postImage != null) {
      result.addAll({'postImage': postImage});
    }
    if (ifOfficial != null) {
      result.addAll({'ifOfficial': ifOfficial});
    }
    if (birthDate != null) {
      result.addAll({'birthDate': birthDate});
    }
    if (body != null) {
      result.addAll({'body': body});
    }
    if (day != null) {
      result.addAll({'day': day});
    }
    if (status != null) {
      result.addAll({'status': status});
    }

    return result;
  }

  factory SVNotificationModel.fromMap(Map<String, dynamic> map) {
    return SVNotificationModel(
      id: map['id']?.toInt(),
      name: map['name'],
      secondName: map['secondName'],
      profileImage: map['profileImage'],
      dateTime: map['dateTime'],
      notificationType: map['type'],
      postImage: map['postImage'],
      ifOfficial: map['ifOfficial'],
      birthDate: map['birthDate'],
      body: map['body'],
      day: map['day'],
      status: map['status']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory SVNotificationModel.fromJson(String source) =>
      SVNotificationModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SVNotificationModel(id: $id, name: $name, secondName: $secondName, profileImage: $profileImage, dateTime: $dateTime, notificationType: $notificationType, postImage: $postImage, ifOfficial: $ifOfficial, birthDate: $birthDate, body: $body, day: $day, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SVNotificationModel &&
        other.id == id &&
        other.name == name &&
        other.secondName == secondName &&
        other.profileImage == profileImage &&
        other.dateTime == dateTime &&
        other.notificationType == notificationType &&
        other.postImage == postImage &&
        other.ifOfficial == ifOfficial &&
        other.birthDate == birthDate &&
        other.body == body &&
        other.day == day &&
        other.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        secondName.hashCode ^
        profileImage.hashCode ^
        dateTime.hashCode ^
        notificationType.hashCode ^
        postImage.hashCode ^
        ifOfficial.hashCode ^
        birthDate.hashCode ^
        body.hashCode ^
        day.hashCode ^
        status.hashCode;
  }
}
