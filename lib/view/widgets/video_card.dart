import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tube_vibe/model/user_model.dart';
import 'package:tube_vibe/model/video_model.dart';
import 'package:tube_vibe/provider/user_provider.dart';
import 'package:tube_vibe/view/core/date_format.dart';
import 'package:tube_vibe/view/core/height_and_width.dart';
import 'package:tube_vibe/view/widgets/text_widgets.dart';

class VideoCard extends StatelessWidget {
  final VoidCallback onTap;
  final VideoModel videoModel;
  final UserModel userModel;

  const VideoCard({
    super.key,
    required this.onTap,
    required this.videoModel,
    required this.userModel,
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
              height: 170,
              child: Image.network(
                videoModel.videoThumbnail,
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
                backgroundImage: NetworkImage(userModel.profileImg),
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
                    text: userModel.name,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    maxLines: 2,
                  ),
                  Row(
                    children: [
                      const CustomText(
                        text: "32k views",
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
  const VideoHorizontalCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          height: 100,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.asset(
              'assets/shogun.jpg',
              fit: BoxFit.cover,
            ),
          ),
        ),
        const Space(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width - 155,
              child: const CustomText(
                text:
                    "Shōgun - Official Trailer | Hiroyuki Sanada, Cosmo Jarvis, Anna Sawai | FX ",
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                maxLines: 2,
              ),
            ),
            const Space(height: 3),
            const CustomText(
              text: "Jk Channel",
              color: Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
            const Row(
              children: [
                CustomText(
                  text: "100K views",
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
                Space(width: 3),
                Icon(
                  Icons.circle,
                  size: 6,
                  color: Colors.grey,
                ),
                Space(width: 3),
                CustomText(
                  text: "10 hours ago",
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ],
            )
          ],
        )
      ],
    );
  }
}

class SmallCard extends StatelessWidget {
  final String image;
  final String title;
  final String? views;
  final String? date;
  const SmallCard({
    super.key,
    required this.image,
    required this.title,
    this.views,
    this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 170,
          height: 100,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              image,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const Space(height: 6),
        SizedBox(
          width: 170,
          child: CustomText(
            text: title,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
            maxLines: 2,
          ),
        ),
        views != null
            ? Row(
                children: [
                  CustomText(
                    text: views ?? '',
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
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
                    text: date ?? '',
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    maxLines: 2,
                  ),
                ],
              )
            : const Space()
      ],
    );
  }
}
