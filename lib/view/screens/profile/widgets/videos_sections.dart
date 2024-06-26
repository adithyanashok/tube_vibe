import 'package:flutter/material.dart';
import 'package:tube_vibe/model/video_model.dart';
import 'package:tube_vibe/view/core/height_and_width.dart';
import 'package:tube_vibe/view/screens/video_screen/video_screen.dart';
import 'package:tube_vibe/view/widgets/text_widgets.dart';
import 'package:tube_vibe/view/widgets/video_card.dart';

class VideosSection extends StatelessWidget {
  final String title;
  final List<VideoModel> videoModel;
  const VideosSection({
    super.key,
    required this.title,
    required this.videoModel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: title,
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
            GestureDetector(
              onTap: () => Navigator.of(context).pushNamed('videos'),
              child: const CustomText(
                text: "See more",
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        const Space(height: 5),
        SizedBox(
          height: 165,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final video = videoModel[index];
              return SmallCard(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => VideoScreen(
                        videoUrl: video.videoUrl,
                        videoId: video.id,
                        channelId: video.channelId,
                      ),
                    ),
                  );
                },
                image: video.videoThumbnail,
                title: video.videoTitle,
                views: '${video.views}',
                date: video.date,
              );
            },
            separatorBuilder: (context, index) => const Space(width: 10),
            itemCount: videoModel.length,
          ),
        ),
      ],
    );
  }
}
