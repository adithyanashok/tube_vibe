import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tube_vibe/model/user_model.dart';
import 'package:tube_vibe/provider/user_provider.dart';
import 'package:tube_vibe/view/core/colors.dart';
import 'package:tube_vibe/view/screens/login_screen.dart';
import 'package:tube_vibe/view/widgets/logo.dart';
import 'package:tube_vibe/view/widgets/text_fields.dart';
import 'package:tube_vibe/view/widgets/text_widgets.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final List _widgets = [
    const LogoLarge(
      heading: "Signup to continue",
      loginMessage: "Signup for Seamless Access to Your Favorites!",
    ),
    const SignupInputs(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 100),
      itemBuilder: (context, index) => _widgets[index],
      separatorBuilder: (context, index) => const SizedBox(height: 20),
      itemCount: _widgets.length,
    ));
  }
}

class SignupButton extends StatelessWidget {
  final bool isLoading;
  const SignupButton({
    super.key,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 60,
          decoration: BoxDecoration(
            color: primaryRed,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(),
                  )
                : const CustomText(
                    text: "Signup",
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
          ),
        ),
        const SizedBox(height: 40),
        GestureDetector(
          onTap: () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ),
          ),
          child: const CustomRichText(
            text1: 'Already have an account?',
            text2: 'Signin',
          ),
        ),
      ],
    );
  }
}

class SignupInputs extends StatefulWidget {
  const SignupInputs({
    super.key,
  });

  @override
  State<SignupInputs> createState() => _SignupInputsState();
}

class _SignupInputsState extends State<SignupInputs> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Consumer<UserProvider>(
      builder: (context, value, child) {
        return Column(
          children: [
            CustomText(
              text: value.error,
              color: primaryRed,
            ),
            CustomTextField(
              label: "Enter your name",
              controller: nameController,
            ),
            const SizedBox(height: 25),
            CustomTextField(
              label: "Enter your email",
              controller: emailController,
            ),
            const SizedBox(height: 25),
            CustomTextField(
              label: "Enter your password",
              controller: passwordController,
              icon: Icons.visibility_outlined,
              obscureText: true,
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                final user = UserModel(
                  name: nameController.text,
                  email: emailController.text,
                );
                if (nameController.text.isNotEmpty &&
                    emailController.text.isNotEmpty &&
                    passwordController.text.isNotEmpty) {
                  userProvider.signup(
                    user,
                    passwordController.text,
                    context,
                  );
                }
              },
              child: SignupButton(
                isLoading: value.isLoading,
              ),
            )
          ],
        );
      },
    );
  }
}
