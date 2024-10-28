import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_solutions/constants/static_stored_data.dart';
import 'package:smart_solutions/controllers/login_request_controller.dart';

import '../constants/services.dart';

class AppColors {
  static const Color primaryColor = Colors.blue;
  static const Color secondaryColor = Colors.grey;
  static const Color backgroundColor = Colors.white;
}

class LoginRequestForm extends StatelessWidget {
  final LoginRequestController controller = Get.put(LoginRequestController());

  final _formKey = GlobalKey<FormState>(); // Form key for validation

  LoginRequestForm({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        if (didPop) {
          controller.remarksList.clear();
          controller.isEdit.value = false;
          controller.isNew.value = false;
          controller.currentId.value = '';

          controller.loginRequestDate = DateTime.now().obs;
          controller.telecallerId = StaticStoredData.userId.obs;
          controller.customerName.value = '';
          controller.contactNumber.value = '';
          controller.loanStatus.value = '1'; // Default loan status
          controller.bankId.value = '';
          controller.loanAmount.value = '';
          controller.commonRemark.value = '';
          controller.remarksList.value = []; // To hold multiple remarks
          controller.id = ''.obs;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login Request Form'),
          actions: [
            Obx(() => controller.isNew.value
                ? SizedBox.shrink()
                : IconButton(
                    onPressed: () {
                      controller.isEdit.value = !controller.isEdit.value;
                    },
                    icon: Icon(
                      Icons.edit,
                      color:
                          controller.isEdit.value ? Colors.red : Colors.white,
                    )))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.h),
                  _buildTextField(
                    label: 'Customer Name',
                    content: controller.customerName.value,
                    onChanged: (value) => controller.customerName.value = value,
                    validator: _validateNotEmpty,
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                    label: 'Contact Number',
                    content: controller.contactNumber.value,
                    onChanged: (value) =>
                        controller.contactNumber.value = value,
                    inputType: TextInputType.phone,
                    validator: _validatePhone,
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                    label: 'Loan Amount',
                    content: controller.loanAmount.value.isNotEmpty
                        ? NumberFormat.currency(
                                locale: 'en_IN', symbol: '', decimalDigits: 0)
                            .format(
                                int.tryParse(controller.loanAmount.value) ?? 0)
                        : '',
                    onChanged: (value) {
                      // Remove commas to get the numeric value before formatting
                      String plainTextValue = value.replaceAll(',', '');
                      controller.loanAmount.value = plainTextValue;

                      // Format the numeric value back to the Indian format
                      String formattedValue = NumberFormat.currency(
                              locale: 'en_IN', symbol: '', decimalDigits: 0)
                          .format(int.tryParse(plainTextValue) ?? 0);

                      controller.loanAmount.value = formattedValue;
                    },
                    inputType: TextInputType.number,
                    validator: _validateNumber,
                  ),

                  const SizedBox(height: 10),

                  // _buildLoanStatusDropdown(),
                  // const SizedBox(height: 10),
                  _buildAllBankNamesDropdown(),
                  const SizedBox(height: 10),

                  _buildTextField(
                    label: 'Common remark',
                    content: controller.commonRemark.value,
                    onChanged: (value) => controller.commonRemark.value = value,
                    // validator: _validateNotEmpty,
                  ),
                  const SizedBox(height: 10),
                  // Dynamic Remarks Section
                  _buildRemarksSection(),
                  const SizedBox(height: 20),

                  Center(
                    child: Obx(() => ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              controller.saveLoginRequest(); // Call save method
                              controller.getLoginRequestList();
                            }
                          },
                          child: controller.isLoading.value
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 24.0),
                                  child: Text(
                                    'Save Request',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String content,
    required String label,
    required ValueChanged<String> onChanged,
    TextInputType inputType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Obx(() => Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            keyboardType: inputType,
            maxLines: maxLines,
            readOnly: !controller.isEdit.value,
            initialValue: content.isNotEmpty ? content : null,
            decoration: InputDecoration(
              labelText: label,
              labelStyle: const TextStyle(color: AppColors.secondaryColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(color: AppColors.primaryColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide:
                    const BorderSide(color: AppColors.primaryColor, width: 2),
              ),
              filled: true,
              fillColor: AppColors.backgroundColor,
            ),
            style: const TextStyle(color: AppColors.primaryColor),
            onChanged: onChanged,
            validator: validator,
          ),
        ));
  }

  // Dynamic Remarks Section
  Widget _buildRemarksSection() {
    return Obx(() {
      // List to hold dynamic remark TextField widgets
      List<Widget> remarkFields = [];

      for (int i = 0; i < controller.remarksList.length; i++) {
        remarkFields.add(
          _buildTextField(
            content: controller.remarksList[i],
            maxLines: 3,
            label: 'Remark ${i + 1}',
            onChanged: (value) {
              // Update remarksList with the new value
              controller.remarksList[i] = value.trim();
            },
            validator: _validateNotEmpty,
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...remarkFields,
          // Add button to create a new remark field
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.add, color: AppColors.primaryColor),
                onPressed: () {
                  // Add a new empty remark to the list
                  controller.remarksList.add('');
                },
              ),
              const Text(
                'Add remark',
                style: TextStyle(color: Colors.black),
              )
            ],
          ),
        ],
      );
    });
  }

  // Validation Functions
  String? _validateNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field cannot be empty';
    }
    return null;
  }

  String? _validateNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field cannot be empty';
    }
    if (double.tryParse(value) == null) {
      return 'Please enter a valid number';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field cannot be empty';
    }
    if (value.length < 10) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  Widget _buildAllBankNamesDropdown() {
    return Obx(
      () => controller.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
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
                    borderSide: const BorderSide(
                      color: AppColors.primaryColor,
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: AppColors.backgroundColor,
                ),
                value: _getInitialBankValue(),
                hint: const Text(
                  'Select bank',
                  style: TextStyle(color: Colors.grey),
                ),
                isExpanded: true, // Ensures the dropdown takes full width
                items: _buildBankDropdownItems(),
                onChanged: !controller.isEdit.value
                    ? null
                    : (newValue) {
                        logOutput("new value is $newValue");
                        if (newValue != null) {
                          controller.bankId.value = newValue;
                        }
                      },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a bank';
                  }
                  return null;
                },
              ),
            ),
    );
  }

// Helper method to get the initial bank value
  String? _getInitialBankValue() {
    // Check if the controller's bankId is in the available bank list
    final existingBank = controller.allBankNamesList
        .firstWhereOrNull((bank) => bank.bankName == controller.bankId.value);
    return existingBank?.id; // If found, return it; otherwise, return null
  }

// Helper method to build dropdown items
  List<DropdownMenuItem<String>> _buildBankDropdownItems() {
    return controller.allBankNamesList.map((bank) {
      return DropdownMenuItem<String>(
        value: bank.id,
        child: Text(
          bank.bankName ?? '',
          overflow: TextOverflow.ellipsis,
        ),
      );
    }).toList();
  }
}
