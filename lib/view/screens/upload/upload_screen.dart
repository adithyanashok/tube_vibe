import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:tube_vibe/provider/video_provider.dart';
import 'package:tube_vibe/view/core/colors.dart';
import 'package:tube_vibe/view/core/height_and_width.dart';
import 'package:tube_vibe/view/widgets/tag_input.dart';
import 'package:tube_vibe/view/widgets/text_fields.dart';
import 'package:tube_vibe/view/widgets/text_widgets.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

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
    flickManager.dispose();
    stringTagController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final videoProvider =
        Provider.of<VideoUploadProvider>(context, listen: false);
    return Consumer<VideoUploadProvider>(
      builder: (context, value, child) {
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: 120,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: Image.file(
                            widget.thumbnail,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const Space(height: 40),
                      SizedBox(
                        height: 140,
                        child: FlickVideoPlayer(
                          flickManager: flickManager,
                        ),
                      ),
                    ],
                  ),
                  const Space(height: 40),
                  CustomTextField(
                    controller: titleController,
                    label: "Title",
                  ),
                  const Space(height: 20),
                  CustomTextSpace(
                    label: "Description",
                    controller: descController,
                  ),
                  const Space(height: 20),
                  StringMultilineTags(
                    stringTagController: stringTagController,
                  ),
                  const Space(height: 20),
                  InkWell(
                    onTap: () {
                      _upload(
                        titleController.text,
                        descController.text,
                        stringTagController,
                        videoProvider,
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
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: LinearProgressIndicator(
                            value: value.uploadProgress / 100,
                            backgroundColor: Colors.grey,
                            color: Colors.red,
                            minHeight: 12,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Uploading: ${value.uploadProgress.toStringAsFixed(2)}%',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _upload(
      String title,
      String description,
      StringTagController tagController,
      VideoUploadProvider videoProvider,
      BuildContext context) {
    // Check if title and description are not empty
    if (title.isNotEmpty && description.isNotEmpty) {
      // Get tags from tag controller
      List<String> tags = tagController.getTags ?? [];
      // Call upload video method from provider
      videoProvider.uploadVideo(title, description, tags, context);
    }
  }
}
