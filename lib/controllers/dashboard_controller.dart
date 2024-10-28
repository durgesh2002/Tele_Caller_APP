import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_solutions/constants/api_urls.dart';
import 'package:smart_solutions/constants/static_stored_data.dart';
import 'package:smart_solutions/models/dashBoardToday_model.dart';
import 'package:smart_solutions/services/api_service.dart';

import '../constants/services.dart';

class DashboardController extends GetxController {
  final ApiService _apiService = ApiService();

  var isLoading = true.obs;

  var isDrawerOpen = false.obs;

  // Store today's and monthly data separately
  var todayData = DashboardTodayModel().obs;
  var monthlyData = DashboardMonthlyModel().obs;

  @override
  void onInit() {
    fetchDashboardData(true); // Fetch monthly data
    fetchDashboardData(false); // Fetch today’s data
    super.onInit();
  }

  Future<void> fetchDashboardData(bool isMonthly) async {
    try {
      isLoading(true);

      DateTime now = DateTime.now();
      DateTime startDate = DateTime(now.year, now.month, 1);

      String dateRange = isMonthly
          ? '${DateFormat('dd-MM-yyyy').format(startDate)},${DateFormat('dd-MM-yyyy').format(now)}'
          : '${DateFormat('dd-MM-yyyy').format(now)},${DateFormat('dd-MM-yyyy').format(now)}';

      final requestData = {
        'telecaller_id': StaticStoredData.userId,
        'daterange': dateRange,
      };

      final response =
          await _apiService.postRequest(APIUrls.todaysDashboard, requestData);

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);

        if (isMonthly) {
          monthlyData.value = DashboardMonthlyModel.fromJson(decodedResponse);
        } else {
          todayData.value = DashboardTodayModel.fromJson(decodedResponse);
        }
      } else {
        throw Exception('Server returned ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load dashboard data',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        duration: const Duration(seconds: 3),
      );
      logOutput('Error fetching dashboard data: $e');
    } finally {
      isLoading(false);
    }
  }

  void toggleDrawer() {
    isDrawerOpen.value = !isDrawerOpen.value;
  }
}
