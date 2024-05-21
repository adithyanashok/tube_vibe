import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tube_vibe/provider/video_provider.dart';

class VideoUploadScreen extends StatelessWidget {
  const VideoUploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final videoUploadProvider =
        Provider.of<VideoUploadProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Video'),
      ),
      body: Center(
        child: videoUploadProvider.isUploading
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: () async {
                  await videoUploadProvider.pickVideo();
                },
                child: const Text('Upload Video'),
              ),
      ),
    );
  }
}
