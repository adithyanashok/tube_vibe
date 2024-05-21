import 'package:flutter/material.dart';
import 'package:tube_vibe/view/widgets/text_widgets.dart';

class VideoCommentSection extends StatelessWidget {
  const VideoCommentSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromRGBO(28, 28, 28, 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            text: "Comments",
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          Container(
            height: 40,
            padding: const EdgeInsets.only(top: 3, left: 10),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(80, 80, 80, 1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const CustomText(
              text:
                  "Lorem ipsum dollar summit new spanish language is gemiminew spanish language is gemimi Lorem ipsum dollar summit",
              color: Colors.white,
              fontSize: 11,
              maxLines: 2,
            ),
          )
        ],
      ),
    );
  }
}
