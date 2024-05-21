
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tube_vibe/provider/video_provider.dart';
import 'package:tube_vibe/view/core/colors.dart';
import 'package:tube_vibe/view/screens/home_screen.dart';
import 'package:tube_vibe/view/screens/profile_screen.dart';
import 'package:tube_vibe/view/screens/search_screen.dart';
import 'package:tube_vibe/view/screens/subscription_screen.dart';
import 'package:tube_vibe/view/screens/upload_screen.dart';
import 'package:tube_vibe/view/widgets/button_widgets.dart';
import 'package:tube_vibe/view/widgets/text_widgets.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List _screens = [
    const HomeScreen(),
    const SearchScreen(),
    const SubscriptionScreen(),
    ProfileScreen(userId: "${FirebaseAuth.instance.currentUser?.uid}"),
  ];
  int _bottomNavIndex = 0;
  @override
  Widget build(BuildContext context) {
    final videoUploadProvider =
        Provider.of<VideoUploadProvider>(context, listen: false);
    return Scaffold(
      body: _screens[_bottomNavIndex], //destination screen
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => SimpleDialog(
                    backgroundColor: primaryBlack,
                    surfaceTintColor: primaryBlack,
                    children: [
                      Consumer<VideoUploadProvider>(
                          builder: (context, value, child) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton.icon(
                                  onPressed: () {
                                    videoUploadProvider.pickThumbnail();
                                  },
                                  icon: Icon(
                                    value.pickedThumbnail
                                        ? Icons.check
                                        : Icons.add_photo_alternate_outlined,
                                    color: Colors.white,
                                  ),
                                  label: const CustomText(
                                    text: "Thumbnail",
                                    color: Colors.white,
                                  ),
                                ),
                                TextButton.icon(
                                  onPressed: () {
                                    videoUploadProvider.pickVideo();
                                  },
                                  icon: Icon(
                                    value.pickedVideo
                                        ? Icons.check
                                        : Icons.video_call_outlined,
                                    color: Colors.white,
                                  ),
                                  label: const CustomText(
                                    text: "Video",
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                            CustomElevatedButton(
                              backgroundColor:
                                  value.pickedThumbnail && value.pickedVideo
                                      ? primaryRed
                                      : Colors.grey,
                              text: "Continue",
                              borderRadius: 8,
                              height: 36,
                              onTap: () {
                                if (videoUploadProvider.videoFile != null &&
                                    videoUploadProvider.thumbnailFile != null) {
                                  Navigator.pop(context);
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => UploadScreen(
                                        thumbnail:
                                            videoUploadProvider.thumbnailFile!,
                                        video: videoUploadProvider.videoFile!,
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        );
                      }),
                    ],
                  ));
        },
        backgroundColor: primaryRed,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        elevation: 0,
        //params
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 27, 27, 27),
        activeColor: primaryRed,
        splashRadius: 0,
        icons: const [
          Icons.home_filled,
          Icons.search,
          Icons.subscriptions_outlined,
          Icons.person_2_outlined,
        ],
        inactiveColor: Colors.white,
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.softEdge,
        leftCornerRadius: 20,
        rightCornerRadius: 20,
        onTap: (index) => setState(() => _bottomNavIndex = index),
        //other params
      ),
    );
  }
}
