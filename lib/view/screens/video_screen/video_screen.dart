import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tube_vibe/provider/comment_provider.dart';
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
  late CommentProvider commentProvider;
  late FlickManager flickManager;
  @override
  void initState() {
    super.initState();
    videoUploadProvider = Provider.of(context, listen: false);
    videoUploadProvider.fetchVideoById(widget.videoId);
    userProvider = Provider.of(context, listen: false);
    commentProvider = Provider.of(context, listen: false);

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
    // VideoProvider Builder
    return Consumer<VideoUploadProvider>(
      builder: (context, value, child) {
        // Extracting video from video provider
        final video = value.video;
        // Calling getUser function
        userProvider.getUser(value.video.channelId);
        commentProvider.getComments(widget.videoId);

        // Loader
        if (value.isLoading) {
          return const CircularProgressIndicator();
        } else {
          return Scaffold(
            body: SafeArea(
              child: ListView(
                children: [
                  // Video Player widget
                  Video(flickManager: flickManager),
                  // Video Details section
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 10,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // Video and channel details section
                          VideoAndChannelSection(video: video),
                          const Space(height: 15),
                          // Comments section
                          VideoCommentSection(
                            video: video,
                          ),
                          const Space(height: 20),
                          // Related video section
                          const RelatedVideoSection(),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
