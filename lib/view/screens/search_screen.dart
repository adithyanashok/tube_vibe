import 'package:tube_vibe/view/screens/video_screen/video_screen.dart';

import '';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tube_vibe/provider/video_provider.dart';
import 'package:tube_vibe/view/core/colors.dart';
import 'package:tube_vibe/view/core/height_and_width.dart';
import 'package:tube_vibe/view/widgets/video_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController searchController;
  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final videoProvider = Provider.of<VideoUploadProvider>(
      context,
      listen: false,
    );

    return Scaffold(
      appBar: AppBar(
        title: CupertinoSearchTextField(
          controller: searchController,
          style: const TextStyle(
            color: Colors.white,
          ),
          onSubmitted: (query) {
            videoProvider.searchVideos(query);
          },
        ),
      ),
      body: Consumer<VideoUploadProvider>(
        builder: (context, value, child) {
          return SafeArea(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final video = value.searchList[index];
                final channel = value.userModels[index].name;
                return VideoHorizontalCard(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => VideoScreen(
                          videoUrl: video.videoUrl,
                          videoId: video.id!,
                        ),
                      ),
                    );
                  },
                  title: video.videoTitle,
                  image: video.videoThumbnail,
                  views: video.views,
                  date: video.date,
                  channel: channel,
                );
              },
              separatorBuilder: (context, index) => const Space(height: 20),
              itemCount: value.searchList.length,
            ),
          );
        },
      ),
    );
  }
}
