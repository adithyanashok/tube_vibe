import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tube_vibe/view/core/colors.dart';
import 'package:tube_vibe/view/screens/login_screen.dart';
import 'package:tube_vibe/view/screens/main_screen.dart';
import 'package:tube_vibe/view/widgets/text_widgets.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    // Delayed execution after 3 seconds
    Future.delayed(
      const Duration(seconds: 3),
      () async {
        // Authenticate the user using LocalAuthApi (authentication logic not shown)

        // Check if the user is authenticated
        if (user != null) {
          // If the user is there, navigate to a home
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const MainScreen(),
            ),
            (route) => false,
          );
        } else {
          // If the user's email is not verified, navigate to login
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ),
            (route) => false,
          );
        }
      },
    );
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CustomText(
              text: "Tube",
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 40,
            ),
            CustomText(
              text: "Vibe",
              fontWeight: FontWeight.bold,
              color: primaryRed,
              fontSize: 40,
            ),
          ],
        ),
      ),
    );
  }
}
