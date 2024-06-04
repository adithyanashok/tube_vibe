import 'package:flutter/material.dart';
import 'package:tube_vibe/view/core/height_and_width.dart';
import 'package:tube_vibe/view/widgets/button_widgets.dart';
import 'package:tube_vibe/view/widgets/text_widgets.dart';

class AuthActionButtons extends StatelessWidget {
  final bool isLoading;
  final String buttonname;
  final String hint;
  final VoidCallback onTap;

  const AuthActionButtons({
    super.key,
    required this.isLoading,
    required this.buttonname,
    required this.hint,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isLoading)
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          )
        else
          CustomElevatedButton(
            width: double.infinity,
            backgroundColor: Colors.red,
            text: 'Continue',
            borderRadius: 10,
            height: 50,
            onTap: () => onTap(),
          ),
        const Space(height: 10),
        GestureDetector(
          onTap: () => Navigator.of(context).pushNamed(buttonname),
          child: CustomRichText(
            text1: hint,
            text2: buttonname,
          ),
        ),
      ],
    );
  }
}
