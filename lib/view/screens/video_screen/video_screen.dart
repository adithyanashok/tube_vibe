
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tube_vibe/provider/user_provider.dart';
import 'package:tube_vibe/provider/video_provider.dart';
import 'package:tube_vibe/view/core/height_and_width.dart';
import 'package:tube_vibe/view/screens/video_screen/widgets/related_videos_section.dart';
import 'package:tube_vibe/view/screens/video_screen/widgets/video_and_channel.dart';
import 'package:tube_vibe/view/screens/video_screen/widgets/video_comment.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends StatefulWidget {
  final String videoUrl;
  final String videoId;
  const VideoScreen({super.key, required this.videoUrl, required this.videoId});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late VideoUploadProvider videoUploadProvider;
  late UserProvider userProvider;
  late FlickManager flickManager;
  @override
  void initState() {
    super.initState();
    videoUploadProvider = Provider.of(context, listen: false);
    videoUploadProvider.fetchVideoById(widget.videoId);
    userProvider = Provider.of(context, listen: false);

    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.networkUrl(
        Uri.parse(
          widget.videoUrl,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VideoUploadProvider>(
      builder: (context, value, child) {
        userProvider.getUser(value.video.channelId);
        return value.isLoading
            ? const CircularProgressIndicator()
            : Scaffold(
                body: SafeArea(
                  child: ListView(
                    children: [
                      Video(flickManager: flickManager),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 10),
                        child: Column(
                          children: [
                            VideoAndChannelSection(
                              video: value.video,
                            ),
                            const Space(height: 15),
                            const VideoCommentSection(),
                            const Space(height: 20),
                            const RelatedVideoSection(),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
      },
    );
  }
}
