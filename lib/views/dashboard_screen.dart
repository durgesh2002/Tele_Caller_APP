import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Import ScreenUtil
import 'package:get/get.dart';
import 'package:smart_solutions/components/dashboardgrid.dart';
import 'package:smart_solutions/constants/services.dart';
import 'package:smart_solutions/controllers/dashboard_controller.dart';
import 'package:smart_solutions/models/dashBoardToday_model.dart';
import 'package:smart_solutions/views/drawer.dart';

// Main Dashboard Screen
class DashboardScreen extends StatelessWidget {
  DashboardScreen({Key? key}) : super(key: key);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.put(DashboardController());

    return Scaffold(
      backgroundColor: Colors.grey[50],
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromRGBO(25, 118, 210, 1),
        title: const Text(
          "Dashboard",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
            onPressed: () {
              controller.toggleDrawer();
              if (controller.isDrawerOpen.value) {
                logOutput("opening drawer");
                _scaffoldKey.currentState!.openDrawer();
              } else {
                logOutput('closing drawer');
                Get.back();
              }
            },
            icon: const Icon(
              Icons.menu,
              color: Colors.white,
            )),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: IconButton(
              onPressed: () async {
                await controller
                    .fetchDashboardData(true); // Refresh monthly data
                await controller.fetchDashboardData(false);
              },
              icon: const Icon(Icons.refresh_rounded),
            ),
          ),
        ],
      ),
      drawerEnableOpenDragGesture: false,
      drawer: CustomDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.fetchDashboardData(true); // Refresh monthly data
          await controller.fetchDashboardData(false); // Refresh today's data
        },
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Today Section
                    DashboardSection(
                      title: "Today",
                      data: controller.todayData.value.data,
                    ),
                    const SizedBox(height: 34),
                    // Monthly Section
                    DashboardSection(
                      title: "Monthly",
                      data: controller.monthlyData.value.data,
                    ),
                  ],
                ),
              ),
            );
          }
        }),
      ),
    );
  }
}

class DashboardSection extends StatelessWidget {
  final String title;
  final Data? data;

  const DashboardSection({Key? key, required this.title, required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 12.h),
        GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 12.h,
          children: [
            DashboardCard(
              icon: Icons.person,
              title: "TOTAL ATTEMPT",
              count: (data?.totalAttempt ?? 0).toString(),
              backgroundColor: const Color(0xFFE3F2FD),
            ),
            DashboardCard(
              icon: Icons.headphones,
              title: "CONTACTED",
              count: (data?.totalContact ?? 0).toString(),
              backgroundColor: const Color(0xFFE1F5FE),
            ),
            DashboardCard(
              icon: Icons.mic_off,
              title: "NOT CONTACTED",
              count: (data?.totalNocontact ?? 0).toString(),
              backgroundColor: const Color(0xFFFFF8E1),
            ),
            DashboardCard(
              icon: Icons.calendar_month,
              title: "LEAD CONTACT",
              count: (data?.totalLead ?? 0).toString(),
              backgroundColor: const Color(0xFFFCE4EC),
            ),
          ],
        ),
      ],
    );
  }
}
