// video_upload_provider.dart

import 'dart:developer';

import '';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tube_vibe/database/user_service.dart';
import 'package:tube_vibe/database/video_service.dart';
import 'package:tube_vibe/model/user_model.dart';
import 'package:tube_vibe/model/video_model.dart';
import 'package:tube_vibe/view/screens/video_screen/video_screen.dart';

class VideoUploadProvider with ChangeNotifier {
  // Variables
  final picker = ImagePicker();
  final videoService = VideoService();
  final userService = UserService();
  // Boolean Values
  bool _isUploading = false;
  bool _isLoading = false;
  bool _pickedThumbnail = false;
  bool _pickedVideo = false;
  // Videos Lists
  List<VideoModel> _videos = [];
  List<VideoModel> _channelVideos = [];
  List<VideoModel> _watchListVideos = [];
  List<VideoModel> _searchList = [];
  List<VideoModel> _subscribedVideos = [];
  List<VideoModel> _relatedVideos = [];
  // Users Lists
  List<UserModel> _userModels = [];
  List<UserModel> _subscribedUsers = [];
  // String Lists
  List<String> _watchlistIds = [];

  String? _error;
  File? _videoFile;
  File? _thumbnailFile;
  VideoModel _video = VideoModel(
    views: 0,
    videoTitle: '',
    description: '',
    likes: [],
    date: '',
    channelId: '',
    videoThumbnail: '',
    videoUrl: '',
    tags: [],
  );
  // Getter
  // Boolean Values
  bool get isUploading => _isUploading;
  bool get isLoading => _isLoading;
  bool get pickedVideo => _pickedVideo;
  bool get pickedThumbnail => _pickedThumbnail;
  String? get error => _error;
  // Video Lists
  List<VideoModel> get videos => _videos;
  List<VideoModel> get channelVideos => _channelVideos;
  List<VideoModel> get searchList => _searchList;
  List<VideoModel> get subscribedVideos => _subscribedVideos;
  List<VideoModel> get relatedVideos => _relatedVideos;
  List<VideoModel> get watchListVideos => _watchListVideos;
  List<String> get watchlistIds => _watchlistIds;
  VideoModel get video => _video;
  // Files
  File? get videoFile => _videoFile;
  File? get thumbnailFile => _thumbnailFile;
  // Users Lists
  List<UserModel> get userModels => _userModels;
  List<UserModel> get subscribedUsers => _subscribedUsers;

  // Pick Video
  Future<void> pickVideo() async {
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      File videoFile = File(pickedFile.path);

      _videoFile = videoFile;
      _pickedVideo = true;
      notifyListeners();
    }
  }

  Future<void> pickThumbnail() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);

      _thumbnailFile = imageFile;
      _pickedThumbnail = true;
      notifyListeners();
    }
  }

  Future<void> uploadVideo(
      String videoTitle, String videoDesc, List<String> tags, context) async {
    _isUploading = true;
    notifyListeners();

    String videoFileName =
        'videos/${DateTime.now().millisecondsSinceEpoch}.mp4';
    String thumbnailFileName =
        'thumbnails/${DateTime.now().millisecondsSinceEpoch}.jpg';

    try {
      // Upload video
      File? compressedVideoFile = await videoService.compressVideo(videoFile!);

      String videoUrl =
          await videoService.uploadFile(compressedVideoFile!, videoFileName);

      // Compress and upload thumbnail
      File compressedThumbnail =
          await videoService.compressImage(thumbnailFile!);

      String thumbnailUrl =
          await videoService.uploadFile(compressedThumbnail, thumbnailFileName);

      final titleArray = videoTitle.split(' ');
      final tagsAndTitle = tags + titleArray;

      // Save metadata to Firestore
      VideoModel videoModel = VideoModel(
        videoTitle: videoTitle,
        description: videoDesc,
        likes: [],
        views: 0,
        videoThumbnail: thumbnailUrl,
        videoUrl: videoUrl,
        date: DateTime.now().toIso8601String(),
        channelId: "${FirebaseAuth.instance.currentUser?.uid}",
        tags: tagsAndTitle,
      );
      _pickedThumbnail = false;
      _pickedVideo = false;
      notifyListeners();
      final uploadedVideo = await videoService.saveVideoMetadata(videoModel);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => VideoScreen(
            videoUrl: uploadedVideo.data()?['videoUrl'],
            videoId: uploadedVideo.id,
          ),
        ),
      );
      _isUploading = false;
      notifyListeners();
    } catch (e) {
      _error = "Something wen wrong...";
      notifyListeners();
    } finally {
      _isUploading = false;
      notifyListeners();
    }
  }

  Future<void> fetchVideos() async {
    _isLoading = true;

    _videos = await videoService.fetchVideos();

    _userModels = await userService.getUsersName(_videos);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchMyVideos(String userId) async {
    _channelVideos = await videoService.fetchMyVideos(userId);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchVideoById(String docId) async {
    _isLoading = true;
    _video = await videoService.fetchVideoById(docId);
    _relatedVideos = await videoService.getRelatedVideos(_video.tags);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> likeVideo(String videoId, String userId) async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('videos')
          .doc(videoId)
          .get();
      final db = FirebaseFirestore.instance;

      if (docSnapshot.exists) {
        // Check if user already liked the video
        final likedByUser =
            docSnapshot.data()!['likes']?.contains(userId) ?? false;

        if (!likedByUser) {
          // Add user to likes array
          db.collection('videos').doc(videoId).update({
            'likes': FieldValue.arrayUnion([userId]),
          });
          // fetchVideoById(videoId);
          _video.likes.add(userId);
          notifyListeners();
        } else {
          // Remove user from likes array (unlike)
          db.collection('videos').doc(videoId).update({
            'likes': FieldValue.arrayRemove([userId]),
          });
          // fetchVideoById(videoId);
          _video.likes.remove(userId);
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> searchVideos(String query) async {
    _searchList = await videoService.searchVideos(query);
    _userModels = await userService.getUsersName(_searchList);
    notifyListeners();
  }

  Future<void> getSubscribedVideos(String userId) async {
    _isLoading = true;
    final videos = await videoService.getSubscribedVideos(userId);
    _subscribedVideos = videos[0];
    _subscribedUsers = videos[1];
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchWatchListVideos(String userId) async {
    _isLoading = true;
    _watchListVideos = await videoService.fetchWatchlistVideos(userId);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addToWatchlist(String userId, String videoId) async {
    _watchlistIds.add(videoId);
    await videoService.addToWatchlist(userId, videoId);
    await fetchWatchlistIds(userId);
    notifyListeners();
  }

  Future<void> fetchWatchlistIds(String userId) async {
    _watchlistIds = await videoService.fetchWatchlistIds(userId);
    notifyListeners();
  }

  Future<void> deleteVideo(String docId, String userId, context) async {
    await videoService.deleteVideo(docId, userId, context);
    notifyListeners();
  }

  Future<void> clearSearchList() async {
    _searchList = [];
  }
}
