import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tube_vibe/model/user_model.dart';
import 'package:tube_vibe/view/screens/main_screen.dart';

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:video_compress/video_compress.dart';
import 'package:tube_vibe/model/video_model.dart';

class VideoService {
  final db = FirebaseFirestore.instance;
  // File uploading
  Future<String> uploadFile(
      File file, String path, Function(double) onProgress) async {
    try {
      // Create a reference to the Firebase Storage location
      Reference storageReference = FirebaseStorage.instance.ref().child(path);

      // Create an upload task
      UploadTask uploadTask = storageReference.putFile(file);

      // Track the progress
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        // Calculate the progress percentage
        double progress =
            (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
        onProgress(progress);
      });

      // Wait until the upload completes
      await uploadTask.whenComplete(() => null);

      // Get the download URL
      String downloadUrl = await storageReference.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception('Upload failed: $e');
    }
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
      final videos = VideoModel.fromMap(videoData);
      videosList.add(videos);
    }
    return videosList;
  }

  Future<List<VideoModel>> fetchMyVideos(String userId) async {
    // Empty VideoModel list
    final List<VideoModel> videosList = [];
    // Fetch video from db
    final querySnapshot = await db
        .collection('videos')
        .where("channelId", isEqualTo: userId)
        .get();

    for (var docSnapshot in querySnapshot.docs) {
      final videoData = docSnapshot.data();
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
        channelName: '',
        videoThumbnail: '',
        channelProfile: '',
        videoUrl: '',
        tags: [],
      );
    }
  }

  // Search Videos
  Future<List<VideoModel>> searchVideos(String query) async {
    // Empty VideoModel list
    final List<VideoModel> videosList = [];
    log("vid serv log: $query");

    // Fetch video from db
    final results = await FirebaseFirestore.instance.collection('videos').get();

    final querySnapshot = results.docs
        .where((doc) {
          return (doc.data()['tags'].toString().toLowerCase())
              .contains(query.toLowerCase());
        })
        .map((doc) => doc.data())
        .toList();
    for (var docSnapshot in querySnapshot) {
      final videos = VideoModel.fromMap(docSnapshot);
      videosList.add(videos);
    }
    return videosList;
  }

  // Fetch Related Videos
  Future<List<VideoModel>> getRelatedVideos(List queries) async {
    // Empty VideoModel list
    final List<VideoModel> videosList = [];
    // Fetch video from db
    final results = await FirebaseFirestore.instance.collection('videos').get();
    final querySnapshot = results.docs
        .where((doc) {
          final tags = (doc.data()['tags'] as List<dynamic>)
              .map((tag) => tag.toString().toLowerCase())
              .toList();
          for (String query in queries) {
            if (tags.any((tag) => tag.contains(query.toLowerCase()))) {
              return true;
            }
          }
          return false;
        })
        .map((doc) => doc.data())
        .toList();
    for (var docSnapshot in querySnapshot) {
      final videos = VideoModel.fromMap(docSnapshot);
      videosList.add(videos);
    }
    return videosList;
  }

  Future<List> getSubscribedVideos(String userId) async {
    // Empty VideoModel list
    final List<VideoModel> videosList = [];
    final List<String> usersIdLists = [];
    final List<UserModel> usersLists = [];

    //Fetch users
    final querySnapshot = await db
        .collection('users')
        .where("subscribers", arrayContains: userId)
        .get();

    for (var docSnapshot in querySnapshot.docs) {
      final userData = docSnapshot.data();

      final users = UserModel.fromMap(userData);
      usersLists.add(users);
      usersIdLists.add(users.id!);
    }

    for (var index in usersIdLists) {
      // Fetch video from db
      final querySnapshotVideos = await db
          .collection('videos')
          .where("channelId", isEqualTo: index)
          .get();

      for (var docSnapshot in querySnapshotVideos.docs) {
        final videoData = docSnapshot.data();
        final videos = VideoModel.fromMap(videoData);
        videosList.add(videos);
      }
    }
    return [videosList, usersLists];
  }

  Future<void> addToWatchlist(String userId, String videoId) async {
    final DocumentReference docRef =
        FirebaseFirestore.instance.collection('watchlists').doc(userId);

    try {
      DocumentSnapshot docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        // If the document exists, update it
        List<dynamic> existingVideoIds = docSnapshot.get('videoIds');

        if (existingVideoIds.contains(videoId)) {
          // If videoId exists, remove it
          existingVideoIds.remove(videoId);
        } else {
          // If videoId does not exist, add it
          existingVideoIds.add(videoId);
        }

        await docRef.update({'videoIds': existingVideoIds});
      } else {
        // If the document does not exist, create it with the videoId
        await docRef.set({
          'videoIds': [videoId]
        });
      }
    } catch (e) {
      debugPrint("Error updating watchlist: $e");
    }
  }

  Future<List<String>> fetchWatchlistIds(String userId) async {
    final DocumentReference watchlistRef =
        FirebaseFirestore.instance.collection('watchlists').doc(userId);
    List<String> videoIds = [];

    try {
      DocumentSnapshot watchlistSnapshot = await watchlistRef.get();

      if (watchlistSnapshot.exists) {
        videoIds = List<String>.from(watchlistSnapshot.get('videoIds'));
      }
    } catch (e) {
      debugPrint("Error fetching watchlist: $e");
    }

    return videoIds;
  }

  Future<List<VideoModel>> fetchWatchlistVideos(String userId) async {
    final DocumentReference watchlistRef =
        FirebaseFirestore.instance.collection('watchlists').doc(userId);
    List<VideoModel> videos = [];

    try {
      DocumentSnapshot watchlistSnapshot = await watchlistRef.get();

      if (watchlistSnapshot.exists) {
        List<dynamic> videoIds = watchlistSnapshot.get('videoIds');

        if (videoIds.isNotEmpty) {
          QuerySnapshot videoSnapshots = await FirebaseFirestore.instance
              .collection('videos')
              .where(FieldPath.documentId, whereIn: videoIds)
              .get();

          for (var video in videoSnapshots.docs) {
            final videoData = video.data();
            final videoModel =
                VideoModel.fromMap(videoData as Map<String, dynamic>);
            videos.add(videoModel);
            debugPrint(videos.toString());
          }
        }
      }
    } catch (e) {
      debugPrint("Error fetching watchlist videos: $e");
    }
    return videos;
  }

  Future<void> deleteVideo(String docId, String userId, context) async {
    try {
      await db.collection('videos').doc(docId).delete();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const MainScreen(),
        ),
        (route) => false,
      );
    } catch (e) {
      debugPrint("Error fetching watchlist videos: $e");
    }
  }

  Future<void> addViews(String videoId) async {
    try {
      final docRef = db.collection('videos').doc(videoId);
      final docSnap = await docRef.get();
      final video = VideoModel.fromMap(docSnap.data()!);

      await docRef.update({
        'views': video.views + 1,
      });
    } catch (e) {
      debugPrint("Error fetching watchlist videos: $e");
    }
  }
}
