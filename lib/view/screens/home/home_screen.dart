import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tube_vibe/provider/video_provider.dart';
import 'package:tube_vibe/view/core/height_and_width.dart';
import 'package:tube_vibe/view/screens/video_screen/video_screen.dart';
import 'package:tube_vibe/view/widgets/text_widgets.dart';
import 'package:tube_vibe/view/widgets/video_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch videos on the initial build
    Provider.of<VideoUploadProvider>(context, listen: false).fetchVideos();

    return Scaffold(
      appBar: AppBar(
        title: const LogoText(),
      ),
      body: Consumer<VideoUploadProvider>(
        builder: (context, videoProvider, child) {
          // Display a loading indicator while videos are being fetched
          if (videoProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return RefreshIndicator(
              onRefresh: () async {
                await videoProvider.fetchVideos();
                videoProvider.videos
                    .shuffle(); // Randomize video order on refresh
              },
              child: ListView.separated(
                itemCount: videoProvider.videos.length,
                padding: const EdgeInsets.all(10),
                itemBuilder: (context, index) {
                  final video = videoProvider.videos[index];

                  return VideoCard(
                    videoModel: video,
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
                  );
                },
                separatorBuilder: (context, index) {
                  return const Space(height: 20);
                },
              ),
            );
          }
        },
      ),
    );
  }
}
