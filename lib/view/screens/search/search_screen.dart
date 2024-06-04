import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tube_vibe/provider/user_provider.dart';
import 'package:tube_vibe/provider/video_provider.dart';
import 'package:tube_vibe/view/core/height_and_width.dart';
import 'package:tube_vibe/view/screens/search/widgets/channel_result.dart';
import 'package:tube_vibe/view/screens/search/widgets/video_result.dart';
import 'package:tube_vibe/view/screens/video_screen/video_screen.dart';
import 'package:tube_vibe/view/widgets/text_widgets.dart';
import 'package:tube_vibe/view/widgets/video_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  late TextEditingController searchController;
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final videoProvider = Provider.of<VideoUploadProvider>(
      context,
      listen: false,
    );
    final userProvider = Provider.of<UserProvider>(
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
            userProvider.searchUsers(query);
          },
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(20),
          child: TabBar(
            controller: tabController,
            tabs: const [
              CustomText(text: "Videos"),
              CustomText(text: "Channels"),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: const [
          VideoResult(),
          ChannelResult(),
        ],
      ),
    );
  }
}
