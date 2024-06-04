// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class VideoModel {
  final String videoTitle;
  final String videoUrl;
  final String videoThumbnail;
  final String description;
  final List likes;
  final int views;
  final String date;
  final String channelId;
  final String channelName;
  final String channelProfile;
  final List tags;
  String id;
  VideoModel({
    required this.videoTitle,
    required this.videoUrl,
    required this.videoThumbnail,
    required this.description,
    required this.likes,
    required this.views,
    required this.date,
    required this.channelId,
    required this.channelName,
    required this.channelProfile,
    required this.tags,
    this.id = '',
  });

  VideoModel copyWith({
    String? videoTitle,
    String? videoUrl,
    String? videoThumbnail,
    String? description,
    List? likes,
    int? views,
    String? date,
    String? channelId,
    String? channelName,
    String? channelProfile,
    List? tags,
    String? id,
  }) {
    return VideoModel(
      videoTitle: videoTitle ?? this.videoTitle,
      videoUrl: videoUrl ?? this.videoUrl,
      videoThumbnail: videoThumbnail ?? this.videoThumbnail,
      description: description ?? this.description,
      likes: likes ?? this.likes,
      views: views ?? this.views,
      date: date ?? this.date,
      channelId: channelId ?? this.channelId,
      channelName: channelName ?? this.channelName,
      channelProfile: channelProfile ?? this.channelProfile,
      tags: tags ?? this.tags,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'videoTitle': videoTitle,
      'videoUrl': videoUrl,
      'videoThumbnail': videoThumbnail,
      'description': description,
      'likes': likes,
      'views': views,
      'date': date,
      'channelId': channelId,
      'channelName': channelName,
      'channelProfile': channelProfile,
      'tags': tags,
      'id': id,
    };
  }

  factory VideoModel.fromMap(Map<String, dynamic> map) {
    return VideoModel(
      id: map['id'] as String,
      videoTitle: map['videoTitle'] as String,
      description: map['description'] as String,
      likes: map['likes'] as List,
      views: map['views'] as int,
      date: map['date'] as String,
      channelId: map['channelId'] as String,
      channelName: map['channelName'] as String,
      channelProfile: map['channelProfile'] as String,
      videoThumbnail: map['videoThumbnail'] as String,
      videoUrl: map['videoUrl'] as String,
      tags: map['tags'] as List,
    );
  }

  String toJson() => json.encode(toMap());

  factory VideoModel.fromJson(String source) =>
      VideoModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'VideoModel(videoTitle: $videoTitle, videoUrl: $videoUrl, videoThumbnail: $videoThumbnail, description: $description, likes: $likes, views: $views, date: $date, channelId: $channelId, channelName: $channelName, channelProfile: $channelProfile, tags: $tags, id: $id)';
  }

  @override
  bool operator ==(covariant VideoModel other) {
    if (identical(this, other)) return true;

    return other.videoTitle == videoTitle &&
        other.videoUrl == videoUrl &&
        other.videoThumbnail == videoThumbnail &&
        other.description == description &&
        listEquals(other.likes, likes) &&
        other.views == views &&
        other.date == date &&
        other.channelId == channelId &&
        other.channelName == channelName &&
        listEquals(other.tags, tags) &&
        other.id == id;
  }

  @override
  int get hashCode {
    return videoTitle.hashCode ^
        videoUrl.hashCode ^
        videoThumbnail.hashCode ^
        description.hashCode ^
        likes.hashCode ^
        views.hashCode ^
        date.hashCode ^
        channelId.hashCode ^
        channelName.hashCode ^
        tags.hashCode ^
        id.hashCode;
  }
}
