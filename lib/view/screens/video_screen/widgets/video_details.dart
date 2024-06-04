import 'package:flutter/material.dart';
import 'package:tube_vibe/view/widgets/text_widgets.dart';

class VideoDetails extends StatelessWidget {
  final String title;
  final int views;
  final String date;

  const VideoDetails({
    super.key,
    required this.title,
    required this.views,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: CustomText(
            text: title,
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
            maxLines: 2,
          ),
        ),
        Row(
          children: [
            CustomText(
              text: "$views views",
              color: Colors.grey,
              fontWeight: FontWeight.w400,
              fontSize: 13,
              maxLines: 2,
            ),
            const SizedBox(width: 5),
            const Icon(
              Icons.circle,
              size: 7,
              color: Colors.grey,
            ),
            const SizedBox(width: 5),
            CustomText(
              text: date,
              color: Colors.grey,
              fontWeight: FontWeight.w400,
              fontSize: 13,
              maxLines: 2,
            ),
          ],
        ),
      ],
    );
  }
}
