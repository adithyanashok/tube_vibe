import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tube_vibe/model/user_model.dart';

class UserService {
  final db = FirebaseFirestore.instance;
  Future<UserModel> getUser(String userId) async {
    try {
      final docSnap = await db.collection('users').doc(userId).get();

      final userData = docSnap.data();
      if (userData != null) {
        final user = UserModel.fromMap(userData);
        return user;
      } else {
        return UserModel(name: "", email: '');
      }
    } catch (e) {
      debugPrint(e.toString());
      return UserModel(name: "", email: '');
    }
  }

  Future<List<UserModel>> searchUsers(String query) async {
    // Empty VideoModel list
    final List<UserModel> usersList = [];

    // Fetch video from db
    final results = await FirebaseFirestore.instance.collection('users').get();

    final querySnapshot = results.docs
        .where((doc) {
          return (doc.data()['name'].toString().toLowerCase())
              .contains(query.toLowerCase());
        })
        .map((doc) => doc.data())
        .toList();
    for (var docSnapshot in querySnapshot) {
      final users = UserModel.fromMap(docSnapshot);
      usersList.add(users);
    }
    return usersList;
  }

  Future<void> updateName(String userId, String newName) async {
    try {
      await db.collection('users').doc(userId).update({
        "name": newName,
      });
      final videosSnap = await db
          .collection('videos')
          .where('channelId', isEqualTo: userId)
          .get();
      final commentSnap = await db
          .collection('comments')
          .where('userId', isEqualTo: userId)
          .get();
      await FirebaseAuth.instance.currentUser?.updateDisplayName(newName);

      for (var videos in videosSnap.docs) {
        await db.collection('videos').doc(videos.id).update({
          "channelName": newName,
        });
      }
      for (var comments in commentSnap.docs) {
        await db.collection('comments').doc(comments.id).update({
          "name": newName,
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> updateProfilePic(String userId, String url) async {
    try {
      await db.collection('users').doc(userId).update({
        "profileImg": url,
      });
      final videosSnap = await db
          .collection('videos')
          .where('channelId', isEqualTo: userId)
          .get();

      final commentSnap = await db
          .collection('comments')
          .where('userId', isEqualTo: userId)
          .get();

      await FirebaseAuth.instance.currentUser?.updatePhotoURL(url);

      for (var videos in videosSnap.docs) {
        await db.collection('videos').doc(videos.id).update({
          "channelProfile": url,
        });
      }
      for (var comments in commentSnap.docs) {
        await db.collection('comments').doc(comments.id).update({
          "profile": url,
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
