import 'dart:convert';

class User {
  String aridNo;
  String? name;
  String profileImage;
  String password;
  String? email;
  String? phone;
  String? token;
  bool? isFriend;
  String CNIC;
  String? sonOf;
  int? postsCount;
  int? countFriends;
  String? section;
  String? isTeachingTo;
  String? userType;
  User({
    required this.aridNo,
    this.name,
    required this.profileImage,
    required this.password,
    this.email,
    this.phone,
    this.token,
    this.isFriend = false,
    required this.CNIC,
    this.sonOf,
    this.postsCount = 0,
    this.countFriends = 0,
    this.section = "",
    this.isTeachingTo,
    this.userType,
  });

  User copyWith({
    String? aridNo,
    String? name,
    String? profileImage,
    String? password,
    String? email,
    String? phone,
    String? token,
    bool? isFriend,
    String? CNIC,
    String? sonOf,
    int? postsCount,
    int? countFriends,
    String? section,
    String? isTeachingTo,
    String? userType,
  }) {
    return User(
      aridNo: aridNo ?? this.aridNo,
      name: name ?? this.name,
      profileImage: profileImage ?? this.profileImage,
      password: password ?? this.password,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      token: token ?? this.token,
      isFriend: isFriend ?? this.isFriend,
      CNIC: CNIC ?? this.CNIC,
      sonOf: sonOf ?? this.sonOf,
      postsCount: postsCount ?? this.postsCount,
      countFriends: countFriends ?? this.countFriends,
      section: section ?? this.section,
      isTeachingTo: isTeachingTo ?? this.isTeachingTo,
      userType: userType ?? this.userType,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'aridNo': aridNo});
    if (name != null) {
      result.addAll({'name': name});
    }
    result.addAll({'profileImage': profileImage});
    result.addAll({'password': password});
    if (email != null) {
      result.addAll({'email': email});
    }
    if (phone != null) {
      result.addAll({'phone': phone});
    }
    if (token != null) {
      result.addAll({'token': token});
    }
    if (isFriend != null) {
      result.addAll({'isFriend': isFriend});
    }
    result.addAll({'CNIC': CNIC});
    if (sonOf != null) {
      result.addAll({'sonOf': sonOf});
    }
    if (postsCount != null) {
      result.addAll({'postsCount': postsCount});
    }
    if (countFriends != null) {
      result.addAll({'countFriends': countFriends});
    }
    if (section != null) {
      result.addAll({'section': section});
    }
    if (isTeachingTo != null) {
      result.addAll({'isTeachingTo': isTeachingTo});
    }
    if (userType != null) {
      result.addAll({'userType': userType});
    }

    return result;
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      aridNo: map['aridNo'] ?? '',
      name: map['name'],
      profileImage: map['profileImage'] ?? '',
      password: map['password'] ?? '',
      email: map['email'],
      phone: map['phone'],
      //  token: map['token'],
      isFriend: map['isFriend'],
      CNIC: map['CNIC'] ?? '',
      sonOf: map['sonOf'],
      postsCount: map['postsCount']?.toInt(),
      countFriends: map['countFriends']?.toInt(),
      section: map['section'],
      isTeachingTo: map['isTeachingTo'],
      userType: map['userType'],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(aridNo: $aridNo, name: $name, profileImage: $profileImage, password: $password, email: $email, phone: $phone, token: $token, isFriend: $isFriend, CNIC: $CNIC, sonOf: $sonOf, postsCount: $postsCount, countFriends: $countFriends, section: $section, isTeachingTo: $isTeachingTo, userType: $userType)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.aridNo == aridNo &&
        other.name == name &&
        other.profileImage == profileImage &&
        other.password == password &&
        other.email == email &&
        other.phone == phone &&
        other.token == token &&
        other.isFriend == isFriend &&
        other.CNIC == CNIC &&
        other.sonOf == sonOf &&
        other.postsCount == postsCount &&
        other.countFriends == countFriends &&
        other.section == section &&
        other.isTeachingTo == isTeachingTo &&
        other.userType == userType;
  }

  @override
  int get hashCode {
    return aridNo.hashCode ^
        name.hashCode ^
        profileImage.hashCode ^
        password.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        token.hashCode ^
        isFriend.hashCode ^
        CNIC.hashCode ^
        sonOf.hashCode ^
        postsCount.hashCode ^
        countFriends.hashCode ^
        section.hashCode ^
        isTeachingTo.hashCode ^
        userType.hashCode;
  }
}
