import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:smart_solutions/constants/static_stored_data.dart';
import 'package:smart_solutions/controllers/dashboard_controller.dart';
import 'package:smart_solutions/models/FollowUpSubmittedList.dart';
import 'package:smart_solutions/models/all_bank_names_model.dart';
import 'package:smart_solutions/models/followUpDetails.dart';

import '../constants/services.dart';
import '../services/api_service.dart';
import '../constants/api_urls.dart';
import 'dailer_controller.dart';

class FollowBackFormController extends GetxController {
  final ApiService _apiService = ApiService();
  final DialerController _dialerController = Get.put(DialerController());
  final DashboardController _dashboardController =
      Get.put(DashboardController());
  var allBankNamesList = <AllBankNamesData>[].obs;
  var followBackList = <Data>[].obs;
  var filteredFollowBackList = <Data>[].obs;

  @override
  void onInit() {
    getAllBanks();
    fetchFollowBackList();
    super.onInit();
  }

  // Form fields
  var customerName = ''.obs;
  var mobile = ''.obs;
  var bankName = ''.obs;
  var dataType = ''.obs;
  var contacted = 'No'.obs;
  var remarkStatus = ''.obs;
  var remark = ''.obs;
  var telecallerId =
      StaticStoredData.userId.obs; // Default value as shown in API
  var followupDate = DateTime.now().obs;
  var isLoading = false.obs;

  // Convert contacted status to API format
  String get contactStatus => contacted.value == 'Yes' ? '1' : '2';

  void fetchFollowBackList() async {
    isLoading.value = true;

    try {
      var response = await _apiService.postRequest(
        APIUrls.followUpSubmitedData,
        {
          "telecaller_id": StaticStoredData.userId,
        },
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        var followBackData = FollowUpSubmitedList.fromJson(responseData);
        followBackList.value = followBackData.data ?? [];
      } else if (response.statusCode == 204) {
        followBackList.clear();
      } else {
        logOutput("Error: ${response.statusCode} - ${response.reasonPhrase}");
      }
    } catch (e) {
      logOutput("Exception fetching follow-back list: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitFollowUp() async {
    try {
      isLoading(true);

      final Map<String, dynamic> formData = {
        'mobile': mobile.value,
        'name': customerName.value,
        'data_type': dataType.value,
        'bank_name':
            bankName.value.isEmpty ? allBankNamesList.first.id : bankName.value,
        'followup_date':
            '${followupDate.value.year}-${followupDate.value.month}-${followupDate.value.day}',
        'contact_status': contactStatus,
        'remark_status': remarkStatus.value,
        'remark': remark.value,
        'telecaller_id': telecallerId.value,
        'call_duration': _dialerController
            .formatElapsedTime(_dialerController.callDuration.value),
        'excel_id':_dialerController.excel_id.value,
        'followup_id': _dialerController.followup_id.value,
      };
      logOutput("$formData");
      final response = await _apiService.postRequest(
        APIUrls.followListData,
        formData,
      );

      _dialerController.elapsedTimeInSeconds.value = 0;
      logOutput(response.body);
      if (response.statusCode == 200) {
        final result = FollowUpDetails.fromJson(json.decode(response.body));
        Get.back();
        Get.snackbar(
            'Success', result.message ?? 'Follow up saved successfully');
        _dialerController.handleFormSubmitAndFetchNext();
        fetchFollowBackList();
        await _dashboardController
            .fetchDashboardData(true); // Fetch monthly data
        await _dashboardController.fetchDashboardData(false);

        clearForm();
      } else {
        throw Exception('Failed to submit form');
      }
    } catch (e) {
      logOutput('Error submitting form: $e');
      Get.snackbar('Error', 'Failed to submit follow up form');
    } finally {
      isLoading(false);
    }
  }

  void updateFilteredFollowBackList(String query) {
    if (query.isEmpty) {
      filteredFollowBackList.assignAll(followBackList);
    } else {
      filteredFollowBackList.assignAll(
        followBackList.where((item) {
          final name = item.customerName?.toLowerCase() ?? '';
          final mobile = item.contactNumber?.toLowerCase() ?? '';
          final bank = item.bankName?.toLowerCase() ?? '';
          final searchQuery = query.toLowerCase();
          return name.contains(searchQuery) ||
              mobile.contains(searchQuery) ||
              bank.contains(searchQuery);
        }).toList(),
      );
    }
  }

  Future<void> getAllBanks() async {
    try {
      isLoading(true);
      var body = {'': ''};
      var response = await ApiService().postRequest(APIUrls.allBankNames, body);

      if (response.statusCode == 200) {
        final remarkStatus = AllBankNames.fromJson(json.decode(response.body));
        if (remarkStatus.data != null) {
          allBankNamesList.assignAll(remarkStatus.data!);
        }
      }
      isLoading(false);
    } catch (e) {
      log('an error occured while fetching banks $e');
    }
  }

  void clearForm() {
    customerName.value = '';
    mobile.value = '';
    bankName.value = '';
    dataType.value = '';
    _dialerController.datatype.value = '';
    contacted.value = 'No';
    remarkStatus.value = '';
    remark.value = '';
    followupDate.value = DateTime.now();
    _dialerController.callDuration.value = 0;
    // _dialerController.excel_id.value = '';
    _dialerController.followup_id.value = '';
  }
}
