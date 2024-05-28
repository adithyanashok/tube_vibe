import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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
  final userId = FirebaseAuth.instance.currentUser?.uid;
  late VideoUploadProvider videoUploadProvider;
  late UserProvider userProvider;
  late CommentProvider commentProvider;
  late FlickManager flickManager;
  @override
  void initState() {
    super.initState();
    videoUploadProvider = Provider.of(context, listen: false);
    videoUploadProvider.fetchVideoById(widget.videoId);
    videoUploadProvider.fetchWatchlistIds(userId!);
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    log("LOG AT VIDSCREEN => DidChangeDependencies");
  }

  @override
  void didUpdateWidget(covariant VideoScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    log("LOG AT VIDSCREEN => DidiUpdateWidget => $oldWidget");
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      commentProvider.getComments(widget.videoId);
    });
    // VideoProvider Builder
    return Consumer<UserProvider>(builder: (context, userValue, child) {
      return Consumer<VideoUploadProvider>(
        builder: (context, value, child) {
          userProvider.getUser(value.video.channelId);

          // Loader
          if (value.isLoading && userValue.isLoading) {
            return const Center(child: CircularProgressIndicator());
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
                        vertical: 0,
                        horizontal: 10,
                      ),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              // Video and channel details section
                              const Space(height: 20),

                              VideoAndChannelSection(video: value.video),
                              const Space(height: 15),
                              // Comments section
                              VideoCommentSection(
                                video: value.video,
                              ),
                              const Space(height: 20),
                              // Related video section
                              const RelatedVideoSection(),
                            ],
                          ),
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
    });
  }
}
