import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Import ScreenUtil
import 'package:get/get.dart';
import 'package:smart_solutions/constants/static_stored_data.dart';
import 'package:smart_solutions/routes/app_routes.dart';
import 'package:smart_solutions/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import Shared Preferences

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); // Check login status when the splash screen initializes
  }

  // Check if user is already logged in
  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId =
        prefs.getString('userId'); // Retrieve user ID from Shared Preferences

    // Navigate to the appropriate screen after a delay
    Future.delayed(const Duration(seconds: 3), () {
      if (userId != null) {
        StaticStoredData.userId = userId;
        // User is logged in, navigate to MainScreen
        // Navigator.of(context).pushReplacement(
        //   MaterialPageRoute(builder: (context) => const MainScreen()),
        // );
        // Navigator.of(context).pushAndRemoveUntil(
        //     MaterialPageRoute(builder: (context) => const MainScreen()),
        //     (Route<dynamic> route) => route.isFirst);
        Get.offAllNamed(AppRoutes.navigationscreen);
      } else {
        // User is not logged in, navigate to LoginView
        // Navigator.of(context).pushAndRemoveUntil(
        //     MaterialPageRoute(builder: (context) => const LoginView()),
        //     (Route<dynamic> route) => route.isFirst);
        Get.offAllNamed(AppRoutes.login);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor, // Background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Replace this with your app's logo image
            Image.asset(
              'assets/images/sd_logo.png', // Make sure the path matches your image location
              height: 100.h, // Use responsive height
              width: 250.w, // Use responsive width
            ),
          ],
        ),
      ),
    );
  }
}
