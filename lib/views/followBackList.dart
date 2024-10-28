import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_solutions/components/widgets/followBackListWidgets.dart';
import 'package:smart_solutions/constants/services.dart';
import 'package:smart_solutions/controllers/dailer_controller.dart';
import 'package:smart_solutions/controllers/follow_form.dart';
import 'package:smart_solutions/theme/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FollowBackListScreen extends StatelessWidget {
  final FollowBackFormController controller =
      Get.put(FollowBackFormController());
  final DialerController _dialerController = Get.put(DialerController());
  final TextEditingController _searchController = TextEditingController();
  final FollowBackFormController _formController = Get.put(FollowBackFormController());
  
  FollowBackListScreen({Key? key}) : super(key: key);

  Future<void> onRefresh() async {
    controller.fetchFollowBackList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Follow-up List'),
        backgroundColor: AppColors.appBarColor,
      ),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: Padding(
          padding: EdgeInsets.all(16.0.w),
          child: Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: AppColors.textColor2),
                  decoration: InputDecoration(
                    hintText: 'Search by name, mobile, or bank...',
                    hintStyle: const TextStyle(color: Colors.grey),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (value) {
                    controller.updateFilteredFollowBackList(value);
                  },
                ),
              ),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final displayedList =
                      controller.filteredFollowBackList.isEmpty
                          ? controller.followBackList
                          : controller.filteredFollowBackList;

                  if (displayedList.isEmpty) {
                    return const Center(
                        child: Text("No follow-up data available"));
                  }

                  return ListView.builder(
                    itemCount: displayedList.length,
                    itemBuilder: (context, index) {
                      final item = displayedList[index];

                      DateTime? entryDate;
                      if (item.entryDate != null &&
                          item.entryDate!.isNotEmpty) {
                        entryDate = DateTime.tryParse(item.entryDate!);
                      }

                      return Card(
                        elevation: 2,
                        margin: EdgeInsets.only(bottom: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16.0.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.person,
                                        color: AppColors.primaryColor,
                                        size: 20.sp,
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        item.customerName ?? '',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.sp,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12.w,
                                      vertical: 6.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: item.contactStatus == '1'
                                          ? AppColors.grid1.withOpacity(0.3)
                                          : AppColors.grid2.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                    child: Text(
                                      item.contactStatus == '1'
                                          ? 'CONTACTED'
                                          : 'NOT CONTACTED',
                                      style: TextStyle(
                                        color: item.contactStatus == '1'
                                            ? Colors.green.shade700
                                            : Colors.orange.shade700,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16.h),
                              GridView.count(
                                shrinkWrap: true,
                                crossAxisCount: 2,
                                childAspectRatio: 3,
                                physics: const NeverScrollableScrollPhysics(),
                                children: [
                                  Obx(() => GestureDetector(
                                        onTap:() {
                                                
                                                logOutput(_dialerController
                                                    .customerName.value);
                                                // _dialerController
                                                //     .elapsedTimeInSeconds
                                                //     .value = 0;
                                                // _dialerController
                                                //     .customerName.value = '';
                                                // _dialerController
                                                //     .customerLoan.value = '';

                                                logOutput(
                                                    "${_dialerController.isCallOngoing.value}");
                                                if (!_dialerController
                                                    .isCallOngoing.value) {
                                                  _dialerController
                                                      .makePhoneCall(
                                                          item.contactNumber ??
                                                              '');             
                                                }
                                               _formController.mobile
                                                        .value =
                                                    item.contactNumber ?? "";
                                                    _formController.bankName
                                                        .value =
                                                    item.bankName ?? "";
                                                _dialerController
                                                    .customerLoan.value = '';
                                                _dialerController
                                                        .customerName.value =
                                                    item.customerName ?? "";
                                                _dialerController
                                                    .datatype.value = '';
                                                _formController.remark.value = item.remark??'';
                                              _dialerController.followup_id.value = item.id??'';
                                              },
                                        child: FollowBackListWidget(
                                          icon: Icons.phone,
                                          text: _dialerController
                                                  .isCallOngoing.value
                                              ? "NA"
                                                  : 'Tap to call',
                                        ),
                                      )),
                                  FollowBackListWidget(
                                    icon: Icons.account_balance,
                                    text: item.bankName ?? '',
                                  ),
                                  FollowBackListWidget(
                                    icon: Icons.calendar_today,
                                    text: entryDate != null
                                        ? DateFormat('yyyy-MM-dd')
                                            .format(entryDate)
                                        : 'No Date',
                                  ),
                                
                                  FollowBackListWidget(
                                    icon: Icons.access_time,
                                    text: entryDate != null
                                        ? DateFormat('HH:mm').format(entryDate)
                                        : 'No Time',
                                  ),
                                     if(item.followupDate != null && item.remarkStatus =='2')
                                     FollowBackListWidget(
                                    icon: Icons.perm_contact_calendar,
                                    text:  DateFormat('yyyy-MM-dd')
                                            .format(DateTime.tryParse(item.followupDate!)!),
                                    color: Colors.red,
                                      
                                  ),
                                  if(item.followupDate != null && item.remarkStatus =='2')
                                  SizedBox.shrink(),
                                  FollowBackListWidget(
                                    icon: Icons.note,
                                    text: (item.remark ?? "NA").isEmpty
                                        ? "NA"
                                        : item.remark ?? "NA",
                                  ),
                                 
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
