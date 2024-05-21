import 'dart:developer';
import 'dart:io';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:tube_vibe/provider/video_provider.dart';
import 'package:tube_vibe/view/core/colors.dart';
import 'package:tube_vibe/view/core/height_and_width.dart';
import 'package:tube_vibe/view/widgets/tag_input.dart';
import 'package:tube_vibe/view/widgets/text_fields.dart';
import 'package:tube_vibe/view/widgets/text_widgets.dart';
import 'package:video_player/video_player.dart';

class UploadScreen extends StatefulWidget {
  final File thumbnail;
  final File video;
  const UploadScreen({super.key, required this.thumbnail, required this.video});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  late StringTagController stringTagController;
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
    stringTagController = StringTagController();
  }

  @override
  void dispose() {
    super.dispose();
    stringTagController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final videoProvider =
        Provider.of<VideoUploadProvider>(context, listen: false);
    return Consumer<VideoUploadProvider>(
      builder: (context, value, child) {
        log(value.runtimeType.toString());
        return Scaffold(
          appBar: AppBar(
            title: const CustomText(
              text: "Upload Video",
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          body: Stack(
            children: [
              ListView(
                padding: const EdgeInsets.all(10),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: 180,
                        height: 100,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: Image.file(
                            widget.thumbnail,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 180,
                        height: 100,
                        child: FlickVideoPlayer(
                          flickManager: flickManager,
                        ),
                      ),
                    ],
                  ),
                  const Space(height: 50),
                  CustomTextField(
                    controller: titleController,
                    label: "Title",
                  ),
                  const Space(height: 30),
                  CustomTextSpace(
                    label: "Description",
                    controller: descController,
                  ),
                  const Space(height: 30),
                  StringMultilineTags(
                    stringTagController: stringTagController,
                  ),
                  const Space(height: 50),
                  InkWell(
                    onTap: () {
                      upload(
                        titleController,
                        descController,
                        videoProvider,
                        stringTagController,
                        context,
                      );
                    },
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: primaryRed,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: CustomText(
                          text: "Upload",
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (value.isUploading)
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.black.withOpacity(0.9),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
            ],
          ),
        );
      },
    );
  }
}

void upload(titleController, descController, videoProvider, stringTagController,
    context) {
  if (titleController.text.isNotEmpty && descController.text.isNotEmpty) {
    videoProvider.uploadVideo(
      titleController.text,
      descController.text,
      stringTagController.getTags ?? [],
      context,
    );
  }
}
