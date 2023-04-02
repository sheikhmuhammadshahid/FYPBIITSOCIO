import 'dart:convert';

class ChatModel {
  int id;
  String message;
  bool sender;
  String senderImage;
  String type;
  bool fromFile;
  String? url;
  String? date;
  String dateTime;
  ChatModel({
    required this.id,
    required this.message,
    required this.sender,
    required this.senderImage,
    required this.type,
    required this.fromFile,
    this.url,
    this.date,
    required this.dateTime,
  });

  ChatModel copyWith({
    int? id,
    String? message,
    bool? sender,
    String? senderImage,
    String? type,
    bool? fromFile,
    String? url,
    String? date,
    String? dateTime,
  }) {
    return ChatModel(
      id: id ?? this.id,
      message: message ?? this.message,
      sender: sender ?? this.sender,
      senderImage: senderImage ?? this.senderImage,
      type: type ?? this.type,
      fromFile: fromFile ?? this.fromFile,
      url: url ?? this.url,
      date: date ?? this.date,
      dateTime: dateTime ?? this.dateTime,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'message': message});
    result.addAll({'sender': sender});
    result.addAll({'senderImage': senderImage});
    result.addAll({'type': type});
    result.addAll({'fromFile': fromFile});
    if (url != null) {
      result.addAll({'url': url});
    }
    if (date != null) {
      result.addAll({'date': date});
    }
    result.addAll({'dateTime': dateTime});

    return result;
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      id: map['id']?.toInt() ?? 0,
      message: map['message'] ?? '',
      sender: map['sender'] ?? false,
      senderImage: map['senderImage'] ?? '',
      type: map['type'] ?? '',
      fromFile: map['fromFile'] ?? false,
      url: map['url'],
      date: map['date'],
      dateTime: map['dateTime'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatModel.fromJson(String source) =>
      ChatModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ChatModel(id: $id, message: $message, sender: $sender, senderImage: $senderImage, type: $type, fromFile: $fromFile, url: $url, date: $date, dateTime: $dateTime)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatModel &&
        other.id == id &&
        other.message == message &&
        other.sender == sender &&
        other.senderImage == senderImage &&
        other.type == type &&
        other.fromFile == fromFile &&
        other.url == url &&
        other.date == date &&
        other.dateTime == dateTime;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        message.hashCode ^
        sender.hashCode ^
        senderImage.hashCode ^
        type.hashCode ^
        fromFile.hashCode ^
        url.hashCode ^
        date.hashCode ^
        dateTime.hashCode;
  }
}
