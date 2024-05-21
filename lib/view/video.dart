import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tube_vibe/provider/video_provider.dart';

class VideoListScreen extends StatelessWidget {
  const VideoListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final videoUploadProvider =
        Provider.of<VideoUploadProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Video List'),
      ),
      body: FutureBuilder(
        future: videoUploadProvider.fetchVideos(),
        builder: (context, snapshot) {
          // if (snapshot.connectionState == ConnectionState.waiting) {
          //   print(snapshot.connectionState);
          //   return const Center(child: CircularProgressIndicator());
          // }
          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching videos'));
          }
          return ListView.builder(
            itemCount: videoUploadProvider.videos.length,
            itemBuilder: (context, index) {
              final video = videoUploadProvider.videos[index];
              return ListTile(
                title: Text(video.videoTitle),
                subtitle: Text(video.description),
                onTap: () async {},
              );
            },
          );
        },
      ),
    );
  }
}
