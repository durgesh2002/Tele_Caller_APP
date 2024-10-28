import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ButtonComponent extends StatelessWidget {
  final String text;
  final Color? color;
  final VoidCallback onPressed;

  const ButtonComponent({
    super.key,
    required this.text,
    this.color, // Allow color to be optional and fallback to theme color
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    // Get screen width
    final double screenWidth = Get.width;
    return SizedBox(
      width: screenWidth * 0.8, // 80% of the screen width
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color ??
              Theme.of(context).primaryColor, // Use theme color if not provided
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Border radius of 16
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: onPressed,
        child: Text(
          text, // Dynamic text
          style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
        ),
      ),
    );
  }
}
