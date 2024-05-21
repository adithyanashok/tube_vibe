// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  final String name;
  final String email;
  final String? id;
  final String profileImg;
  final List subscribers;

  UserModel({
    required this.name,
    required this.email,
    this.id,
    this.profileImg =
        'https://i.pinimg.com/736x/04/49/60/044960ceb389aa1c32ca024ee774e12a.jpg',
    this.subscribers = const [],
  });

  UserModel copyWith({
    String? name,
    String? email,
    String? id,
    String? profileImg,
    List? subscribers,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      id: id ?? this.id,
      profileImg: profileImg ?? this.profileImg,
      subscribers: subscribers ?? this.subscribers,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'id': id,
      'profileImg': profileImg,
      'subscribers': subscribers,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String,
      email: map['email'] as String,
      id: map['id'] != null ? map['id'] as String : null,
      profileImg: map['profileImg'] as String,
      subscribers: map['subscribers'] as List,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(name: $name, email: $email, id: $id, profileImg: $profileImg, subscribers: $subscribers)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.email == email &&
        other.id == id &&
        other.profileImg == profileImg &&
        other.subscribers == subscribers;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        email.hashCode ^
        id.hashCode ^
        profileImg.hashCode ^
        subscribers.hashCode;
  }
}
