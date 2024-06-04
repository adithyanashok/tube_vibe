// import 'package:flutter/material.dart';

// showSnackBar(
//   BuildContext context,
//   String msg,
// ) {
//   final snackBar = SnackBar(
//     content: Text(
//       msg,
//       style: const TextStyle(
//         color: Colors.white,
//         fontSize: 14,
//       ),
//     ),
//     elevation: 2,
//     backgroundColor: Colors.red,
//     duration: const Duration(seconds: 5),
//     behavior: SnackBarBehavior.fixed,
//   );
//   return ScaffoldMessenger.of(context).showSnackBar(snackBar);
// }

import 'package:flutter/material.dart';

class TopSnackBar extends StatelessWidget {
  final String message;

  const TopSnackBar({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          message,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
    );
  }
}

void showSnackBar(BuildContext context, String message) {
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: MediaQuery.of(context).padding.top +
          16, // Adjust for status bar height
      left: 16,
      right: 16,
      child: TopSnackBar(message: message),
    ),
  );

  overlay.insert(overlayEntry);

  // Remove the snackbar after the duration
  Future.delayed(const Duration(seconds: 5), () {
    overlayEntry.remove();
  });
}
