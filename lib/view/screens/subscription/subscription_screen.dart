import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tube_vibe/model/user_model.dart';
import 'package:tube_vibe/provider/video_provider.dart';
import 'package:tube_vibe/view/screens/video_screen/video_screen.dart';
import 'package:tube_vibe/view/widgets/text_widgets.dart';
import 'package:tube_vibe/view/widgets/video_card.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({
    super.key,
  });

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  late VideoUploadProvider videoUploadProvider;
  @override
  void initState() {
    super.initState();
    videoUploadProvider =
        Provider.of<VideoUploadProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      videoUploadProvider.getSubscribedVideos(userId!);
    });

    return Scaffold(
      appBar: AppBar(
        title: const CustomText(
          text: "Subscriptions",
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Consumer<VideoUploadProvider>(
        builder: (context, value, child) {
          if (value.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: value.subscribedUsers.length,
                    itemBuilder: (context, index) {
                      final UserModel user = value.subscribedUsers[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(user.profileImg),
                        ),
                      );
                    },
                  ),
                ),
                Column(
                  children: value.subscribedVideos.map((video) {
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: VideoCard(
                        videoModel: video,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => VideoScreen(
                              videoId: video.id,
                              videoUrl: video.videoUrl,
                              channelId: video.channelId,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
