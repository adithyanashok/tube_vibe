import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tube_vibe/model/comment_model.dart';
import 'package:tube_vibe/model/video_model.dart';
import 'package:tube_vibe/provider/comment_provider.dart';
import 'package:tube_vibe/provider/user_provider.dart';
import 'package:tube_vibe/view/core/colors.dart';
import 'package:tube_vibe/view/widgets/comment_widget.dart';
import 'package:tube_vibe/view/widgets/text_fields.dart';
import 'package:tube_vibe/view/widgets/text_widgets.dart';

class VideoCommentSection extends StatelessWidget {
  final VideoModel video;

  const VideoCommentSection({
    super.key,
    required this.video,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    final commentProvider =
        Provider.of<CommentProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = FirebaseAuth.instance.currentUser;

    return InkWell(
      onTap: () => _showCommentBottomSheet(
          context, controller, user, commentProvider, userProvider),
      child: Consumer<CommentProvider>(
        builder: (context, value, child) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromRGBO(28, 28, 28, 1),
            ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const CustomText(
                text: "Comments",
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              CustomText(
                text: value.comment.isEmpty
                    ? 'No Comments'
                    : value.comment[0].comment,
                color: Colors.white,
                fontSize: 11,
                maxLines: 2,
              ),
            ]),
          );
        },
      ),
    );
  }

  Future<void> _showCommentBottomSheet(
    BuildContext context,
    TextEditingController controller,
    User? user,
    CommentProvider commentProvider,
    UserProvider userProvider,
  ) async {
    showModalBottomSheet(
      backgroundColor: primaryBlack,
      isScrollControlled: true,
      showDragHandle: true,
      context: context,
      builder: (context) {
        return SizedBox(
          width: double.infinity,
          height: 600,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomText(
                  text: "Comments",
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                TextFieldForComment(
                  label: 'label',
                  controller: controller,
                  onTap: () async {
                    if (controller.text.isNotEmpty) {
                      await commentProvider.addComment(
                        CommentModel(
                          name: userProvider.currentUser.name,
                          profile: userProvider.currentUser.profileImg,
                          date: DateTime.now().toIso8601String(),
                          likes: [],
                          userId: user?.uid ?? "",
                          videoId: video.id,
                          comment: controller.text,
                        ),
                      );
                      controller.clear();
                    }
                  },
                ),
                Expanded(
                  child: Consumer<CommentProvider>(
                    builder: (context, value, child) {
                      return ListView.separated(
                        itemCount: value.comment.length,
                        itemBuilder: (context, index) {
                          final comment = value.comment[index];
                          return InkWell(
                            onLongPress: () => _handleLongPress(
                                context, comment, user, commentProvider),
                            child: CommentWidget(
                              comment: comment,
                            ),
                          );
                        },
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 20),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleLongPress(BuildContext context, CommentModel comment,
      User? user, CommentProvider commentProvider) async {
    if (comment.userId == user?.uid) {
      await _showDeleteAlertDialog(context, commentProvider, comment);
    }
  }

  Future<void> _showDeleteAlertDialog(BuildContext context,
      CommentProvider commentProvider, CommentModel comment) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: primaryBlack,
          title: const CustomText(
            text: 'Delete Comment?',
            color: Colors.white,
          ),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                CustomText(
                  text: 'Would you like to delete this comment?',
                  color: Colors.white,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const CustomText(
                text: 'Cancel',
                color: Colors.white,
              ),
            ),
            TextButton(
              onPressed: () =>
                  _deleteComment(context, commentProvider, comment),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteComment(BuildContext context,
      CommentProvider commentProvider, CommentModel comment) async {
    await commentProvider.deleteComment(comment.id!, video.id);
    Navigator.pop(context);
  }
}
