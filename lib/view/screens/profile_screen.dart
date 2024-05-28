import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tube_vibe/provider/user_provider.dart';
import 'package:tube_vibe/provider/video_provider.dart';
import 'package:tube_vibe/view/core/colors.dart';
import 'package:tube_vibe/view/core/date_format.dart';
import 'package:tube_vibe/view/core/height_and_width.dart';
import 'package:tube_vibe/view/screens/video_screen/video_screen.dart';
import 'package:tube_vibe/view/screens/videos_screen.dart';
import 'package:tube_vibe/view/widgets/button_widgets.dart';
import 'package:tube_vibe/view/widgets/text_fields.dart';
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
  late final TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
    videoProvider = Provider.of<VideoUploadProvider>(context, listen: false);
    nameController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      userProvider.getUser(widget.userId);
      videoProvider.fetchMyVideos(widget.userId);
    });
    final user = FirebaseAuth.instance.currentUser;

    return Consumer<UserProvider>(
      builder: (context, value, child) {
        return Scaffold(
          appBar: AppBar(
            actions: [
              PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'Watchlist':
                      Navigator.of(context).pushNamed('watch-list');
                      break;
                    case 'Sign Out':
                      userProvider.logout(context);
                      break;
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    const PopupMenuItem<String>(
                      value: 'Watchlist',
                      child: Text('Watchlist'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'Sign Out',
                      child: Text('Sign Out'),
                    ),
                  ];
                },
                icon: const Icon(Icons.more_vert),
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
                        GestureDetector(
                          onTap: () => userProvider.updateProfile(user?.uid),
                          child: Center(
                            child: Container(
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.red,
                                image: DecorationImage(
                                  image: NetworkImage(
                                    value.user.profileImg,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => updateName(context, user),
                          child: CustomText(
                            text: value.user.name,
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        CustomText(
                          text: "${value.user.subscribers.length} Subscribers",
                          color: Colors.grey,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          textAlign: TextAlign.center,
                        ),
                        const Space(height: 10),
                        if (value.user.id == user?.uid)
                          const SizedBox()
                        else
                          value.user.subscribers.contains(user?.uid)
                              ? CustomButton(
                                  text: "Subscribed!",
                                  buttonColor:
                                      const Color.fromARGB(255, 44, 44, 44),
                                  onTap: () {},
                                )
                              : CustomButton(
                                  text: "Subscribe",
                                  onTap: () {},
                                ),
                        const Space(height: 50),
                        if (videoPro.channelVideos.isNotEmpty)
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
                        if (videoPro.channelVideos.isEmpty)
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
                              final video = videoPro.channelVideos[index];
                              return SmallCard(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => VideoScreen(
                                        videoUrl: video.videoUrl,
                                        videoId: video.id,
                                      ),
                                    ),
                                  );
                                },
                                image: video.videoThumbnail,
                                title: video.videoTitle,
                                views: '${video.views} views',
                                date: video.date,
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const Space(width: 10),
                            itemCount: videoPro.channelVideos.length,
                          ),
                        ),
                        if (videoPro.channelVideos.isNotEmpty)
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
                              final video = videoPro.channelVideos[index];
                              return SmallCard(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => VideoScreen(
                                        videoUrl: video.videoUrl,
                                        videoId: video.id,
                                      ),
                                    ),
                                  );
                                },
                                image: video.videoThumbnail,
                                title: video.videoTitle,
                                views: '${video.views} views',
                                date: video.date,
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const Space(width: 10),
                            itemCount: videoPro.channelVideos.length,
                          ),
                        ),
                        if (videoPro.channelVideos.isNotEmpty)
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CustomText(
                                text: "Most Liked",
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
                              final video = videoPro.channelVideos[index];
                              return SmallCard(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => VideoScreen(
                                        videoUrl: video.videoUrl,
                                        videoId: video.id,
                                      ),
                                    ),
                                  );
                                },
                                image: video.videoThumbnail,
                                title: video.videoTitle,
                                views: '${video.views} views',
                                date: video.date,
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const Space(width: 10),
                            itemCount: videoPro.channelVideos.length,
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

  Future<dynamic> updateName(context, User? user) {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          contentPadding: const EdgeInsets.all(20),
          backgroundColor: primaryBlack,
          surfaceTintColor: primaryBlack,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomTextField(
                  label: "Name",
                  initialValue: userProvider.user.name,
                  onSubmitted: (value) async {
                    await userProvider.updateName("${user?.uid}", value);
                    Navigator.pop(context);
                  },
                ),
                const Space(height: 20),
              ],
            ),
          ],
        );
      },
    );
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color? buttonColor;
  const CustomButton({
    super.key,
    required this.text,
    required this.onTap,
    this.buttonColor = const Color.fromRGBO(246, 20, 20, 1),
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Center(
        child: Container(
            decoration: BoxDecoration(
              color: buttonColor,
              borderRadius: BorderRadius.circular(30),
            ),
            height: 40,
            width: 150,
            child: Center(
              child: CustomText(
                text: text,
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            )),
      ),
    );
  }
}
