import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tube_vibe/view/screens/upload/video_summary.dart';

class CoverImage extends StatelessWidget {
  final File thumbnail;
  final File video;
  const CoverImage({
    super.key,
    required this.thumbnail,
    required this.video,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => VideoSummary(
              thumbnail: thumbnail,
              video: video,
            ),
          ),
        );
      },
      child: Stack(
        children: [
          Stack(
            children: [
              Center(
                child: SizedBox(
                  height: 180,
                  child: Image.file(
                    thumbnail,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                height: 180,
                color: Colors.black.withOpacity(0.5),
              ),
            ],
          ),
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            top: 0,
            child: Icon(
              Icons.play_arrow_rounded,
              color: Colors.white,
              size: 100,
            ),
          )
        ],
      ),
    );
  }
}
