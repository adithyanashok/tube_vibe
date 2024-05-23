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
            showModalBottomSheet(
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
          },
          child: VideoDetails(
            title: video.videoTitle,
            views: video.views,
            date: '${video.likes.length} Likes',
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton.icon(
              onPressed: () {
                videoProvider.likeVideo(
                  video.id!,
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
                color: video.likes.contains(userId) ? Colors.red : Colors.white,
              ),
            ),
            const CustomTextButton(
              icon: Icons.playlist_add,
              text: "Watchlist",
            ),
          ],
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
