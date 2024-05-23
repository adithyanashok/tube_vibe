import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:video_compress/video_compress.dart';
import 'package:tube_vibe/model/video_model.dart';

class VideoService {
  final db = FirebaseFirestore.instance;
  // File uploading
  Future<String> uploadFile(File file, String path) async {
    // upload file
    TaskSnapshot snapshot =
        await FirebaseStorage.instance.ref(path).putFile(file);
    // Returning the url
    return await snapshot.ref.getDownloadURL();
  }

  Future<File?> compressVideo(File file) async {
    // Compress video and return
    final info = await VideoCompress.compressVideo(
      file.path,
      quality: VideoQuality.MediumQuality,
      deleteOrigin: false,
    );
    return info?.file;
  }

  Future<File?> generateThumbnail(File videoFile) async {
    final thumbnailPath = await VideoCompress.getFileThumbnail(
      videoFile.path,
      quality: 50,
    );
    return File(thumbnailPath.path);
  }

  Future<File> compressImage(File file) async {
    final compressedImage = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      '${file.absolute.path}_compressed.jpg',
      quality: 50,
    );
    return File(compressedImage!.path);
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> saveVideoMetadata(
      VideoModel videoModel) async {
    // Saving to firestore
    final docRef = await db.collection('videos').add(videoModel.toMap());
    // Extracting response
    final data = await docRef.get();
    // Updating id
    await db.collection('videos').doc(data.id).update({
      "id": data.id,
    });
    return data;
  }

  Future<List<VideoModel>> fetchVideos() async {
    // Empty VideoModel list
    final List<VideoModel> videosList = [];
    // Fetch video from db
    final querySnapshot = await db.collection('videos').get();

    for (var docSnapshot in querySnapshot.docs) {
      final videoData = docSnapshot.data();
      log(videoData.toString());
      final videos = VideoModel.fromMap(videoData);
      videosList.add(videos);
    }
    return videosList;
  }

  Future<List<VideoModel>> fetchMyVideos(String userId) async {
    print(userId);
    // Empty VideoModel list
    final List<VideoModel> videosList = [];
    // Fetch video from db
    final querySnapshot = await db
        .collection('videos')
        .where("channelId", isEqualTo: userId)
        .get();

    for (var docSnapshot in querySnapshot.docs) {
      final videoData = docSnapshot.data();
      log(videoData.toString());
      final videos = VideoModel.fromMap(videoData);
      videosList.add(videos);
    }
    return videosList;
  }

  Future<VideoModel> fetchVideoById(String docId) async {
    final docSnapshot = await db.collection('videos').doc(docId).get();
    if (docSnapshot.exists) {
      return VideoModel.fromMap(docSnapshot.data()!);
    } else {
      return VideoModel(
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
    }
  }

  Future<void> likeVideo(String videoId, String userId) async {
    final docRef = FirebaseFirestore.instance.collection('videos').doc(videoId);
    final transaction =
        await FirebaseFirestore.instance.runTransaction((transaction) async {
      final docSnapshot = await transaction.get(docRef);

      if (docSnapshot.exists) {
        // Check if user already liked the video
        final likedByUser =
            docSnapshot.data()!['likes']?.contains(userId) ?? false;

        if (!likedByUser) {
          // Add user to likes array
          transaction.update(docRef, {
            'likes': FieldValue.arrayUnion([userId]),
          });
        } else {
          // Remove user from likes array (unlike)
          transaction.update(docRef, {
            'likes': FieldValue.arrayRemove([userId]),
          });
        }
      }
    });
  }
}
