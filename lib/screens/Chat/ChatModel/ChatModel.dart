import 'dart:convert';

class ChatModel {
  int id;
  String message;
  bool sender;
  String senderImage;
  String type;
  ChatModel({
    required this.id,
    required this.message,
    required this.sender,
    required this.senderImage,
    required this.type,
  });

  ChatModel copyWith({
    int? id,
    String? message,
    bool? sender,
    String? senderImage,
    String? type,
  }) {
    return ChatModel(
      id: id ?? this.id,
      message: message ?? this.message,
      sender: sender ?? this.sender,
      senderImage: senderImage ?? this.senderImage,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'message': message});
    result.addAll({'sender': sender});
    result.addAll({'senderImage': senderImage});
    result.addAll({'type': type});

    return result;
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      id: map['id']?.toInt() ?? 0,
      message: map['message'] ?? '',
      sender: map['sender'] ?? false,
      senderImage: map['senderImage'] ?? '',
      type: map['type'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatModel.fromJson(String source) =>
      ChatModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ChatModel(id: $id, message: $message, sender: $sender, senderImage: $senderImage, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatModel &&
        other.id == id &&
        other.message == message &&
        other.sender == sender &&
        other.senderImage == senderImage &&
        other.type == type;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        message.hashCode ^
        sender.hashCode ^
        senderImage.hashCode ^
        type.hashCode;
  }
}
