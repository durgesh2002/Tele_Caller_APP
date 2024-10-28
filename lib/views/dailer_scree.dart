import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:smart_solutions/components/widgets/DailerScreenWidget/KeypadRowWidget.dart';
import 'package:smart_solutions/controllers/dailer_controller.dart';
import 'package:smart_solutions/controllers/follow_form.dart';

import 'package:smart_solutions/views/followBackForm.dart';

class DialerScreen extends StatefulWidget {
  const DialerScreen({Key? key}) : super(key: key);

  @override
  State<DialerScreen> createState() => _DialerScreenState();
}

class _DialerScreenState extends State<DialerScreen> {
  final DialerController dialerController = Get.put(DialerController());
  final FollowBackFormController _formController =
      Get.put(FollowBackFormController());

  int callsToBeHeld = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Dialer', style: TextStyle(fontSize: 20.sp)),
        actions: [
          IconButton(
              onPressed: () {
                Get.to(() => FollowBackForm(
                      mobileNumber: '',
                    ));
              },
              icon: const Icon(Icons.add_rounded))
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(height: 10.h),
          Obx(
            () => dialerController.isCallOngoing.value
                ? Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.grey.shade300),
                      child: Text(
                        dialerController.formatElapsedTime(
                            dialerController.elapsedTimeInSeconds.value),
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),

          Obx(() => Center(
                child: Text(
                  dialerController.customerName.value,
                  style: TextStyle(
                    fontSize: 20.sp,
                    color: AppColors.secondaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )),
          SizedBox(
            height: 5.h,
          ),
          Obx(() => Center(
                child: Text(
                  dialerController
                      .formatCurrency(dialerController.customerLoan.value),
                  style: TextStyle(
                    fontSize: 20.sp,
                    color: AppColors.secondaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )),
          Padding(
            padding: EdgeInsets.all(16.0.w),
            child: Obx(() {
              return Container(
                height: 50.h,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: AppColors.backgroundColor,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                      color: AppColors.primaryColor.withOpacity(0.2)),
                ),
                child: Center(
                  child: Text(
                    dialerController.phoneNumber.isEmpty
                        ?
                        // ? dialerController.dialNumber.isEmpty
                        //     ?
                        'Enter number'

                        // : dialerController.dialNumber.value
                        : dialerController.phoneNumber.value,
                    style: TextStyle(
                      fontSize: 20.sp,
                      color: AppColors.secondaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }),
          ),

          // Keypad
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                KeypadRowWidget(
                  numbers: const ['1', '2', '3'],
                  subTexts: const ['ABC', 'DEF'],
                  onDialButtonPressed: _addNumber,
                ),
                KeypadRowWidget(
                  numbers: const ['4', '5', '6'],
                  subTexts: const ['GHI', 'JKL', 'MNO'],
                  onDialButtonPressed: _addNumber,
                ),
                KeypadRowWidget(
                  numbers: const ['7', '8', '9'],
                  subTexts: const ['PQRS', 'TUV', 'WXYZ'],
                  onDialButtonPressed: _addNumber,
                ),
                KeypadRowWidget(
                  numbers: const ['*', '0', '#'],
                  subTexts: const [null, '+', null],
                  onDialButtonPressed: _addNumber,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          // Call and delete buttons
          Padding(
            padding: EdgeInsets.only(bottom: 20.h, left: 20.h, right: 20.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Obx(() => _buildIconButton(
                      Icons.call,
                      dialerController.phoneNumber.isNotEmpty &&
                              !dialerController.isCallOngoing.value
                          ? Colors.green
                          : Colors.grey,
                      dialerController.phoneNumber.isNotEmpty &&
                              !dialerController.isCallOngoing.value
                          ? () {
                              // if (dialerController.dialNumber.isEmpty) {
                              //   dialerController.fetchNextPhoneNumber();
                              // } else {
                              //   dialerController
                              //       .makePhoneCall(dialerController.dialNumber.value);
                              // }
                              dialerController.makePhoneCall(
                                  dialerController.phoneNumber.value);
                              _formController.mobile.value =
                                  dialerController.phoneNumber.value;
                            }
                          : null,
                    )),
                SizedBox(width: 10.sp),
                Obx(() => Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: dialerController.isCallOngoing.value
                              ? AppColors.ongoindCallColor
                              : AppColors.primaryColor,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        onPressed: dialerController.isLoading.value
                            ? null
                            : () async {
                                dialerController.isCallOngoing.value
                                    ? Get.defaultDialog(
                                        title: "End Call",
                                        titleStyle: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                                20), // Bold title for emphasis.
                                        middleText:
                                            "Want to end the call? End the call from the caller screen.", // Updated guiding message.
                                        middleTextStyle: const TextStyle(
                                            color: Colors.black,
                                            fontSize:
                                                16), // Clear and readable middle text.
                                        backgroundColor: Colors
                                            .white, // Dialog background in white.
                                        textConfirm:
                                            "OK", // Single button labeled 'OK'.
                                        confirmTextColor: Colors
                                            .white, // Confirm button text in white.
                                        buttonColor: Colors
                                            .blue, // 'OK' button in blue for neutrality.
                                        barrierDismissible:
                                            false, // Prevent accidental dismiss by tapping outside.
                                        onConfirm: () {
                                          Get.back(); // Simply close the dialog.
                                        },
                                      )
                                    : await dialerController
                                        .fetchNextPhoneNumber();
                              },
                        child: dialerController.isLoading.value
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                dialerController.isCallOngoing.value
                                    ? "End Call"
                                    : 'NEXT CALL',
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                      ),
                    )),
                SizedBox(
                  width: 10.sp,
                ),
                _buildIconButton(
                  Icons.backspace_outlined,
                  AppColors.primaryColor,
                  _removeNumber,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, Color color, VoidCallback? onPressed) {
    return Container(
      width: 56.w,
      height: 56.h,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        iconSize: 25.r,
        onPressed: onPressed,
      ),
    );
  }

  void _addNumber(String number) {
    setState(() {
      // dialerController.phoneNumber.value = '';
      dialerController.phoneNumber.value += number;
    });
  }

  void _removeNumber() {
    // if (dialerController.dialNumber.isNotEmpty) {
    //   setState(() {
    //     dialerController.dialNumber.value = dialerController.dialNumber.value
    //         .substring(0, dialerController.dialNumber.value.length - 1);
    //   });
    // } else
    dialerController.customerLoan.value = '';
    dialerController.customerName.value = '';
    if (dialerController.phoneNumber.isNotEmpty) {
      dialerController.phoneNumber.value = dialerController.phoneNumber.value
          .substring(0, dialerController.phoneNumber.value.length - 1);
    }
  }
}
