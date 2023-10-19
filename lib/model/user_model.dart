// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

class UserModel {
  String uid;
  String name;
  String email;
  String referralCode;
  int point;
  int diamonds;
  String? userImage;
  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.referralCode,
    required this.point,
    required this.diamonds,
    required this.userImage,
  });

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? referralCode,
    int? point,
    int? diamonds,
    String? userImage,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      referralCode: referralCode ?? this.referralCode,
      point: point ?? this.point,
      diamonds: diamonds ?? this.diamonds,
      userImage: userImage ?? this.userImage,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'email': email,
      'referralCode': referralCode,
      'point': point,
      'diamonds': diamonds,
      'userImage': userImage,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      referralCode: map['referralCode'] as String,
      point: map['point'] as int,
      diamonds: map['diamonds'] as int,
      userImage: map['userImage'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(uid: $uid, name: $name, email: $email, referralCode: $referralCode, point: $point, diamonds: $diamonds, userImage: $userImage)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.name == name &&
        other.email == email &&
        other.referralCode == referralCode &&
        other.point == point &&
        other.diamonds == diamonds &&
        other.userImage == userImage;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        name.hashCode ^
        email.hashCode ^
        referralCode.hashCode ^
        point.hashCode ^
        diamonds.hashCode ^
        userImage.hashCode;
  }
}
