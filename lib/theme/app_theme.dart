import 'package:flutter/material.dart';

class AppTheme {
  // Define light theme
  static final ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor:
        AppColors.backgroundColor, // Scaffold background color
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.appBarColor, // AppBar background color
      elevation: 0, // You can adjust the AppBar shadow (optional)
      titleTextStyle: TextStyle(
        color: AppColors.appBarTextColor, // AppBar title text color
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme:
          IconThemeData(color: AppColors.appBarTextColor), // AppBar icon color
    ),
    buttonTheme: ButtonThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      buttonColor: AppColors.primaryColor,
      textTheme: ButtonTextTheme.primary,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.textColor),
      bodyMedium: TextStyle(color: AppColors.textColor),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor, // Button color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: const TextStyle(fontSize: 16, color: Colors.white),
      ),
    ),
  );

  // Define dark theme (optional)
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: Colors.black, // Scaffold color for dark theme
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.appBarColor, // AppBar color for dark theme
      titleTextStyle: TextStyle(
        color:
            AppColors.appBarTextColor, // AppBar title text color for dark theme
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: AppColors.appBarTextColor),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
    ),
  );
}

// Define your app-specific colors

class AppColors {
   
    static const Color grid1 = Color(0xFFBDE7F4); // Light Blue (Completed Calls)
  static const Color grid2 = Color(0xFFD7F1FE); // Sky Blue (Pending Calls)
  static const Color grid3 = Color(0xFFF6E6C6); // Beige (Interested Calls)
  static const Color grid4 = Color(0xFFFFE6EB); // Light Pink (Not Interested Calls)
  static const Color textColor2 = Color(0xFF000000); // Black (Text color for contrast)
  static const Color primaryColor =  Color.fromRGBO(25, 118, 210, 1); // Example: Purple
  static const Color secondayColor = Color(0xFF5E5E5E); // Example: Purple
  static const Color accentColor = Color(0xFFFF5722); // Example: Orange
  static const Color backgroundColor =
      Color.fromARGB(255, 255, 255, 255); // Scaffold background color
  static const Color textColor =
      Color.fromARGB(255, 255, 255, 255); // Text color
  static const Color appBarColor =  Color.fromRGBO(25, 118, 210, 1); // AppBar background color
  static const Color appBarTextColor = Colors.white; // AppBar text/icon color
}