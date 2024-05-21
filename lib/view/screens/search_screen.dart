import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tube_vibe/view/core/height_and_width.dart';
import 'package:tube_vibe/view/widgets/video_card.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CupertinoSearchTextField(
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, index) => const VideoHorizontalCard(),
          separatorBuilder: (context, index) => const Space(height: 20),
          itemCount: 30,
        ),
      ),
    );
  }
}
