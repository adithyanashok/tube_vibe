import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tube_vibe/provider/video_provider.dart';
import 'package:tube_vibe/view/core/date_format.dart';
import 'package:tube_vibe/view/screens/video_screen/video_screen.dart';
import 'package:tube_vibe/view/widgets/text_widgets.dart';
import 'package:tube_vibe/view/widgets/video_card.dart';

class RelatedVideoSection extends StatelessWidget {
  const RelatedVideoSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomText(
          text: "Related videos",
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        Consumer<VideoUploadProvider>(
          builder: (context, value, child) {
            return Column(
              children: List.generate(
                value.relatedVideos.length,
                (index) {
                  final video = value.relatedVideos[index];
                  final channel = value.userModels[index];
                  return Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: VideoHorizontalCard(
                      playing: video.id == value.video.id,
                      onTap: () async {
                        if (video.id != value.video.id) {
                          Navigator.pop(context);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => VideoScreen(
                                videoUrl: video.videoUrl,
                                videoId: video.id,
                              ),
                            ),
                          );
                        }
                      },
                      image: video.videoThumbnail,
                      title: video.videoTitle,
                      date: video.date,
                      channel: channel.name,
                      views: video.views,
                    ),
                  );
                },
              ),
            );
          },
        )
      ],
    );
  }
}
