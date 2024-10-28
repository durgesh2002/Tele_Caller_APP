import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Import ScreenUtil
import 'package:smart_solutions/theme/app_theme.dart';

class FollowBackListWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? color;
  
  const FollowBackListWidget({
    Key? key,
    required this.icon,
    required this.text,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16.sp, // Responsive icon size
          color: color ?? AppColors.secondayColor,
        ),
        SizedBox(width: 8.w), // Responsive width
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: color ?? AppColors.secondayColor,
              fontSize: 14.sp, // Responsive font size
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
  // Widget _buildInfoTile(IconData icon, String text) {
  //   return Row(
  //     children: [
  //       Icon(
  //         icon,
  //         size: 16,
  //         color: AppColors.secondayColor,
  //       ),
  //       const SizedBox(width: 8),
  //       Expanded(
  //         child: Text(
  //           text,
  //           style: TextStyle(
  //             color: AppColors.secondayColor,
  //             fontSize: 14,
  //           ),
  //           overflow: TextOverflow.ellipsis,
  //         ),
  //       ),
  //     ],
  //   );
  // }