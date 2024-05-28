import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tube_vibe/database/user_service.dart';
import 'package:tube_vibe/database/video_service.dart';
import 'package:tube_vibe/model/user_model.dart';
import 'package:tube_vibe/provider/video_provider.dart';
import 'package:tube_vibe/view/core/height_and_width.dart';
import 'package:tube_vibe/view/screens/video_screen/video_screen.dart';
import 'package:tube_vibe/view/widgets/text_widgets.dart';
import 'package:tube_vibe/view/widgets/video_card.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<VideoUploadProvider>(context, listen: false)
          .getSubscribedVideos(userId!);
    });
    UserModel users = UserModel(name: "", email: '');
    return Scaffold(
      appBar: AppBar(
        title: const CustomText(
          text: "Subscrptions",
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
                Container(
                  height: 100,
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: List.generate(
                      value.subscribedUsers.length,
                      (index) {
                        users = value.subscribedUsers[index];
                        return CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(users.profileImg),
                        );
                      },
                    ),
                  ),
                ),
                Column(
                  children: List.generate(
                    value.subscribedVideos.length,
                    (index) {
                      final video = value.subscribedVideos[index];
                      // final users = value.subscribedUsers[index];
                      return VideoCard(
                        videoModel: video,
                        userModel: users,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => VideoScreen(
                              videoId: video.id!,
                              videoUrl: video.videoUrl,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  // ListView.separated(
                  //   padding: const EdgeInsets.all(10),
                  //   itemBuilder: (context, index) {

                  //   },
                  //   separatorBuilder: (context, index) => const Space(height: 20),
                  //   itemCount: value.videos.length,
                  // ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
