import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tube_vibe/provider/user_provider.dart';
import 'package:tube_vibe/provider/video_provider.dart';
import 'package:tube_vibe/view/core/colors.dart';
import 'package:tube_vibe/view/core/height_and_width.dart';
import 'package:tube_vibe/view/screens/profile/widgets/custom_button.dart';
import 'package:tube_vibe/view/screens/profile/widgets/custom_popup.dart';
import 'package:tube_vibe/view/screens/profile/widgets/videos_sections.dart';
import 'package:tube_vibe/view/widgets/text_fields.dart';
import 'package:tube_vibe/view/widgets/text_widgets.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;

  const ProfileScreen({super.key, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController nameController = TextEditingController();

  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    context.read<VideoUploadProvider>().fetchMyVideos(widget.userId);
    // Fetch user and their videos once the frame is built
    context.read<UserProvider>().getUser(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance.addPostFrameCallback((_) {

    // });

    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return Scaffold(
          appBar: AppBar(
            actions: [
              if (userProvider.user.id == user?.uid)
                CustomPopupMenu(
                  userProvider: userProvider,
                ),
            ],
          ),
          body: SafeArea(
            child: Consumer<VideoUploadProvider>(
              builder: (context, videoProvider, child) {
                if (videoProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return ListView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 50),
                    children: [
                      GestureDetector(
                        onTap: () => userProvider.updateProfile(user?.uid),
                        child: Center(
                          child: SizedBox(
                            width: 130,
                            height: 130,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: CachedNetworkImage(
                                imageUrl: userProvider.user.profileImg,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => updateName(context, user, userProvider),
                        child: CustomText(
                          text: userProvider.user.name,
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      CustomText(
                        text:
                            "${userProvider.user.subscribers.length} Subscribers",
                        color: Colors.grey,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        textAlign: TextAlign.center,
                      ),
                      const Space(height: 10),
                      if (userProvider.user.id == user?.uid)
                        const SizedBox()
                      else if (userProvider.user.subscribers
                          .contains(user?.uid))
                        CustomButton(
                          text: "Subscribed!",
                          buttonColor: const Color.fromARGB(255, 44, 44, 44),
                          onTap: () {},
                        )
                      else
                        CustomButton(
                          text: "Subscribe",
                          onTap: () {},
                        ),
                      const Space(height: 50),
                      if (videoProvider.channelVideos.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            VideosSection(
                              title: "Latest Videos",
                              videoProvider: videoProvider,
                            ),
                            const Space(height: 5),
                            VideosSection(
                              title: "Most Popular",
                              videoProvider: videoProvider,
                            ),
                            const Space(height: 5),
                            VideosSection(
                              title: "Most Liked",
                              videoProvider: videoProvider,
                            ),
                          ],
                        )
                      else
                        const Center(
                          child: CustomText(
                            text: "No video uploaded",
                            color: Colors.white,
                          ),
                        ),
                    ],
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }

  Future<dynamic> updateName(
      BuildContext context, User? user, UserProvider userProvider) {
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
