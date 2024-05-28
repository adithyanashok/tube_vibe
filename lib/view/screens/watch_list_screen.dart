import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tube_vibe/provider/video_provider.dart';
import 'package:tube_vibe/view/core/date_format.dart';
import 'package:tube_vibe/view/screens/video_screen/video_screen.dart';
import 'package:tube_vibe/view/widgets/text_widgets.dart';
import 'package:tube_vibe/view/widgets/video_card.dart';

class WatchListScreen extends StatelessWidget {
  const WatchListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    Provider.of<VideoUploadProvider>(context, listen: false)
        .fetchWatchListVideos(userId!);
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const CustomText(
          text: "Watchlist",
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Consumer<VideoUploadProvider>(
        builder: (context, value, child) {
          if (value.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return GridView.builder(
              padding: const EdgeInsets.only(left: 25, top: 10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemBuilder: (context, index) {
                final video = value.watchListVideos[index];
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
                  date: video.date,
                  views: video.views.toString(),
                );
              },
              itemCount: value.watchListVideos.length,
            );
          }
        },
      ),
    );
  }
}
