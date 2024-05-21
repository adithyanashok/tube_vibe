import 'package:flutter/material.dart';
import 'package:tube_vibe/view/widgets/text_widgets.dart';
import 'package:tube_vibe/view/widgets/video_card.dart';

class RelatedVideoSection extends StatelessWidget {
  const RelatedVideoSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomText(
          text: "Related videos",
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        Column(
          children: List.generate(
            10,
            (index) => const Padding(
              padding: EdgeInsets.only(top: 20),
              child: VideoHorizontalCard(),
            ),
          ),
        )
      ],
    );
  }
}
