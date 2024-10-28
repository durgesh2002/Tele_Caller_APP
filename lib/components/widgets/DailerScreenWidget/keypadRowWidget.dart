import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Add this import
import 'package:smart_solutions/theme/app_theme.dart';

class KeypadRowWidget extends StatelessWidget {
  final List<String> numbers;
  final List<String?> subTexts;
  final Function(String) onDialButtonPressed;

  const KeypadRowWidget({
    Key? key,
    required this.numbers,
    required this.subTexts,
    required this.onDialButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildDialButton(numbers[0], subText: subTexts[0]),
        _buildDialButton(numbers[1], subText: subTexts[1]),
        _buildDialButton(numbers[2], subText: subTexts.length > 2 ? subTexts[2] : null),
      ],
    );
  }

  Widget _buildDialButton(String number, {String? subText}) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(4.w), // Responsive margin
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: AppColors.backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r), // Responsive border radius
            ),
          ),
          onPressed: () => onDialButtonPressed(number),
          child: SizedBox(
            height: 55.h, // Responsive height
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  number,
                  style: TextStyle(
                    fontSize: 24.sp, // Responsive font size
                    color: AppColors.secondayColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (subText != null)
                  Text(
                    subText,
                    style: TextStyle(
                      fontSize: 10.sp, // Responsive font size for subtext
                      color: AppColors.secondayColor,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


  // Build keypad row for cleaner code
  // Widget _buildKeypadRow(List<String> numbers, List<String?> subTexts) {
  //   return Expanded(
  //     child: Row(
  //       children: [
  //         _buildDialButton(numbers[0], subText: subTexts[0]),
  //         _buildDialButton(numbers[1], subText: subTexts[1]),
  //         _buildDialButton(numbers[2], subText: subTexts.length > 2 ? subTexts[2] : null),
  //       ],
  //     ),
  //   );
  // }