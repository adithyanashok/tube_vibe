import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tube_vibe/model/user_model.dart';
import 'package:tube_vibe/model/video_model.dart';
import 'package:tube_vibe/view/core/date_format.dart';
import 'package:tube_vibe/view/core/height_and_width.dart';
import 'package:tube_vibe/view/widgets/text_widgets.dart';

class VideoCard extends StatelessWidget {
  final VoidCallback onTap;
  final VideoModel videoModel;

  const VideoCard({
    super.key,
    required this.onTap,
    required this.videoModel,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 370,
              height: 160,
              child: CachedNetworkImage(
                imageUrl: videoModel.videoThumbnail,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const Space(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(videoModel.channelProfile),
              ),
              const Space(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 90,
                    child: CustomText(
                      text: videoModel.videoTitle,
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      maxLines: 1,
                    ),
                  ),
                  CustomText(
                    text: videoModel.channelName,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    maxLines: 2,
                  ),
                  Row(
                    children: [
                      CustomText(
                        text: "${videoModel.views} views",
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        maxLines: 2,
                      ),
                      const Space(width: 5),
                      const Icon(
                        Icons.circle,
                        size: 7,
                        color: Colors.grey,
                      ),
                      const Space(width: 5),
                      CustomText(
                        text: formatDateTimeAgo(videoModel.date),
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        maxLines: 2,
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class VideoHorizontalCard extends StatelessWidget {
  final String image;
  final String title;
  final String date;
  final int views;
  final String channel;
  final VoidCallback onTap;
  final bool? playing;
  const VideoHorizontalCard({
    super.key,
    required this.image,
    required this.title,
    required this.date,
    required this.views,
    required this.channel,
    required this.onTap,
    this.playing = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                    image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              playing == true
                  ? Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      width: 100,
                      height: 100,
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 40,
                      ),
                    )
                  : const SizedBox()
            ],
          ),
          const Space(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width - 155,
                child: CustomText(
                  text: title,
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  maxLines: 2,
                ),
              ),
              const Space(height: 3),
              CustomText(
                text: channel,
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
              Row(
                children: [
                  CustomText(
                    text: "$views views",
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                  const Space(width: 3),
                  const Icon(
                    Icons.circle,
                    size: 6,
                    color: Colors.grey,
                  ),
                  const Space(width: 3),
                  CustomText(
                    text: formatDateTimeAgo(date),
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}

class SmallCard extends StatelessWidget {
  final String image;
  final String title;
  final String views;
  final String date;
  final VoidCallback onTap;
  const SmallCard({
    super.key,
    required this.image,
    required this.title,
    required this.views,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 160,
            height: 90,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const Space(height: 6),
          SizedBox(
            width: 160,
            child: CustomText(
              text: title,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
              maxLines: 2,
            ),
          ),
          Row(
            children: [
              CustomText(
                text: "$views views",
                color: Colors.grey,
                fontWeight: FontWeight.w500,
                fontSize: 12,
                maxLines: 2,
              ),
              const Space(width: 3),
              const Icon(
                Icons.circle,
                size: 7,
                color: Colors.grey,
              ),
              const Space(width: 3),
              CustomText(
                text: formatDateTimeAgo(date),
                color: Colors.grey,
                fontWeight: FontWeight.w500,
                fontSize: 12,
                maxLines: 2,
              ),
            ],
          )
        ],
      ),
    );
  }
}
