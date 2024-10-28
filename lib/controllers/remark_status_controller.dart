import 'dart:convert';

import 'package:get/get.dart';
import 'package:smart_solutions/models/remark_status_model.dart';
import '../constants/services.dart';
import '../services/api_service.dart';
import '../constants/api_urls.dart';

class RemarkStatusController extends GetxController {
  final ApiService _apiService = ApiService();
  var remarkStatusList = <Data>[].obs;
  var isLoading = false.obs;
  var isCallback = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRemarkStatus('2');
  }

  Future<void> fetchRemarkStatus(String status) async {
    try {
      isLoading(true);
      final response = await _apiService.postRequest(
        APIUrls.remarkStatusCode,
        {'status': status},
      );

      if (response.statusCode == 200) {
        final remarkStatus = RemarkStatus.fromJson(json.decode(response.body));
        if (remarkStatus.data != null) {
          remarkStatusList.assignAll(remarkStatus.data!);
        }
      }
    } catch (e) {
      logOutput('Error fetching remark status: $e');
      Get.snackbar('Error', 'Failed to load remark status options');
    } finally {
      isLoading(false);
    }
  }
}
