import 'package:flutter/material.dart';
import 'package:tube_vibe/view/widgets/text_widgets.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color? buttonColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.onTap,
    this.buttonColor = const Color.fromRGBO(246, 20, 20, 1),
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(30),
          ),
          height: 40,
          width: 150,
          child: Center(
            child: CustomText(
              text: text,
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
