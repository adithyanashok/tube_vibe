import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tube_vibe/model/comment_model.dart';
import 'package:tube_vibe/provider/comment_provider.dart';
import 'package:tube_vibe/view/core/date_format.dart';
import 'package:tube_vibe/view/core/height_and_width.dart';
import 'package:tube_vibe/view/widgets/text_widgets.dart';

class CommentWidget extends StatelessWidget {
  final CommentModel comment;
  const CommentWidget({
    super.key,
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    final commentProvider =
        Provider.of<CommentProvider>(context, listen: false);
    // Width
    final width = MediaQuery.of(context).size.width;
    final userId = FirebaseAuth.instance.currentUser?.uid;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile image of comment author
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.network(
                comment.profile,
                width: 40,
                fit: BoxFit.cover,
              ),
            ),
            const Space(width: 10),
            // Name and comment widgets
            SizedBox(
              width: width - 90,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Name
                      CustomText(
                        text: comment.name,
                        color: const Color.fromARGB(
                          255,
                          212,
                          212,
                          212,
                        ),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      const Space(width: 6),
                      // Time ago
                      CustomText(
                        text: formatDateTimeAgo(
                          comment.date,
                        ),
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ],
                  ),
                  // Comment here
                  CustomText(
                    text: comment.comment,
                    color: Colors.white,
                    maxLines: 10,
                    fontSize: 12,
                  ),
                  // Like button
                  const Space(height: 6),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          commentProvider.likeComment(
                            comment.id!,
                            userId!,
                            comment.videoId,
                          );
                        },
                        child: comment.likes.contains(userId)
                            ? const Icon(
                                Icons.favorite,
                                size: 14,
                                color: Colors.red,
                              )
                            : const Icon(
                                Icons.favorite_border_rounded,
                                size: 14,
                                color: Color.fromARGB(255, 163, 163, 163),
                              ),
                      ),
                      const Space(width: 5),
                      CustomText(
                        text: comment.likes.length.toString(),
                        color: Colors.grey,
                        fontSize: 11,
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        )
      ],
    );
  }
}
