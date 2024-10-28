import 'dart:convert';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_solutions/constants/api_urls.dart';
import 'package:smart_solutions/constants/static_stored_data.dart';
import 'package:smart_solutions/services/api_service.dart';
import 'package:smart_solutions/views/navigationbar.dart';

import '../constants/services.dart'; // Direct navigation to MainScreen

class LoginViewModel extends GetxController {
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();
  var isLoading = false.obs;
  final ApiService _apiService = ApiService(); // ApiService instance

  void login() async {
    isLoading.value = true;

    Map<String, dynamic> loginData = {
      'username': usernameController.text.trim(),
      'password': passwordController.text.trim(),
    };

    try {
      final response =
          await _apiService.postRequest(APIUrls.loginUrl, loginData);
      var responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        String userId = responseData['profile']
            ['id']; // Adjust according to your API response structure
        StaticStoredData.userId = userId;
        // Store the user ID locally using Shared Preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', userId);
        // Navigate to the MainScreen on successful login
        Get.off(() => const MainScreen());
        showDialog(
            context: (Get.context!),
            builder: (context) => AlertDialog(
                  // backgroundColor: Color(0xffFFE839),
                  // title: Center(child: const Text("Attendance Marked")),
                  content: Container(
                      decoration: BoxDecoration(
                        // color: Colors.yellow,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Lottie.asset("assets/animations/success.json",
                              height: 100, width: 100),
                          const Center(
                              child: Text(
                            "Logged In Successfully",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          )),
                        ],
                      )),
                  actions: [
                    Center(
                      child: FractionallySizedBox(
                        widthFactor: 0.6,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                  Theme.of(context).primaryColor)),
                          onPressed: () {
                            Get.back();
                          },
                          child: const Text(
                            "Okay",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                ));
        //  Get.snackbar('Login','Sucessfully');

        // Navigate to the MainScreen after dialog closes
        // await Future.delayed(const Duration(seconds: 2));
      } else {
        Get.snackbar('Error', 'Invalid username or password');
      }
    } catch (e) {
      logOutput('$e');
      Get.snackbar('Error', 'Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }
}

class SuccessDialog extends StatelessWidget {
  const SuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return const AlertDialog(
      content: Row(
        children: [
          CircularProgressIndicator(),
          SizedBox(width: 20),
          Expanded(
              child: Text("Login Successful!", style: TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}
