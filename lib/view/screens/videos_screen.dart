import 'package:flutter/material.dart';
import 'package:tube_vibe/view/widgets/text_widgets.dart';
import 'package:tube_vibe/view/widgets/video_card.dart';

class VideosScreen extends StatelessWidget {
  const VideosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const CustomText(
          text: "Videos",
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.only(left: 25, top: 10),
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (context, index) => const SmallCard(
          image: "assets/const.jpg",
          title: "Constellation | Trailer | Apple TV+",
        ),
      ),
    );
  }
}
