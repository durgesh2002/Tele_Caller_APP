// lib/views/main_screen.dart
import 'package:flutter/material.dart';
import 'package:smart_solutions/views/dailer_scree.dart';
import 'package:smart_solutions/views/followBackList.dart';
import 'package:smart_solutions/views/login_request_screen.dart';
import '../theme/app_theme.dart';
import 'dashboard_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    DashboardScreen(),
    const DialerScreen(),
    FollowBackListScreen(),
    LoginRequestScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        backgroundColor: AppColors.backgroundColor,
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(
              Icons.dashboard_outlined,
              color: AppColors.secondayColor,
            ),
            selectedIcon: Icon(
              Icons.dashboard,
              color: AppColors.primaryColor,
            ),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.dialpad_outlined,
              color: AppColors.secondayColor,
            ),
            selectedIcon: Icon(
              Icons.dialpad,
              color: AppColors.primaryColor,
            ),
            label: 'Dialer',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.list_alt_outlined,
              color: AppColors.secondayColor,
            ),
            selectedIcon: Icon(
              Icons.list_alt_outlined,
              color: AppColors.primaryColor,
            ),
            label: 'List',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.co_present_rounded,
              color: AppColors.secondayColor,
            ),
            selectedIcon: Icon(
              Icons.list_alt_outlined,
              color: AppColors.primaryColor,
            ),
            label: 'Request',
          ),
        ],
      ),
    );
  }
}
