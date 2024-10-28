import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_solutions/theme/app_theme.dart';
import '../components/button_component.dart';
import '../controllers/login_controllers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Import ScreenUtil

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  LoginViewState createState() => LoginViewState();
}

class LoginViewState extends State<LoginView> {
  final LoginViewModel controller = Get.find();
  final _formKey = GlobalKey<FormState>(); // Form key for validation
  bool _isObscured = true; // State for password visibility

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       resizeToAvoidBottomInset: false, // Ensure the body resizes when the keyboard opens
      appBar: AppBar(title: const Text('Login')),
      body: SingleChildScrollView(
        child: Padding(
          padding:EdgeInsets.only(bottom:MediaQuery.of(context).viewInsets.bottom ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end, // Align children to the center
            children: [
              SizedBox(height: 40.h,),
              Form(
                key: _formKey, // Assign form key for validation
                child: Column(
                  children: [
                    
                    // Username TextFormField
                    Image.asset(
                      "assets/images/login.jpg",
                      height: 250.h, // Adjust image height with ScreenUtil
                      width: 250.w,  // Adjust image width with ScreenUtil
                    ),
                    Padding(
                      padding:  EdgeInsets.only(left: 15.w,right: 15.w),
                      child: TextFormField(
                        
                        style: const TextStyle(color: AppColors.primaryColor),
                        controller: controller.usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16.r)), // Use ScreenUtil for radius
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your username';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 16.h), // Use ScreenUtil for height
                    
                        // Password TextFormField with eye icon
                    Padding(
                      padding:  EdgeInsets.only(bottom: 10.h,left:15.w,right: 15.w,top: 15.h ),
                      child: TextFormField(
                        style: const TextStyle(color: AppColors.primaryColor),
                        controller: controller.passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16.r)), // Use ScreenUtil for radius
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isObscured ? Icons.visibility : Icons.visibility_off,
                              color: Theme.of(context).primaryColor,
                            ),
                            onPressed: () {
                              setState(() {
                                _isObscured = ! _isObscured;
                              });
                            },
                          ),
                        ),
                        obscureText: _isObscured, // Use the state variable for visibility
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          } else if (value.length < 6) {
                            return 'Password must be at least 6 characters long';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 24.h), // Use ScreenUtil for height
                    
                    // Login Button with Loading Indicator
                    Obx(() {
                      return controller.isLoading.value
                          ? const CircularProgressIndicator()
                          : ButtonComponent(
                              text: 'Login',
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  // Call the login method from the controller
                                  controller.login();
               
              
                // Close the dialog
                                  controller.usernameController.clear();
                                  controller.passwordController.clear();
                                }
                              },
                            );
                    }),
                    
                    // Add a "Forgot Password?" Link
                    SizedBox(height: 16.h), // Use ScreenUtil for height
                    TextButton(
                      onPressed: () {
                        // Add action for "Forgot Password"
                        Get.snackbar(
                          'Forgot Password',
                          'Reset link sent to email!',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h), // Use ScreenUtil for height
            ],
          ),
        ),
      ),
    );
  }
}

