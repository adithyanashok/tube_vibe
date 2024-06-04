import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tube_vibe/provider/user_provider.dart';
import 'package:tube_vibe/view/core/colors.dart';
import 'package:tube_vibe/view/widgets/auth_action_buttons.dart';
import 'package:tube_vibe/view/widgets/text_fields.dart';
import 'package:tube_vibe/view/widgets/text_widgets.dart';

class LoginInputs extends StatelessWidget {
  LoginInputs({super.key});

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Consumer<UserProvider>(
      builder: (context, value, child) {
        return Column(
          children: [
            // Display error message if any
            CustomText(
              text: value.error,
              color: primaryRed,
            ),
            const SizedBox(height: 25),
            // Email input field
            CustomTextField(
              label: "Enter your email",
              controller: email,
              onSubmitted: (value) {},
            ),
            const SizedBox(height: 25),
            // Password input field
            CustomTextField(
              label: "Enter your password",
              controller: password,
              icon: Icons.visibility_outlined,
              obscureText: true,
              onSubmitted: (value) {},
            ),
            const SizedBox(height: 25),
            // Sign in button
            AuthActionButtons(
              isLoading: value.isLoading,
              buttonname: 'signup',
              hint: 'Don\'t have an account?',
              onTap: () {
                if (email.text.isNotEmpty && password.text.isNotEmpty) {
                  userProvider.loginMethod(
                    email.text,
                    password.text,
                    context,
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
