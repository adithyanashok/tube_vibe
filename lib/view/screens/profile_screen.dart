import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tube_vibe/provider/user_provider.dart';
import 'package:tube_vibe/provider/video_provider.dart';
import 'package:tube_vibe/view/core/colors.dart';
import 'package:tube_vibe/view/core/date_format.dart';
import 'package:tube_vibe/view/core/height_and_width.dart';
import 'package:tube_vibe/view/screens/videos_screen.dart';
import 'package:tube_vibe/view/widgets/text_widgets.dart';
import 'package:tube_vibe/view/widgets/video_card.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;
  const ProfileScreen({super.key, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final UserProvider userProvider;
  late final VideoUploadProvider videoProvider;

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
    videoProvider = Provider.of<VideoUploadProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    userProvider.getUser(widget.userId);
    videoProvider.fetchMyVideos(widget.userId);
    final user = FirebaseAuth.instance.currentUser;

    return Consumer<UserProvider>(
      builder: (context, value, child) {
        return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                onPressed: () => userProvider.logout(context),
                icon: const Icon(Icons.logout),
              ),
            ],
          ),
          body: SafeArea(
            child: value.isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Consumer<VideoUploadProvider>(
                    builder: (context, videoPro, child) {
                    return ListView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 50),
                      children: [
                        Center(
                          child: Container(
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.red,
                              image: DecorationImage(
                                image: NetworkImage(
                                  "${user?.photoURL}",
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        CustomText(
                          text: value.user.name,
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          textAlign: TextAlign.center,
                        ),
                        CustomText(
                          text: "${value.user.subscribers.length} Subscribers",
                          color: Colors.grey,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          textAlign: TextAlign.center,
                        ),
                        const Space(height: 10),
                        Center(
                          child: Container(
                            decoration: BoxDecoration(
                              color: primaryRed,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            height: 48,
                            width: 250,
                            child: value.user.id == user?.uid
                                ? const Center(
                                    child: CustomText(
                                      text: "Edit profile",
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : const Center(
                                    child: CustomText(
                                      text: "Subscribe",
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                        const Space(height: 50),
                        if (videoPro.myVideos.isNotEmpty)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const CustomText(
                                text: "Latest videos",
                                color: Colors.white,
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                              ),
                              GestureDetector(
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const VideosScreen(),
                                  ),
                                ),
                                child: const CustomText(
                                  text: "See more",
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          )
                        else
                          const Space(),
                        if (videoPro.myVideos.isEmpty)
                          const Center(
                            child: CustomText(
                              text: "No video uploaded",
                              color: Colors.white,
                            ),
                          )
                        else
                          const Space(),
                        const Space(height: 5),
                        SizedBox(
                          height: 200,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              final video = videoPro.myVideos[index];
                              return SmallCard(
                                image: video.videoThumbnail,
                                title: video.videoTitle,
                                views: '${video.views} views',
                                date: formatDateTimeAgo(video.date),
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const Space(width: 10),
                            itemCount: videoPro.myVideos.length,
                          ),
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CustomText(
                              text: "Most Popular",
                              color: Colors.white,
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                        const Space(height: 5),
                        SizedBox(
                          height: 200,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              final video = videoPro.myVideos[index];
                              return SmallCard(
                                image: video.videoThumbnail,
                                title: video.videoTitle,
                                views: '${video.views} views',
                                date: formatDateTimeAgo(video.date),
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const Space(width: 10),
                            itemCount: videoPro.myVideos.length,
                          ),
                        ),
                      ],
                    );
                  }),
          ),
        );
      },
    );
  }
}
