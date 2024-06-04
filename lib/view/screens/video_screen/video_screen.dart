import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tube_vibe/provider/comment_provider.dart';
import 'package:tube_vibe/provider/user_provider.dart';
import 'package:tube_vibe/provider/video_provider.dart';
import 'package:tube_vibe/view/core/height_and_width.dart';
import 'package:tube_vibe/view/screens/video_screen/widgets/related_videos_section.dart';
import 'package:tube_vibe/view/screens/video_screen/widgets/video_and_channel.dart';
import 'package:tube_vibe/view/screens/video_screen/widgets/video_comment.dart';

class VideoScreen extends StatefulWidget {
  final String videoUrl;
  final String videoId;
  final String channelId;
  const VideoScreen(
      {super.key,
      required this.videoUrl,
      required this.videoId,
      required this.channelId});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  late VideoUploadProvider videoUploadProvider;
  late UserProvider userProvider;
  late CommentProvider commentProvider;

  @override
  void initState() {
    super.initState();

    // Initialize providers
    videoUploadProvider =
        Provider.of<VideoUploadProvider>(context, listen: false);
    userProvider = Provider.of<UserProvider>(context, listen: false);
    commentProvider = Provider.of<CommentProvider>(context, listen: false);
    videoUploadProvider.fetchVideoById(widget.videoId);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      videoUploadProvider.fetchWatchlistIds(userId!);
      commentProvider.getComments(widget.videoId);
      // Fetch user details
      userProvider.getUser(widget.channelId);
      // Fetch video details and watchlist IDs
    });
    return Consumer<VideoUploadProvider>(
      builder: (context, videoValue, child) {
        // Show loader if data is still loading
        if (videoValue.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Scaffold(
            body: SafeArea(
              child: ListView(
                children: [
                  // Video Player widget
                  VideoWidget(
                    videoUrl: widget.videoUrl,
                    videoId: widget.videoId,
                  ),

                  // Video Details and Comments
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const Space(height: 20),
                          // Video and Channel Details
                          VideoAndChannelSection(video: videoValue.video),
                          const Space(height: 15),
                          // Comments Section
                          VideoCommentSection(video: videoValue.video),
                          const Space(height: 20),
                          // Related Videos Section
                          const RelatedVideoSection(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
