import 'package:flutter/material.dart';
import 'package:tube_vibe/view/screens/signup/widgets/signup_inputs.dart';
import 'package:tube_vibe/view/widgets/logo.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final List<Widget> _widgets = [
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
      ),
    );
  }
}
