// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class CommentModel {
  final String name;
  final String profile;
  final String? id;
  final String date;
  final String userId;
  final String videoId;
  final String comment;
  final List likes;

  CommentModel({
    required this.name,
    required this.profile,
    this.id,
    required this.date,
    required this.userId,
    required this.videoId,
    required this.comment,
    required this.likes,
  });

  CommentModel copyWith({
    String? name,
    String? profile,
    String? id,
    String? date,
    String? userId,
    String? videoId,
    String? comment,
    List? likes,
  }) {
    return CommentModel(
      name: name ?? this.name,
      profile: profile ?? this.profile,
      id: id ?? this.id,
      date: date ?? this.date,
      userId: userId ?? this.userId,
      videoId: videoId ?? this.videoId,
      comment: comment ?? this.comment,
      likes: likes ?? this.likes,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'profile': profile,
      'id': id,
      'date': date,
      'userId': userId,
      'videoId': videoId,
      'comment': comment,
      'likes': likes,
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      name: map['name'] as String,
      profile: map['profile'] as String,
      id: map['id'] != null ? map['id'] as String : null,
      date: map['date'] as String,
      userId: map['userId'] as String,
      videoId: map['videoId'] as String,
      comment: map['comment'] as String,
      likes: List.from(
        (map['likes'] as List),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory CommentModel.fromJson(String source) =>
      CommentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CommentModel(name: $name, profile: $profile, id: $id, date: $date, userId: $userId, videoId: $videoId, comment: $comment, likes: $likes)';
  }

  @override
  bool operator ==(covariant CommentModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.profile == profile &&
        other.id == id &&
        other.date == date &&
        other.userId == userId &&
        other.videoId == videoId &&
        other.comment == comment &&
        listEquals(other.likes, likes);
  }

  @override
  int get hashCode {
    return name.hashCode ^
        profile.hashCode ^
        id.hashCode ^
        date.hashCode ^
        userId.hashCode ^
        videoId.hashCode ^
        comment.hashCode ^
        likes.hashCode;
  }
}
