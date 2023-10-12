
import 'dart:convert';

class UserModel {
  String name;
  double point;
  double diamonds;
  String userImage;
  UserModel({
    required this.name,
    required this.point,
    required this.diamonds,
    required this.userImage,
  });

  UserModel copyWith({
    String? name,
    double? point,
    double? diamonds,
    String? userImage,
  }) {
    return UserModel(
      name: name ?? this.name,
      point: point ?? this.point,
      diamonds: diamonds ?? this.diamonds,
      userImage: userImage ?? this.userImage,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'point': point,
      'diamonds': diamonds,
      'userImage': userImage,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String,
      point: map['point'] as double,
      diamonds: map['diamonds'] as double,
      userImage: map['userImage'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(name: $name, point: $point, diamonds: $diamonds, userImage: $userImage)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.name == name &&
      other.point == point &&
      other.diamonds == diamonds &&
      other.userImage == userImage;
  }

  @override
  int get hashCode {
    return name.hashCode ^
      point.hashCode ^
      diamonds.hashCode ^
      userImage.hashCode;
  }
}
