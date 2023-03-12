import 'dart:convert';

class FriendRequest {
  String RequestedBy;
  String RequestedTo;
  int? id;
  String status;
  FriendRequest({
    required this.RequestedBy,
    required this.RequestedTo,
    this.id,
    required this.status,
  });

  FriendRequest copyWith({
    String? RequestedBy,
    String? RequestedTo,
    int? id,
    String? status,
  }) {
    return FriendRequest(
      RequestedBy: RequestedBy ?? this.RequestedBy,
      RequestedTo: RequestedTo ?? this.RequestedTo,
      id: id ?? this.id,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'RequestedBy': RequestedBy});
    result.addAll({'RequestedTo': RequestedTo});
    if (id != null) {
      result.addAll({'id': id});
    }
    result.addAll({'status': status});

    return result;
  }

  factory FriendRequest.fromMap(Map<String, dynamic> map) {
    return FriendRequest(
      RequestedBy: map['RequestedBy'] ?? '',
      RequestedTo: map['RequestedTo'] ?? '',
      id: map['id']?.toInt(),
      status: map['status'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory FriendRequest.fromJson(String source) =>
      FriendRequest.fromMap(json.decode(source));

  @override
  String toString() {
    return 'FriendRequest(RequestedBy: $RequestedBy, RequestedTo: $RequestedTo, id: $id, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FriendRequest &&
        other.RequestedBy == RequestedBy &&
        other.RequestedTo == RequestedTo &&
        other.id == id &&
        other.status == status;
  }

  @override
  int get hashCode {
    return RequestedBy.hashCode ^
        RequestedTo.hashCode ^
        id.hashCode ^
        status.hashCode;
  }
}
