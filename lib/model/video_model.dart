class VideoModel {
  final String videoTitle;
  final String videoUrl;
  final String videoThumbnail;
  final String description;
  final List likes;
  final int views;
  final String date;
  final String channelId;
  final List tags;
  String? id;

  VideoModel({
    required this.views,
    required this.videoTitle,
    required this.description,
    this.likes = const [],
    required this.date,
    required this.channelId,
    required this.videoThumbnail,
    required this.videoUrl,
    this.id,
    required this.tags,
  });

  VideoModel copyWith({
    String? videoTitle,
    String? description,
    List? likes,
    int? views,
    String? date,
    String? channelId,
    String? id,
    List? tags,
  }) {
    return VideoModel(
      videoTitle: videoTitle ?? this.videoTitle,
      tags: tags ?? this.tags,
      videoUrl: videoUrl,
      videoThumbnail: videoThumbnail,
      description: description ?? this.description,
      likes: likes ?? this.likes,
      views: views ?? this.views,
      date: date ?? this.date,
      channelId: channelId ?? this.channelId,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'videoTitle': videoTitle,
      'description': description,
      'likes': likes,
      'views': views,
      'date': date,
      'channelId': channelId,
      'videoThumbnail': videoThumbnail,
      'videoUrl': videoUrl,
      'id': id,
      'tags': tags,
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
      videoThumbnail: map['videoThumbnail'] as String,
      videoUrl: map['videoUrl'] as String,
      tags: map['tags'] as List,
    );
  }

  // factory VideoModel.fromJson(String source) =>
  //     VideoModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'VideoModel(videoTitle: $videoTitle, description: $description, likes: $likes, views: $views, date: $date, channelId: $channelId, $videoThumbnail, $videoUrl, $id, tags: $tags)';
  }
}
