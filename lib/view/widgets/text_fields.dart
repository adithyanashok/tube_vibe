import 'package:flutter/material.dart';
import 'package:tube_vibe/view/core/colors.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final IconData? icon;
  final TextEditingController controller;
  final bool obscureText;

  const CustomTextField({
    super.key,
    required this.label,
    this.icon,
    required this.controller,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(
        color: Colors.white,
      ),
      cursorColor: primaryRed,
      decoration: InputDecoration(
        isDense: true,
        labelText: label,
        labelStyle: const TextStyle(
          color: Color.fromARGB(255, 112, 112, 112),
          fontWeight: FontWeight.w400,
          fontSize: 13,
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 68, 68, 68),
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 70, 69, 69),
          ),
        ),
      ),
    );
  }
}

class CustomTextSpace extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  const CustomTextSpace({
    super.key,
    required this.label,
    required this.controller,
  });

  @override
  State<CustomTextSpace> createState() => _CustomTextSpaceState();
}

class _CustomTextSpaceState extends State<CustomTextSpace> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      style: const TextStyle(
        color: Colors.white,
      ),
      cursorColor: primaryRed,
      expands: false,
      maxLines: 10,
      minLines: 2,
      decoration: InputDecoration(
        isDense: true,
        labelText: widget.label,
        labelStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w400,
          fontSize: 15,
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class TextFieldForComment extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final VoidCallback onTap;
  const TextFieldForComment({
    super.key,
    required this.label,
    required this.controller,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextField(
        controller: controller,
        style: const TextStyle(
          color: Colors.white,
        ),
        maxLength: 200,
        cursorColor: primaryRed,
        decoration: InputDecoration(
          isDense: true,
          hintText: "Write something...",
          hintStyle: const TextStyle(
            color: Color.fromARGB(255, 112, 112, 112),
            fontWeight: FontWeight.w400,
            fontSize: 13,
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 70, 69, 69),
            ),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 70, 69, 69),
            ),
          ),
          suffix: IconButton(
            onPressed: () => onTap(),
            icon: const Icon(Icons.send),
          ),
        ),
      ),
    );
  }
}
