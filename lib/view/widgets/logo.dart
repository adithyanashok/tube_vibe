import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tube_vibe/view/core/colors.dart';
import 'package:tube_vibe/view/widgets/text_widgets.dart';

class LogoLarge extends StatelessWidget {
  final String heading;
  final String loginMessage;
  const LogoLarge({
    super.key,
    required this.heading,
    required this.loginMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CustomText(
              text: "Tube",
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 35,
            ),
            CustomText(
              text: "Vibe",
              fontWeight: FontWeight.bold,
              color: primaryRed,
              fontSize: 35,
            ),
          ],
        ),
        const SizedBox(height: 10),
        CustomText(
          text: heading,
          fontSize: 19,
          color: Colors.white,
          fontWeight: FontWeight.w500,
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 5),
          child: CustomText(
            text: loginMessage,
            color: Colors.white,
            fontSize: 15,
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        )
      ],
    );
  }
}
