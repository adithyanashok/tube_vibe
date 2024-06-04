import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tube_vibe/model/comment_model.dart';

class CommentService {
  final db = FirebaseFirestore.instance;
  Future<void> saveComment(CommentModel comment) async {
    // Saving to firestore
    final newComment = await db.collection('comments').add(comment.toMap());
    await db.collection('comments').doc(newComment.id).update({
      "id": newComment.id,
    });
  }

  Future<List<CommentModel>> getComments(String videoId) async {
    // Empty VideoModel list
    final List<CommentModel> videosList = [];
    // Fetch video from db
    final querySnapshot = await db
        .collection('comments')
        .where('videoId', isEqualTo: videoId)
        .get();

    for (var docSnapshot in querySnapshot.docs) {
      final videoData = docSnapshot.data();
      final videos = CommentModel.fromMap(videoData);
      videosList.add(videos);
    }
    return videosList;
  }

  Future<void> deleteComment(String commentId) async {
    // Fetch video from db
    await db.collection('comments').doc(commentId).delete();
  }
}
