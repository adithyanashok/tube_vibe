import 'package:flutter/material.dart';
import 'package:tube_vibe/view/widgets/text_widgets.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomText(
          text: "Subscrptions",
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      // body: ListView.separated(
      //   padding: const EdgeInsets.all(10),
      //   itemBuilder: (context, index) => VideoCard(
      //     onTap: () => Navigator.of(context).push(
      //       MaterialPageRoute(
      //         builder: (context) => const VideoScreen(),
      //       ),
      //     ),
      //   ),
      //   separatorBuilder: (context, index) => const Space(height: 20),
      //   itemCount: 10,
      // ),
    );
  }
}
