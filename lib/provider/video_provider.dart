// video_upload_provider.dart

import 'dart:developer';
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
  bool _isUploading = true;
  bool _isLoading = true;
  bool _pickedThumbnail = false;
  bool _pickedVideo = false;
  List<VideoModel> _videos = [];
  List<UserModel> _userModels = [];

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
  bool get isUploading => _isUploading;
  bool get isLoading => _isLoading;
  bool get pickedVideo => _pickedVideo;
  bool get pickedThumbnail => _pickedThumbnail;
  String? get error => _error;
  List<VideoModel> get videos => _videos;
  VideoModel get video => _video;
  File? get videoFile => _videoFile;
  File? get thumbnailFile => _thumbnailFile;
  List<UserModel> get userModels => _userModels;
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
        tags: tags,
      );

      final uploadedVideo = await videoService.saveVideoMetadata(videoModel);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => VideoScreen(
            videoUrl: uploadedVideo.data()?['videoUrl'],
            videoId: uploadedVideo.id,
          ),
        ),
      );
    } catch (e) {
      _error = "Something wen wrong...";
      notifyListeners();
    } finally {
      _isUploading = false;
      notifyListeners();
    }
  }

  Future<void> fetchVideos() async {
    _videos = await videoService.fetchVideos();
    _userModels = await userService.getUsersName(_videos);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchVideoById(String docId) async {
    _video = await videoService.fetchVideoById(docId);
    notifyListeners();
  }

  Future<void> likeVideo(String videoId, String userId) async {
    log("$videoId $userId");

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
          fetchVideoById(videoId);
        } else {
          // Remove user from likes array (unlike)
          db.collection('videos').doc(videoId).update({
            'likes': FieldValue.arrayRemove([userId]),
          });
          fetchVideoById(videoId);
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
