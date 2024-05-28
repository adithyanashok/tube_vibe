import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tube_vibe/model/user_model.dart';
import 'package:tube_vibe/model/video_model.dart';

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

  Future<List<UserModel>> getUsersName(List<VideoModel> userId) async {
    try {
      List<UserModel> users = [];
      for (var userIds in userId) {
        log(userIds.channelId.toString());
        final docSnap = await getUser(userIds.channelId);
        users.add(docSnap);
      }
      return users;
    } catch (e) {
      debugPrint(e.toString());

      return [];
    }
  }

  Future<void> updateName(String userId, String newName) async {
    try {
      await db.collection('users').doc(userId).update({
        "name": newName,
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> updateProfilePic(String userId, String url) async {
    try {
      await db.collection('users').doc(userId).update({
        "profileImg": url,
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
