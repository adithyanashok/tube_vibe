
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tube_vibe/provider/user_provider.dart';
import 'package:tube_vibe/view/core/colors.dart';
import 'package:tube_vibe/view/screens/signup_screen.dart';
import 'package:tube_vibe/view/widgets/logo.dart';
import 'package:tube_vibe/view/widgets/text_fields.dart';
import 'package:tube_vibe/view/widgets/text_widgets.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final List _widgets = [
    const LogoLarge(
      heading: "Signin to continue",
      loginMessage: "Sign in for Seamless Access to Your Favorites!",
    ),
    LoginInputs(),
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

class LoginButton extends StatelessWidget {
  const LoginButton({
    super.key,
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
          child: const Center(
            child: CustomText(
              text: "Signin",
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
        const SizedBox(height: 40),
        GestureDetector(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => SignupScreen(),
            ),
          ),
          child: const CustomRichText(
            text1: 'Dont have an account?',
            text2: 'Signup',
          ),
        ),
      ],
    );
  }
}

class LoginInputs extends StatelessWidget {
  LoginInputs({
    super.key,
  });

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
            const SizedBox(height: 25),
            GestureDetector(
              onTap: () {
                if (emailController.text.isNotEmpty &&
                    passwordController.text.isNotEmpty) {
                  userProvider.loginMethod(
                    emailController.text,
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
