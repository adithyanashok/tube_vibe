import 'dart:async';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tube_vibe/provider/user_provider.dart';
import 'package:tube_vibe/provider/video_provider.dart';
import 'package:tube_vibe/view/core/colors.dart';
import 'package:tube_vibe/view/screens/home/home_screen.dart';
import 'package:tube_vibe/view/screens/profile/profile_screen.dart';
import 'package:tube_vibe/view/screens/search/search_screen.dart';
import 'package:tube_vibe/view/screens/subscription/subscription_screen.dart';
import 'package:tube_vibe/view/screens/upload/upload_screen.dart';
import 'package:tube_vibe/view/widgets/button_widgets.dart';
import 'package:tube_vibe/view/widgets/text_widgets.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  final List<Widget> _screens = [
    const HomeScreen(),
    const SearchScreen(),
    const SubscriptionScreen(),
    ProfileScreen(userId: "${FirebaseAuth.instance.currentUser?.uid}"),
  ];
  int _bottomNavIndex = 0;

  // Variable to store the current connectivity status
  late ConnectivityResult _connectivityResult;

  @override
  void initState() {
    super.initState();

    // Initialize with a default value for connectivity status
    _connectivityResult = ConnectivityResult.mobile;

    // Check and listen for changes in internet connectivity
    _checkInternetConnection();
    Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        _connectivityResult = result;
      });
    });
  }

  // Function to check internet connectivity
  Future<void> _checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    setState(() {
      _connectivityResult = connectivityResult;
    });
  }

  @override
  Widget build(BuildContext context) {
    context.read<UserProvider>().getUser(userId);
    context.read<VideoUploadProvider>().fetchMyVideos(userId!);
    final videoUploadProvider =
        Provider.of<VideoUploadProvider>(context, listen: false);

    // Clear the search list whenever MainScreen is built
    videoUploadProvider.clearSearchList();

    // Check for internet connectivity and show appropriate screen
    return _connectivityResult == ConnectivityResult.none
        ? const NoInternet()
        : Scaffold(
            body: _screens[_bottomNavIndex], // Destination screen
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                videoPickingMethod(context, videoUploadProvider);
              },
              backgroundColor: primaryRed,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
              elevation: 0,
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 30,
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
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
              onTap: (index) => setState(() {
                _bottomNavIndex = index;
              }),
            ),
          );
  }

  Future<dynamic> videoPickingMethod(
      BuildContext context, VideoUploadProvider videoUploadProvider) {
    return showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        backgroundColor: primaryBlack,
        surfaceTintColor: primaryBlack,
        children: [
          Consumer<VideoUploadProvider>(builder: (context, value, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Button to pick thumbnail
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
                    // Button to pick video
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
                    ),
                  ],
                ),
                // Button to continue to upload screen
                CustomElevatedButton(
                  backgroundColor: value.pickedThumbnail && value.pickedVideo
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
                            thumbnail: videoUploadProvider.thumbnailFile!,
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
      ),
    );
  }
}

class NoInternet extends StatelessWidget {
  const NoInternet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image indicating no internet connection
            SizedBox(
              width: 300,
              height: 300,
              child: Image.asset(
                'assets/no-internet.png',
                fit: BoxFit.cover,
              ),
            ),
            const CustomText(
              text: "No Connection!",
              color: Colors.white,
              fontSize: 24,
            ),
          ],
        ),
      ),
    );
  }
}
