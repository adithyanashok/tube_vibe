import 'package:flutter/material.dart';
import 'package:tube_vibe/view/screens/login/widgets/login_inputs.dart';
import 'package:tube_vibe/view/widgets/logo.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final List<Widget> _widgets = [
    const LogoLarge(
      heading: "Sign in to continue",
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
      ),
    );
  }
}
