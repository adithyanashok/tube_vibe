import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tube_vibe/model/user_model.dart';
import 'package:tube_vibe/model/video_model.dart';

class UserService {
  Future<UserModel> getUser(String userId) async {
    try {
      final db = FirebaseFirestore.instance;

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
        final docSnap = await getUser(userIds.channelId);
        users.add(docSnap);
      }
      return users;
    } catch (e) {
      debugPrint(e.toString());

      return [];
    }
  }
}
