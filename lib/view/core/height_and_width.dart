import 'package:flutter/material.dart';

class Space extends StatelessWidget {
  final double? height;
  final double? width;
  const Space({super.key, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
    );
  }
}
