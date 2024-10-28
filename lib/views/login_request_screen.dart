import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_solutions/controllers/login_request_controller.dart';
import 'package:smart_solutions/views/login_request_form.dart';
import '../constants/services.dart';

class LoginRequestScreen extends StatelessWidget {
  LoginRequestScreen({super.key});
  final LoginRequestController controller = Get.put(LoginRequestController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            controller.isEdit.value = true;
            controller.isNew.value = true;
            Get.to(() => LoginRequestForm());
          }),
      appBar: AppBar(
        title: const Text(
          'Login Requests',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.getLoginRequestList(),
        child: Obx(() {
          if (controller.loginRequestList.isEmpty) {
            return const Center(
              child: Text(
                'No Data',
                style: TextStyle(color: Colors.black),
              ),
            );
          }

          return Obx(() => controller.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  padding:
                      const EdgeInsets.all(16.0), // Add padding to the list
                  itemCount: controller.loginRequestList.length,
                  itemBuilder: (context, index) {
                    final request = controller.loginRequestList[index];
                    return Card(
                      elevation:
                          4, // Add elevation to the card for shadow effect
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10), // Rounded corners
                      ),
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0), // Space between cards
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(
                            16.0), // Padding inside the tile
                        title: Text(
                          request.customerName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                                height: 4), // Space between title and subtitle
                            Text(
                              'Login Date: ${request.loginRequestDate.toLocal().toString().split(' ')[0]}',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 4), // Space between lines
                            Text(
                              'Contact: ${request.contactNumber}',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 4), // Space between lines
                            Text(
                              'Loan Status: ${request.title}',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 4), // Space between lines
                            Text(
                              'Loan Amount: ${request.loanAmount}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey[700],
                        ),
                        onTap: () async {
                          // Handle the tap event here
                          controller.currentId.value = request.id;
                          controller.customerName.value = request.customerName;
                          controller.contactNumber.value =
                              request.contactNumber;
                          controller.loanAmount.value =
                              request.loanAmount.replaceAll(',', '');
                          logOutput(
                              'loan amount is ${controller.loanAmount.value}');
                          controller.loanStatus.value =
                              ((request.loanStatus == null ||
                                      request.loanStatus!.isEmpty)
                                  ? "NA"
                                  : request.loanStatus)!;

                          controller.bankId.value = request.bankName ?? "";
                          controller.commonRemark.value = request.commonRemark;

                          logOutput('bank name is ${request.bankName}');

                          controller.getRemarks();
                          var result = await Get.to(() => LoginRequestForm());

                          if (result == true) {
                            controller.getLoginRequestList();
                          } else {
                            controller.getLoginRequestList();
                          }
                        },
                      ),
                    );
                  },
                ));
        }),
      ),
    );
  }
}
