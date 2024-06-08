
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tube_vibe/provider/video_provider.dart';
import 'package:tube_vibe/view/screens/video_screen/video_screen.dart';
import 'package:tube_vibe/view/widgets/text_widgets.dart';
import 'package:tube_vibe/view/widgets/video_card.dart';

class RelatedVideoSection extends StatelessWidget {
  const RelatedVideoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomText(
          text: "Related videos",
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        Consumer<VideoUploadProvider>(
          builder: (context, videoProvider, child) {
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: videoProvider.relatedVideos.length,
              itemBuilder: (context, index) {
                // log(videoProvider.userModels.toString());
                final video = videoProvider.relatedVideos[index];
                // final channel = videoProvider.userModels[index];

                return Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: VideoHorizontalCard(
                    playing: video.id == videoProvider.video.id,
                    onTap: () => _onVideoTap(context, video, videoProvider),
                    image: video.videoThumbnail,
                    title: video.videoTitle,
                    date: video.date,
                    channel: video.channelName,
                    views: video.views,
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  void _onVideoTap(
      BuildContext context, video, VideoUploadProvider videoProvider) {
    if (video.id != videoProvider.video.id) {
      Navigator.pop(context);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => VideoScreen(
            videoUrl: video.videoUrl,
            videoId: video.id,
            channelId: video.channelId,
          ),
        ),
      );
    }
  }
}
