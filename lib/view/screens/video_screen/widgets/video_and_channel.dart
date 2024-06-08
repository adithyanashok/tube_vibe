import 'package:firebase_auth/firebase_auth.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tube_vibe/model/video_model.dart';
import 'package:tube_vibe/provider/user_provider.dart';
import 'package:tube_vibe/provider/video_provider.dart';
import 'package:tube_vibe/view/core/colors.dart';
import 'package:tube_vibe/view/core/date_format.dart';
import 'package:tube_vibe/view/core/height_and_width.dart';
import 'package:tube_vibe/view/screens/profile/profile_screen.dart';
import 'package:tube_vibe/view/screens/video_screen/widgets/video_details.dart';
import 'package:tube_vibe/view/widgets/button_widgets.dart';
import 'package:tube_vibe/view/widgets/text_widgets.dart';
import 'package:video_player/video_player.dart';

class VideoAndChannelSection extends StatelessWidget {
  final VideoModel video;

  const VideoAndChannelSection({
    super.key,
    required this.video,
  });

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final videoProvider =
        Provider.of<VideoUploadProvider>(context, listen: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => _showDescription(context),
          child: VideoDetails(
            title: video.videoTitle,
            views: video.views,
            date: '${video.likes.length} Likes',
          ),
        ),
        SizedBox(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildLikeButton(videoProvider, userId),
              _buildWatchlistButton(videoProvider, userId!),
              if (video.channelId == userId)
                _buildDeleteButton(videoProvider, userId, context),
            ],
          ),
        ),
        Consumer<UserProvider>(
          builder: (context, value, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildProfileSection(context, value, userId),
                if (userId != video.channelId)
                  _buildSubscribeButton(context, value, userId),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildLikeButton(VideoUploadProvider videoProvider, String? userId) {
    return TextButton.icon(
      onPressed: () => videoProvider.likeVideo(video.id, userId),
      icon: video.likes.contains(userId!)
          ? const Icon(Icons.thumb_up_alt_rounded)
          : const Icon(Icons.thumb_up_alt_outlined, color: Colors.white),
      label: CustomText(
        text: "Like",
        color: video.likes.contains(userId) ? Colors.red : Colors.white,
      ),
    );
  }

  Widget _buildWatchlistButton(
      VideoUploadProvider videoProvider, String userId) {
    return TextButton.icon(
      onPressed: () =>
          videoProvider.addToWatchlist(userId, videoProvider.video.id),
      icon: videoProvider.watchlistIds.contains(videoProvider.video.id)
          ? const Icon(Icons.playlist_add_check)
          : const Icon(Icons.playlist_add, color: Colors.white),
      label: CustomText(
        text: "Watchlist",
        color: videoProvider.watchlistIds.contains(videoProvider.video.id)
            ? Colors.red
            : Colors.white,
      ),
    );
  }

  Widget _buildDeleteButton(
      VideoUploadProvider videoProvider, String? userId, BuildContext context) {
    return TextButton.icon(
      onPressed: () => _showAlert(videoProvider, userId!, context),
      icon: const Icon(Icons.delete, color: Colors.white),
      label: const CustomText(text: "Delete", color: Colors.white),
    );
  }

  Widget _buildProfileSection(
      BuildContext context, UserProvider value, String userId) {
    return Row(
      children: [
        CircleAvatar(
          radius: 23,
          backgroundImage: NetworkImage(value.user.profileImg),
        ),
        const Space(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ProfileScreen(
                      userId: userId == video.channelId
                          ? userId
                          : video.channelId))),
              child: CustomText(
                text: value.user.name,
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
            ),
            CustomText(
              text: "${value.user.subscribers.length} subscribers",
              color: Colors.grey,
              fontWeight: FontWeight.normal,
              fontSize: 12,
            ),
          ],
        )
      ],
    );
  }

  Widget _buildSubscribeButton(
      BuildContext context, UserProvider value, String userId) {
    return CustomElevatedButton(
      backgroundColor: value.user.subscribers.contains(userId)
          ? const Color.fromARGB(255, 44, 44, 44)
          : primaryRed,
      text:
          value.user.subscribers.contains(userId) ? "Subscribed" : "Subscribe",
      borderRadius: 8,
      height: 36,
      onTap: () => value.subscribeChannel(userId, video.channelId),
    );
  }

  Future<dynamic> _showDescription(BuildContext context) {
    return showModalBottomSheet(
      backgroundColor: primaryBlack,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return SizedBox(
          width: double.infinity,
          height: 600,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                VideoDetails(
                  title: video.videoTitle,
                  views: video.views,
                  date: formatDateTimeAgo(video.date),
                ),
                const Space(height: 20),
                CustomText(
                  text: video.description,
                  textAlign: TextAlign.start,
                  color: Colors.white,
                  fontSize: 15,
                  maxLines: 150,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showAlert(VideoUploadProvider videoProvider, String userId,
      BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: primaryBlack,
          surfaceTintColor: primaryBlack,
          title: const CustomText(text: 'Delete Video?', color: Colors.white),
          content: const SingleChildScrollView(
            child: ListBody(
              children: [
                CustomText(
                  text: 'Would you like to delete this video?',
                  color: Colors.white,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const CustomText(text: 'Cancel', color: Colors.white),
            ),
            TextButton(
              onPressed: () => videoProvider.deleteVideo(
                  videoProvider.video.id, userId, context),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

class VideoWidget extends StatefulWidget {
  const VideoWidget({
    super.key,
    required this.videoUrl,
    required this.videoId,
  });

  final String videoUrl;
  final String videoId;

  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  late FlickManager flickManager;
  Duration? halfDuration;
  bool hasAddedView = false;
  late VideoUploadProvider videoUploadProvider;

  @override
  void initState() {
    super.initState();
    videoUploadProvider =
        Provider.of<VideoUploadProvider>(context, listen: false);
    // Initialize FlickManager for video playback
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.networkUrl(
        Uri.parse(widget.videoUrl),
      )..initialize().then((_) {
          // Video is initialized, get the duration and calculate half of it
          setState(() {
            final duration = flickManager
                .flickVideoManager!.videoPlayerController?.value.duration;
            if (duration != null) {
              halfDuration = duration ~/ 2; // Calculate half of the duration
            }
          });

          // Add a listener to track the playback position
          flickManager.flickVideoManager!.videoPlayerController
              ?.addListener(() {
            final position = flickManager
                .flickVideoManager!.videoPlayerController?.value.position;
            if (position != null && halfDuration != null && !hasAddedView) {
              if (position >= halfDuration!) {
                videoUploadProvider.addViews(widget.videoId);
                hasAddedView = true;
              }
            }
          });
        }),
    );
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: FlickVideoPlayer(
        flickManager: flickManager,
      ),
    );
  }
}
