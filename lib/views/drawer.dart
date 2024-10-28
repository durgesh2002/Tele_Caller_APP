import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_solutions/controllers/dashboard_controller.dart';
import 'package:smart_solutions/controllers/login_controllers.dart';
import 'package:smart_solutions/views/data_entry_screen.dart';
import 'package:smart_solutions/views/login_screen.dart';

class CustomDrawer extends StatelessWidget {
  CustomDrawer({super.key});

  final DashboardController _dashboardController =
      Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Column(
          children: <Widget>[
            Stack(children: [
              UserAccountsDrawerHeader(
                accountName: const Text('John Doe'),
                accountEmail: const Text('john.doe@example.com'),
                currentAccountPicture: const CircleAvatar(
                  backgroundImage: AssetImage(
                      'assets/images/sd_logo.png'), // Replace with your image URL
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              Positioned(
                  top: 10,
                  right: 10,
                  child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        onPressed: () {
                          _dashboardController.toggleDrawer();
                          Get.back();
                        },
                        icon: const Icon(Icons.close),
                      )))
            ]),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Add navigation logic here
              },
            ),
            ListTile(
              leading: const Icon(Icons.list_alt_rounded),
              title: const Text('Data entry list'),
              onTap: () {
                Get.to(() => DataEntryViewScreen()); // Close the drawer
                // Add navigation logic here
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About Us'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Add navigation logic here
              },
            ),
            const Divider(), // Divider for separation
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.clear();

                Get.put(LoginViewModel());

                Get.offAll(() => const LoginView());

                // ignore: unused_local_variable
                final LoginViewModel controller = Get.find();
              },
            ),
          ],
        ),
      ),
    );
  }
}
