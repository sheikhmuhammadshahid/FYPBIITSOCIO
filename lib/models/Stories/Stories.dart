import 'dart:convert';

class Stories {
  int id;
  String type;
  int? societyId;
  String url;
  String text;
  int? color;
  String? time;
  Stories({
    required this.id,
    required this.type,
    this.societyId,
    required this.url,
    required this.text,
    this.color,
    this.time,
  });

  Stories copyWith({
    int? id,
    String? type,
    int? societyId,
    String? url,
    String? text,
    int? color,
    String? time,
  }) {
    return Stories(
      id: id ?? this.id,
      type: type ?? this.type,
      societyId: societyId ?? this.societyId,
      url: url ?? this.url,
      text: text ?? this.text,
      color: color ?? this.color,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'type': type});
    if (societyId != null) {
      result.addAll({'societyId': societyId});
    }
    result.addAll({'url': url});
    result.addAll({'text': text});
    if (color != null) {
      result.addAll({'color': color});
    }
    if (time != null) {
      result.addAll({'time': time});
    }

    return result;
  }

  factory Stories.fromMap(Map<String, dynamic> map) {
    return Stories(
      id: map['id']?.toInt() ?? 0,
      type: map['type'] ?? '',
      societyId: map['societyId']?.toInt(),
      url: map['url'] ?? '',
      text: map['text'] ?? '',
      color: map['color']?.toInt(),
      time: map['time'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Stories.fromJson(String source) =>
      Stories.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Stories(id: $id, type: $type, societyId: $societyId, url: $url, text: $text, color: $color, time: $time)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Stories &&
        other.id == id &&
        other.type == type &&
        other.societyId == societyId &&
        other.url == url &&
        other.text == text &&
        other.color == color &&
        other.time == time;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        type.hashCode ^
        societyId.hashCode ^
        url.hashCode ^
        text.hashCode ^
        color.hashCode ^
        time.hashCode;
  }
}
