
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
    Provider.of<VideoUploadProvider>(context, listen: false).fetchVideos();
    return Scaffold(
        appBar: AppBar(
          title: const LogoText(),
        ),
        body: Consumer<VideoUploadProvider>(
          builder: (context, value, child) {
            return value.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.separated(
                    padding: const EdgeInsets.all(10),
                    itemBuilder: (context, index) {
                      final video = value.videos[index];

                      return VideoCard(
                        videoModel: video,
                        userModel: value.userModels[index],
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => VideoScreen(
                                videoUrl: video.videoUrl,
                                videoId: video.id!,
                              ),
                            ),
                          );
                        },
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const Space(height: 20),
                    itemCount: value.videos.length,
                  );
          },
        ));
  }
}
