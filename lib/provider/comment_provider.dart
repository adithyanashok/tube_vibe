import 'package:flutter/material.dart';
import 'package:tube_vibe/database/comment_service.dart';
import 'package:tube_vibe/model/comment_model.dart';

class CommentProvider with ChangeNotifier {
  final commentService = CommentService();
  String _error = '';
  List<CommentModel> _comments = [];

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
}
