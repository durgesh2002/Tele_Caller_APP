import 'dart:convert';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_solutions/constants/static_stored_data.dart';
import 'package:smart_solutions/models/data_entery_model.dart';
import 'package:smart_solutions/services/api_service.dart';

import 'package:smart_solutions/constants/api_urls.dart';

import '../constants/services.dart';

class DataController extends GetxController {
  final ApiService _apiService = ApiService();

  var isLoading = false.obs;
  var dataList = <Data>[].obs;
  var errorMessage = ''.obs;

  // Default telecaller ID
  final String defaultTelecallerId = StaticStoredData.userId;
  //  "${StaticStoredData.userId}";

  @override
  void onInit() {
    super.onInit();
    fetchDataEntryList();
  }

  Future<void> fetchDataEntryList() async {
    try {
      isLoading(true);
      DateTime now = DateTime.now();
      DateTime startDate = DateTime(now.year, now.month, 1);
      String dateRange =
          '${DateFormat('dd-MM-yyyy').format(startDate)},${DateFormat('dd-MM-yyyy').format(now)}';
      logOutput('date range is $dateRange and $defaultTelecallerId');

      // Create form data with required telecaller_id
      final Map<String, dynamic> formData = {
        'telecaller_id': defaultTelecallerId,
        'daterange': dateRange,
      };

      // Using POST request instead of GET since it requires form-data
      final response = await _apiService.postRequest(
        APIUrls.dataEntryFeild,
        formData,
      );
      logOutput("${response.statusCode}");
      logOutput(response.body);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final dataEntryModel = DataEntryModel.fromJson(responseData);
        if (dataEntryModel.data != null) {
          dataList.assignAll(dataEntryModel.data!);
        }
      } else if (response.statusCode == 204) {
        Get.snackbar(
          'Opps',
          'No Data Available',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        throw Exception('Failed to load data entries');
      }
    } catch (e) {
      errorMessage.value = 'Error fetching data: ${e.toString()}';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }

  // Refresh data
  Future<void> refreshData() async {
    dataList.clear();
    await fetchDataEntryList();
  }

  // Search functionality
  void searchData(String query) {
    if (query.isEmpty) {
      fetchDataEntryList();
      return;
    }

    final filteredList = dataList
        .where((data) =>
            (data.customerName?.toLowerCase().contains(query.toLowerCase()) ??
                false) ||
            (data.mobileNo?.contains(query) ?? false) ||
            (data.bankName?.toLowerCase().contains(query.toLowerCase()) ??
                false))
        .toList();

    dataList.assignAll(filteredList);
  }
}
