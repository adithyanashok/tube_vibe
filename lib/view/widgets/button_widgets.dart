import 'package:flutter/material.dart';
import 'package:tube_vibe/view/widgets/text_widgets.dart';

class CustomTextButton extends StatelessWidget {
  final IconData icon;
  final String text;
  const CustomTextButton({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {},
      icon: Icon(
        icon,
        color: Colors.white,
      ),
      label: CustomText(
        text: text,
        color: Colors.white,
      ),
    );
  }
}

class CustomElevatedButton extends StatelessWidget {
  final Color backgroundColor;
  final String text;
  final double borderRadius;
  final double? width;
  final double height;
  final VoidCallback onTap;
  const CustomElevatedButton({
    super.key,
    required this.backgroundColor,
    required this.text,
    required this.borderRadius,
    this.width = 0,
    required this.height,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(backgroundColor),
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        minimumSize: MaterialStatePropertyAll(
          Size(width!, height),
        ),
      ),
      onPressed: () => onTap(),
      child: CustomText(
        text: text,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
