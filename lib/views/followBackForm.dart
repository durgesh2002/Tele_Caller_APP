import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:smart_solutions/controllers/dailer_controller.dart';
import 'package:smart_solutions/controllers/follow_form.dart';
import 'package:smart_solutions/controllers/remark_status_controller.dart';
import 'package:smart_solutions/utils/currency_util.dart';

import '../constants/services.dart';

// ignore: must_be_immutable
class FollowBackForm extends StatelessWidget {
  final String mobileNumber;
  FollowBackForm({Key? key, required this.mobileNumber}) : super(key: key);

  final FollowBackFormController _formController =
      Get.put(FollowBackFormController());
  final RemarkStatusController _remarkController =
      Get.put(RemarkStatusController());
  final _formKey = GlobalKey<FormState>();

  final DialerController _dialerController = Get.put(DialerController());
  int backPressCounter = 0;
  bool canPop = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPop,
      onPopInvoked: (didPop) {
        if (didPop) return;
        final NavigatorState navigator = Navigator.of(context);
        backPressCounter++;
        if (backPressCounter == 1) {
          Get.snackbar('Restricted', "Press back button once again to close",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.blue.shade100);
          canPop = true;
          Future.delayed(const Duration(seconds: 2), () {
            backPressCounter = 0; // Reset counter after 2 seconds

            canPop = false;
          });
        } else {
          // Get.back();
          _formController.mobile.value = '';
          _dialerController.elapsedTimeInSeconds.value = 0;
          _dialerController.customerName.value = '';
          _dialerController.customerLoan.value = '';
          _dialerController.followup_id.value ='';
          navigator.pop();
        }
        
        logOutput("$canPop and $backPressCounter");
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Follow Up Add'),
          backgroundColor: AppColors.primaryColor,
        ),
        body: Padding(
          padding: EdgeInsets.all(16.w),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                SizedBox(height: 20.h),
                _buildDatePicker(context, false),
                SizedBox(height: 16.h),
                _buildTextField(
                    isRead: _dialerController.customerLoan.value.isEmpty? false :true,
                    label: 'Loan amount',
                    value: CurrencyUtils.formatIndianCurrency(
                        _dialerController.customerLoan.value),
                    onChanged: (value) =>
                        _dialerController.customerLoan.value = value,
                    validator: null),
                SizedBox(height: 16.h),

                // Customer Name Field
                _buildTextField(
                  label: 'Customer Name',
                  value: _dialerController.customerName.value,
                  onChanged: (value) =>
                      _formController.customerName.value = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter customer name';
                    } else if (_dialerController
                        .customerName.value.isNotEmpty) {
                      _formController.customerName.value =
                          _dialerController.customerName.value;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),

                // Mobile Number Field
                _buildMobileField(
                  label: _formController.mobile.value,
                  inputType: TextInputType.phone,
                  onChanged: (value) {
                    if (_formController.mobile.value.isEmpty) {
                      _formController.mobile.value = value;
                    }
                    value = _formController.mobile.value;
                  },
                  validator: (value) {
                    if (_formController.mobile.value.isEmpty) {
                      return 'Please enter mobile number';
                    } else if (_formController.mobile.value.length < 3) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),

                // Bank Name Field
                _buildAllBankNamesDropdown(),
                SizedBox(height: 16.h),

                // Data Type Field
                _buildTextField(
                    label: 'Data Type',
                    value: _dialerController.datatype.value.isEmpty
                        ? ""
                        : _dialerController.datatype.value,
                    onChanged: (value) =>
                        _formController.dataType.value = value,
                    validator: null),
                SizedBox(height: 16.h),

                // Follow Up Date Picker

                // Contact Status Radio Buttons
                _buildContactStatusRadio(),
                SizedBox(height: 16.h),

                // Remark Status Dropdown
                _buildRemarkStatusDropdown(),
                SizedBox(height: 16.h),

                Obx(() => _remarkController.isCallback.value
                    ? _buildDatePicker(context, true)
                    : const SizedBox.shrink()),
                SizedBox(height: 16.h),

                // Remark Field
                _buildTextField(
                    label: 'Remark',
                    value: _formController.remark.value,
                    maxLines: 3,
                    onChanged: (value) => _formController.remark.value = value,
                    validator: null),
                SizedBox(height: 24.h),

                // Submit Button
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    String? value,
    bool? isRead,
    required ValueChanged<String> onChanged,
    required String? Function(String?)? validator,
    TextInputType inputType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextFormField(
      keyboardType: inputType,
      maxLines: maxLines,
      readOnly: isRead ?? false,
      initialValue: value ?? "",
      decoration: InputDecoration(
        labelText: label,
        hintText: label,
        labelStyle: const TextStyle(color: AppColors.secondaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0.r),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0.r),
          borderSide: const BorderSide(color: AppColors.primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0.r),
          borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
        ),
        filled: true,
        fillColor: AppColors.backgroundColor,
      ),
      style: const TextStyle(color: AppColors.primaryColor),
      onChanged: onChanged,
      validator: validator,
    );
  }

  Widget _buildMobileField({
    required String label,
    required ValueChanged<String> onChanged,
    required String? Function(String?)? validator,
    TextInputType inputType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextFormField(
      keyboardType: inputType,
      maxLines: maxLines,
      maxLength: 10,
      readOnly: _formController.mobile.isEmpty ? false : true,
      decoration: InputDecoration(
        // labelText: _formController.mobile.isEmpty ? "Enter mobile" : '',
        hintText: _formController.mobile.isEmpty ? "Enter mobile" : label,
        labelStyle: const TextStyle(color: AppColors.secondaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0.r),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0.r),
          borderSide: const BorderSide(color: AppColors.primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0.r),
          borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
        ),
        filled: true,
        fillColor: AppColors.backgroundColor,
      ),
      style: const TextStyle(color: AppColors.primaryColor),
      onChanged: onChanged,
      validator: validator,
    );
  }

  Widget _buildDatePicker(BuildContext context, bool chooseDate) {
    // This controller will store the selected date
    final selectedDate = DateTime.now().obs;
    selectedDate.value = _formController.followupDate.value;

    return InkWell(
      onTap: () async {
        if (chooseDate) {
          final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(), // Prevent selecting past dates
            lastDate: DateTime(2100), // Set a far future date limit
          );

          if (picked != null) {
            selectedDate.value = picked; // Update selected date
            _formController.followupDate.value = picked;
          }
        }
      },
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primaryColor),
          borderRadius: BorderRadius.circular(20.0.r),
          color: AppColors.backgroundColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            chooseDate
                ? Text(
                    '${'Follow Up Date'}: ${DateFormat('dd-MM-yyyy').format(selectedDate.value)}',
                    style: const TextStyle(color: AppColors.primaryColor),
                  )
                : Text(
                    '${'Date'}: ${DateFormat('dd-MM-yyyy').format(DateTime.now())}',
                    style: const TextStyle(color: AppColors.primaryColor),
                  ),
            const Icon(Icons.calendar_today, color: AppColors.primaryColor),
          ],
        ),
      ),
    );
  }

  Widget _buildContactStatusRadio() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contacted Status',
          style: TextStyle(
            color: AppColors.secondaryColor,
            fontSize: 16.sp,
          ),
        ),
        Obx(() => Row(
              children: [
                Radio<String>(
                  value: 'Yes',
                  groupValue: _formController.contacted.value,
                  onChanged: (value) {
                    _formController.contacted.value = value!;
                    _remarkController.fetchRemarkStatus('1');
                  },
                  activeColor: AppColors.primaryColor,
                ),
                const Text(
                  'Yes',
                  style: TextStyle(
                    color: AppColors.secondaryColor,
                  ),
                ),
                SizedBox(width: 20.w),
                Radio<String>(
                  value: 'No',
                  groupValue: _formController.contacted.value,
                  onChanged: (value) {
                    _formController.contacted.value = value!;
                    _remarkController.fetchRemarkStatus('2');
                  },
                  activeColor: AppColors.primaryColor,
                ),
                const Text(
                  'No',
                  style: TextStyle(
                    color: AppColors.secondaryColor,
                  ),
                ),
              ],
            )),
      ],
    );
  }

  Widget _buildRemarkStatusDropdown() {
    return Obx(
      () => _remarkController.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Remark Status',
                labelStyle: const TextStyle(color: AppColors.secondaryColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0.r),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0.r),
                  borderSide: const BorderSide(color: AppColors.primaryColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0.r),
                  borderSide:
                      const BorderSide(color: AppColors.primaryColor, width: 2),
                ),
                filled: true,
                fillColor: AppColors.backgroundColor,
              ),
              value: null,
              items: _remarkController.remarkStatusList.map((status) {
                // _formController.remarkStatus.value =
                //     _remarkController.remarkStatusList.first.id ?? "";
                return DropdownMenuItem<String>(
                  value: status.id, // Use the ID as the value
                  child: Text(status.title ?? 'Select remark status'),
                );
              }).toList(),
              onChanged: (newValue) {
                _formController.remarkStatus.value = newValue ?? '';

                logOutput("Selected ID: ${_formController.remarkStatus.value}");

                // Find the selected status using the ID
                var selectedStatus = _remarkController.remarkStatusList
                    .firstWhereOrNull((status) => status.id == newValue);
                logOutput('selected status ${selectedStatus?.title}');

                // Check if the selected status title is 'CallBack'
                if (selectedStatus?.title == 'Callback') {
                  logOutput("Setting isCallback to true");
                  _remarkController.isCallback.value = true;
                } else {
                  logOutput("Setting isCallback to false");
                  _remarkController.isCallback.value = false;
                }
              },
              validator: (value) {
                if (_formController.remarkStatus.value.isEmpty) {
                  return 'Please select a remark status';
                }
                return null;
              },
            ),
    );
  }

  Widget _buildAllBankNamesDropdown() {
  return Obx(
    () => _formController.isLoading.value
        ? const Center(child: CircularProgressIndicator())
        : DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Select bank',
              labelStyle: const TextStyle(color: AppColors.secondaryColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0.r),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0.r),
                borderSide: const BorderSide(color: AppColors.primaryColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0.r),
                borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
              ),
              filled: true,
              fillColor: AppColors.backgroundColor,
            ),
            value: _getInitialBankValue(), // Use the method to get the initial value
            items: _formController.allBankNamesList.map((bank) {
              return DropdownMenuItem<String>(
                value: bank.bankName,
                child: Text(bank.bankName ?? 'Select bank'),
              );
            }).toList(),
            onChanged: (newValue) {
              logOutput("bank is $newValue");
              _formController.bankName.value = newValue ?? 'Select bank';
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a bank';
              }
              return null;
            },
          ),
  );
}

String? _getInitialBankValue() {
  // Check if the controller's bankName is in the available bank list
  if (_formController.bankName.value == 'Select bank') {
    return null; // Keep it null to show the placeholder
  }
  final existingBank = _formController.allBankNamesList
      .firstWhereOrNull((bank) => bank.bankName == _formController.bankName.value);
  return existingBank?.bankName; // If found, return it; otherwise, return null
}

  Widget _buildSubmitButton() {
    return Obx(() => ElevatedButton(
          onPressed: _formController.isLoading.value
              ? null
              : () {
                  if (_formKey.currentState!.validate()) {
                    _formController.submitFollowUp();
                  }
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            padding: EdgeInsets.symmetric(vertical: 15.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0.r),
            ),
          ),
          child: _formController.isLoading.value
              ? const CircularProgressIndicator(color: Colors.white)
              : Text(
                  'Submit',
                  style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
        ));
  }
}

// Constants class for colors
class AppColors {
  static const Color primaryColor = Color(0xFF2196F3);
  static const Color secondaryColor = Color(0xFF757575);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color ongoindCallColor = Color.fromARGB(255, 245, 43, 43);
}
