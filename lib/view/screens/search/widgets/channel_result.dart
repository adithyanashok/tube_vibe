import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tube_vibe/provider/user_provider.dart';
import 'package:tube_vibe/view/core/height_and_width.dart';
import 'package:tube_vibe/view/widgets/text_widgets.dart';

class ChannelResult extends StatelessWidget {
  const ChannelResult({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, value, child) {
      return ListView.separated(
        padding: const EdgeInsets.all(15),
        itemBuilder: (context, index) {
          final channels = value.searchList[index];
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 70,
                height: 70,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: CachedNetworkImage(
                    imageUrl: channels.profileImg,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const Space(width: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: channels.name,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  CustomText(
                    text: "${channels.subscribers.length} Subscribers",
                    color: Colors.grey,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              )
            ],
          );
        },
        separatorBuilder: (context, index) => const Space(height: 15),
        itemCount: value.searchList.length,
      );
    });
  }
}
