import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:tube_vibe/model/comment_model.dart';
import 'package:tube_vibe/model/video_model.dart';
import 'package:tube_vibe/provider/comment_provider.dart';
import 'package:tube_vibe/view/core/colors.dart';
import 'package:tube_vibe/view/core/date_format.dart';
import 'package:tube_vibe/view/core/height_and_width.dart';
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
    final commentProvider = Provider.of<CommentProvider>(context);
    final user = FirebaseAuth.instance.currentUser;

    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromRGBO(28, 28, 28, 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Heading
          const CustomText(
            text: "Comments",
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          // Comment
          Container(
            // height: 40,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(top: 3, left: 10),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(80, 80, 80, 1),
              borderRadius: BorderRadius.circular(6),
            ),
            // Show bottom sheet when clicking
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                  backgroundColor: primaryBlack,
                  isScrollControlled: true,
                  showDragHandle: true,
                  context: context,
                  builder: (context) {
                    // Bottom sheet
                    return SizedBox(
                      width: double.infinity,
                      height: 600,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 20.0,
                          right: 20,
                          bottom: 10,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Bottom sheet heading
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
                                      name: "${user?.displayName}",
                                      profile: "${user?.photoURL}",
                                      date: DateTime.now().toIso8601String(),
                                      likes: [],
                                      userId: "${user?.uid}",
                                      videoId: video.id!,
                                      comment: controller.text,
                                    ),
                                  );
                                  controller.clear();
                                }
                              },
                            ),
                            // Comments list
                            Consumer<CommentProvider>(
                                builder: (context, value, child) {
                              return Expanded(
                                child: ListView.separated(
                                  itemCount: value.comment.length,
                                  itemBuilder: (context, index) {
                                    final comment = value.comment[index];
                                    return CommentWidget(
                                      comment: comment,
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      const Space(height: 20),
                                ),
                              );
                            }),
                            // const Spacer(),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              child:
                  Consumer<CommentProvider>(builder: (context, value, child) {
                return CustomText(
                  text: value.comment.isEmpty
                      ? 'No Comments'
                      : value.comment[0].comment,
                  color: Colors.white,
                  fontSize: 11,
                  maxLines: 2,
                );
              }),
            ),
          )
        ],
      ),
    );
  }
}
