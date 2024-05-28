import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tube_vibe/database/video_service.dart';
import 'package:tube_vibe/model/video_model.dart';
import 'package:tube_vibe/provider/user_provider.dart';
import 'package:tube_vibe/provider/video_provider.dart';
import 'package:tube_vibe/view/core/colors.dart';
import 'package:tube_vibe/view/core/date_format.dart';
import 'package:tube_vibe/view/core/height_and_width.dart';
import 'package:tube_vibe/view/screens/profile_screen.dart';
import 'package:tube_vibe/view/screens/video_screen/widgets/video_details.dart';
import 'package:tube_vibe/view/widgets/button_widgets.dart';
import 'package:tube_vibe/view/widgets/text_widgets.dart';

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
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.getUser(video.channelId);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            showDescription(context);
          },
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
              TextButton.icon(
                onPressed: () {
                  videoProvider.likeVideo(
                    video.id,
                    userId,
                  );
                },
                icon: video.likes.contains(userId!)
                    ? const Icon(Icons.thumb_up_alt_rounded)
                    : const Icon(
                        Icons.thumb_up_alt_outlined,
                        color: Colors.white,
                      ),
                label: CustomText(
                  text: "Like",
                  color:
                      video.likes.contains(userId) ? Colors.red : Colors.white,
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  videoProvider.addToWatchlist(userId, videoProvider.video.id);
                },
                icon:
                    videoProvider.watchlistIds.contains(videoProvider.video.id)
                        ? const Icon(Icons.playlist_add_check)
                        : const Icon(
                            Icons.playlist_add,
                            color: Colors.white,
                          ),
                label: CustomText(
                  text: "Watchlist",
                  color: videoProvider.watchlistIds
                          .contains(videoProvider.video.id)
                      ? Colors.red
                      : Colors.white,
                ),
              ),
              video.channelId == userId
                  ? TextButton.icon(
                      onPressed: () {
                        showAlert(videoProvider, userId, context);
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                      label: const CustomText(
                        text: "Delete",
                        color: Colors.white,
                      ),
                    )
                  : const SizedBox()
            ],
          ),
        ),
        Consumer<UserProvider>(
          builder: (context, value, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
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
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ProfileScreen(
                                userId: userId == video.channelId
                                    ? userId
                                    : video.channelId,
                              ),
                            ),
                          ),
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
                ),
                userId == video.channelId
                    ? const SizedBox()
                    : Consumer<UserProvider>(builder: (context, value, child) {
                        return CustomElevatedButton(
                          backgroundColor:
                              value.user.subscribers.contains(userId)
                                  ? const Color.fromARGB(255, 44, 44, 44)
                                  : primaryRed,
                          text: value.user.subscribers.contains(userId)
                              ? "Subscribed"
                              : "Subscribe",
                          borderRadius: 8,
                          height: 36,
                          onTap: () {
                            userProvider.subscribeChannel(
                              userId,
                              video.channelId,
                            );
                          },
                        );
                      }),
              ],
            );
          },
        ),
      ],
    );
  }

  Future<dynamic> showDescription(BuildContext context) {
    return showModalBottomSheet(
      backgroundColor: primaryBlack,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        // final tags =
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
}

class Video extends StatelessWidget {
  const Video({
    super.key,
    required this.flickManager,
  });

  final FlickManager flickManager;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: FlickVideoPlayer(
        flickManager: flickManager,
      ),
    );
  }
}

Future<void> showAlert(
    VideoUploadProvider videoProvider, String userId, context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: primaryBlack,
        surfaceTintColor: primaryBlack,
        title: const CustomText(
          text: 'Delete Video?',
          color: Colors.white,
        ),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              CustomText(
                text: 'Would you like to delete this video?',
                color: Colors.white,
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const CustomText(
              text: 'Cancel',
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Delete'),
            onPressed: () async {
              await videoProvider.deleteVideo(
                videoProvider.video.id,
                userId,
                context,
              );
            },
          ),
        ],
      );
    },
  );
}
