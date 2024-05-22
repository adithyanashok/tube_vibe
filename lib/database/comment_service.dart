import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tube_vibe/model/comment_model.dart';
import 'package:tube_vibe/provider/comment_provider.dart';

class CommentService {
  final db = FirebaseFirestore.instance;
  Future<void> saveComment(CommentModel comment) async {
    // Saving to firestore
    await db.collection('comments').add(comment.toMap());
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
}
