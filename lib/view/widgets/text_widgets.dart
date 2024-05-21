import 'package:flutter/material.dart';
import 'package:tube_vibe/view/core/colors.dart';

class CustomText extends StatelessWidget {
  final String text;
  final Color? color;
  final FontWeight? fontWeight;
  final double? fontSize;
  final int? maxLines;
  final TextAlign? textAlign;
  const CustomText({
    super.key,
    required this.text,
    this.color,
    this.fontWeight,
    this.fontSize,
    this.textAlign,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontWeight: fontWeight,
        color: color,
        fontSize: fontSize,
      ),
    );
  }
}

class LogoText extends StatelessWidget {
  const LogoText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const CustomText(
          text: "Tube",
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 27,
        ),
        CustomText(
          text: "Vibe",
          fontWeight: FontWeight.bold,
          color: primaryRed,
          fontSize: 27,
        ),
      ],
    );
  }
}

class CustomRichText extends StatelessWidget {
  final String text1;
  final String text2;
  const CustomRichText({
    super.key,
    required this.text1,
    required this.text2,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          text: text1,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w300,
          ),
          children: <TextSpan>[
            TextSpan(
              text: text2,
              style: TextStyle(
                color: primaryRed,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
