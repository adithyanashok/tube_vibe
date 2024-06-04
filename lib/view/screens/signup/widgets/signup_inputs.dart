import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tube_vibe/model/user_model.dart';
import 'package:tube_vibe/provider/user_provider.dart';
import 'package:tube_vibe/view/core/colors.dart';
import 'package:tube_vibe/view/widgets/auth_action_buttons.dart';
import 'package:tube_vibe/view/widgets/text_fields.dart';
import 'package:tube_vibe/view/widgets/text_widgets.dart';

class SignupInputs extends StatefulWidget {
  const SignupInputs({super.key});

  @override
  State<SignupInputs> createState() => _SignupInputsState();
}

class _SignupInputsState extends State<SignupInputs> {
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Consumer<UserProvider>(
      builder: (context, value, child) {
        return Column(
          children: [
            if (value.error.isNotEmpty)
              CustomText(
                text: value.error,
                color: primaryRed,
              ),
            CustomTextField(
              label: "Enter your name",
              controller: name,
            ),
            const SizedBox(height: 25),
            CustomTextField(
              label: "Enter your email",
              controller: email,
            ),
            const SizedBox(height: 25),
            CustomTextField(
              label: "Enter your password",
              controller: password,
              icon: Icons.visibility_outlined,
              obscureText: true,
            ),
            const SizedBox(height: 30),
            AuthActionButtons(
              isLoading: value.isLoading,
              buttonname: 'login',
              hint: "Already have an account?",
              onTap: () {
                final user = UserModel(
                  name: name.text,
                  email: email.text,
                );
                if (name.text.isNotEmpty &&
                    email.text.isNotEmpty &&
                    password.text.isNotEmpty) {
                  userProvider.signup(
                    user,
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
