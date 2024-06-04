import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tube_vibe/provider/video_provider.dart';
import 'package:tube_vibe/view/screens/video_screen/video_screen.dart';
import 'package:tube_vibe/view/widgets/text_widgets.dart';
import 'package:tube_vibe/view/widgets/video_card.dart';

class VideosScreen extends StatelessWidget {
  const VideosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const CustomText(
          text: "Videos",
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Consumer<VideoUploadProvider>(
        builder: (context, value, child) {
          // Check if channel videos data is available
          if (value.channelVideos.isEmpty) {
            return const Center(
              child: Text(
                "No videos available",
                style: TextStyle(color: Colors.black),
              ),
            );
          }
          return GridView.builder(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemBuilder: (context, index) {
              final video = value.channelVideos[index];
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
                date: video.date,
                views: video.views.toString(),
              );
            },
            itemCount: value.channelVideos.length,
          );
        },
      ),
    );
  }
}
