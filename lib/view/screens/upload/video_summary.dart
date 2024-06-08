import 'dart:io';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:tube_vibe/view/core/height_and_width.dart';
import 'package:tube_vibe/view/widgets/button_widgets.dart';
import 'package:tube_vibe/view/widgets/text_widgets.dart';
import 'package:video_player/video_player.dart';

class VideoSummary extends StatefulWidget {
  final File thumbnail;
  final File video;
  const VideoSummary({super.key, required this.thumbnail, required this.video});

  @override
  State<VideoSummary> createState() => _VideoSummaryState();
}

class _VideoSummaryState extends State<VideoSummary> {
  late FlickManager flickManager;

  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
      autoPlay: false,
      videoPlayerController: VideoPlayerController.file(
        widget.video,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    flickManager.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const Space(),
        title: const CustomText(
          text: "Preview",
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          const Space(height: 20),
          SizedBox(
            height: 160,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: Image.file(
                widget.thumbnail,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const Space(height: 20),
          SizedBox(
            child: FlickVideoPlayer(
              flickManager: flickManager,
            ),
          ),
          const Space(height: 40),
          CustomElevatedButton(
            backgroundColor: Colors.red,
            text: "Back to upload",
            borderRadius: 5,
            height: 50,
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
