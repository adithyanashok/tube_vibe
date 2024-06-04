// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:tube_vibe/service/comment_service.dart';
import 'package:tube_vibe/model/comment_model.dart';

class CommentProvider with ChangeNotifier {
  CommentService commentService;
  String _error = '';
  List<CommentModel> _comments = [];
  CommentProvider(this.commentService);

  // Getter
  String get error => _error;
  List<CommentModel> get comment => _comments;

  // Add Comment
  Future<void> addComment(CommentModel comment) async {
    try {
      await commentService.saveComment(comment);
      await getComments(comment.videoId);
    } catch (e) {
      _error = "Something wen wrong...";
      notifyListeners();
    }
  }

  // Get comments of a video
  Future<void> getComments(String videoId) async {
    try {
      _comments = await commentService.getComments(videoId);
      notifyListeners();
    } catch (e) {
      _error = "Something wen wrong...";
      notifyListeners();
    }
  }

  // Like comment
  Future<void> likeComment(
      String commentId, String userId, String videoId) async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('comments')
          .doc(commentId)
          .get();
      final db = FirebaseFirestore.instance;

      if (docSnapshot.exists) {
        log("message+++++++++++++++++++++++++++++++++++++");
        // Check if user already liked the video
        final likedByUser =
            docSnapshot.data()!['likes']?.contains(userId) ?? false;

        if (!likedByUser) {
          // Add user to likes array
          db.collection('comments').doc(commentId).update({
            'likes': FieldValue.arrayUnion([userId]),
          });
          getComments(videoId);
        } else {
          // Remove user from likes array (unlike)
          db.collection('comments').doc(commentId).update({
            'likes': FieldValue.arrayRemove([userId]),
          });
          getComments(videoId);
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // Get comments of a video
  Future<void> deleteComment(String commentId, String videoId) async {
    try {
      await commentService.deleteComment(commentId);
      await getComments(videoId);
      notifyListeners();
    } catch (e) {
      _error = "Something wen wrong...";
      notifyListeners();
    }
  }
}
