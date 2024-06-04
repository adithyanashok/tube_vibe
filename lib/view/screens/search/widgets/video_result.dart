import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tube_vibe/provider/video_provider.dart';
import 'package:tube_vibe/view/core/height_and_width.dart';
import 'package:tube_vibe/view/screens/video_screen/video_screen.dart';
import 'package:tube_vibe/view/widgets/video_card.dart';

class VideoResult extends StatelessWidget {
  const VideoResult({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<VideoUploadProvider>(
      builder: (context, value, child) {
        return SafeArea(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final video = value.searchList[index];
              // final channel = value.userModels[index].name;
              return VideoHorizontalCard(
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
                title: video.videoTitle,
                image: video.videoThumbnail,
                views: video.views,
                date: video.date,
                channel: video.channelName,
              );
            },
            separatorBuilder: (context, index) => const Space(height: 20),
            itemCount: value.searchList.length,
          ),
        );
      },
    );
  }
}
