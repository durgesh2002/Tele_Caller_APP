import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Import ScreenUtil
import 'package:get/get.dart';
import 'core/app_bindings.dart';
import 'routes/app_routes.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375,
          812), // Set design size based on your design (e.g., iPhone X size)
      minTextAdapt: true,
      builder: (context, child) {
        return GetMaterialApp(
          initialBinding: AppBinding(),
          initialRoute: AppRoutes.splashScreen,
          getPages: AppRoutes.pages,
          debugShowCheckedModeBanner: false,
          title: 'Smart Solutions',
          theme: AppTheme.lightTheme,
        );
      },
    );
  }
}
