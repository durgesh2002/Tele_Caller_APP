import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_solutions/constants/api_urls.dart';
import 'package:smart_solutions/constants/static_stored_data.dart';
import 'package:smart_solutions/models/loan_status_model.dart';
import 'package:smart_solutions/models/login_request_bank_list_model';
import 'package:smart_solutions/models/login_request_list_model.dart'; // Ensure this model is defined
import 'package:smart_solutions/models/remark_list.dart';
import 'package:smart_solutions/services/api_service.dart';

import '../constants/services.dart';

class LoginRequestController extends GetxController {
  var loginRequestList =
      <LoginRequest>[].obs; // Observable list for reactive UI
  var loanStatusList = <LoanStatus>[].obs;
  List<RemarkList> remarks = []; // Observable list for reactive UI
  var isLoading = false.obs;
  var currentId = ''.obs;
  var isEdit = false.obs;
  var isNew = false.obs;

  var loginRequestDate = DateTime.now().obs;
  var telecallerId = StaticStoredData.userId.obs;
  var customerName = ''.obs;
  var contactNumber = ''.obs;
  var loanStatus = '1'.obs; // Default loan status
  var bankId = ''.obs;
  var loanAmount = ''.obs;
  var commonRemark = ''.obs;
  var remarksList = <String>[].obs; // To hold multiple remarks
  var id = ''.obs; // For existing records

  var allBankNamesList = <LoginRequestBankList>[].obs;

  @override
  void onInit() {
    super.onInit();
    getLoginRequestList();
    fetchLoanStatuses(); // Fetch data on initialization
    getLoginRequestBanks();
  }

  // Fetch the login request list
  Future<void> getLoginRequestList() async {
    try {
      isLoading(true);
      var body = {
        'telecaller_id': StaticStoredData.userId
      }; // Replace with actual data if required

      final response =
          await ApiService().postRequest(APIUrls.loginRequestList, body);

      if (response.statusCode == 200) {
        var resData = jsonDecode(response.body);
        if (resData['data'] != null && resData['data'] is List) {
          var loginData = (resData['data'] as List)
              .map((json) => LoginRequest.fromJson(json))
              .toList();

          loginRequestList.value = loginData; // Update observable list
          isLoading(false);
        } else {
          logOutput("No data found");
          isLoading(false);
        }
      } else if (response.statusCode == 204) {
        loginRequestList.clear();
      } else {
        isLoading(false);
        logOutput("Error: ${response.statusCode}");
      }
      isLoading(false);
    } catch (e) {
      isLoading(false);
      logOutput("An error occurred while fetching the login request list: $e");
    }
  }

  // Fetch loan statuses
  Future<void> fetchLoanStatuses() async {
    try {
      isLoading.value = true; // Start loading
      final response = await ApiService().getRequest(APIUrls.getLoanStatus);

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        logOutput('Response data: $responseData'); // Log response

        // Update loanStatusList with parsed data
        loanStatusList.value = (responseData['data'] as List)
            .map((item) => LoanStatus.fromJson(item))
            .toList();
      } else {
        logOutput(
            "Failed to fetch loan status. Status code: ${response.statusCode}");
      }
    } catch (e) {
      logOutput("An error occurred while fetching loan statuses: $e");
    } finally {
      isLoading.value = false; // Stop loading
    }
  }

  Future<void> getRemarks() async {
    var body = {'login_request_id': currentId.value};
    var response = await ApiService().postRequest(APIUrls.getRemarkList, body);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body); // Decode JSON

      // Check if 'data' is present in the response
      if (data['data'] != null) {
        // Map each JSON object to RemarkList and store in the list
        remarks = (data['data'] as List)
            .map((remarkJson) => RemarkList.fromJson(remarkJson))
            .toList();
        remarksList.value = remarks.map((remark) => remark.remark).toList();
      }
    }
  }

  // Save login request
  Future<void> saveLoginRequest() async {
    isLoading(true);
    try {
      // Prepare the fields map
      var fields = {
        'login_request_date': DateFormat('dd-MM-yyyy HH:mm')
            .format(DateTime.parse(loginRequestDate.value.toString())),
        'telecaller_id': telecallerId.value.toString(),
        'customer_name': customerName.value.toString(),
        'contact_number': contactNumber.value.toString(),
        'loan_status': "NA",
        'bank_id': bankId.value.toString(),
        'loan_amount': loanAmount.value.replaceAll(",", ""),
        'common_remark': commonRemark.value.toString(),
        'id': currentId.value.toString(),
      };

      // Add each remark separately to the fields map
      if (remarksList.isNotEmpty) {
        for (int i = 0; i < remarksList.length; i++) {
          fields['remarks[$i]'] = remarksList[i];
        }
      }

      // logOutput fields to verify the data
      logOutput('Request fields: $fields');

      // Make the API request
      final response = await ApiService().multipartPostRequest(
        APIUrls.loginRequestSave,
        fields,
        null, // No file handling needed
        null, // Empty field name for file (not used)
      );

      // Handle the response
      if (response.statusCode == 200) {
        getLoginRequestList();
        currentId.value = '';

        loginRequestDate = DateTime.now().obs;
        telecallerId = StaticStoredData.userId.obs;
        customerName.value = '';
        contactNumber.value = '';
        loanStatus.value = '1'; // Default loan status
        bankId.value = '';
        loanAmount.value = '';
        commonRemark.value = '';
        remarksList.value = []; // To hold multiple remarks
        id = ''.obs;
        Get.back();
        Get.snackbar('Success', 'Login request saved successfully!');
      } else {
        Get.snackbar('Error', 'Failed to save login request.');
      }
    } catch (e) {
      logOutput("An error occurred while saving the login request: $e");
    } finally {
      isLoading(false); // Stop loading
    }
  }

  Future<void> getLoginRequestBanks() async {
    try {
      isLoading(true);
      var body = {"": ""}; // You can define your request body as needed
      var response = await ApiService()
          .postRequest(APIUrls.allLoginRequestBankNames, body);

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body)['data'];
        final List<LoginRequestBankList> bankList = parseBankList(responseData);
        if (bankList.isNotEmpty) {
          allBankNamesList.assignAll(bankList);
        }
      }
      isLoading(false);
    } catch (e) {
      log('An error occurred while fetching banks: $e');
      isLoading(false); // Ensure loading is set to false on error as well
    }
  }
}
