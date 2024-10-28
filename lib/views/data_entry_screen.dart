import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_solutions/controllers/data_entry_controller.dart';
import 'package:smart_solutions/theme/app_theme.dart';
import 'package:smart_solutions/utils/currency_util.dart';

class DataEntryViewScreen extends StatelessWidget {
  DataEntryViewScreen({super.key});
  final DataController dataController = Get.put(DataController());

  String formatDate(String? dateStr) {
    if (dateStr == null) return 'N/A';
    try {
      final DateTime date = DateTime.parse(dateStr);
      return DateFormat('dd-MM-yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Entry'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => dataController.refreshData(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
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
              onChanged: (value) => dataController.searchData(value),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (dataController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              } else if (dataController.dataList.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.no_sim, size: 50, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No data entries available',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              } else {
                return RefreshIndicator(
                  onRefresh: () => dataController.refreshData(),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: dataController.dataList.length,
                    itemBuilder: (context, index) {
                      var data = dataController.dataList[index];
                      return Card(
                        color: const Color.fromARGB(255, 227, 237, 248),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 6.0,
                        ),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      data.customerName ?? 'N/A',
                                      style: const TextStyle(
                                        color: AppColors.textColor2,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 4.0),
                                    decoration: BoxDecoration(
                                      color: AppColors.grid2,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      formatDate(data.date),
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: AppColors.appBarColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              _buildDetailItem(
                                'Mobile',
                                data.mobileNo ?? 'N/A',
                              ),
                              _buildDivider(),
                              _buildDetailItem(
                                'Loan',
                                CurrencyUtils.formatIndianCurrency(
                                    data.loanAmount),
                              ),
                              _buildDivider(),
                              _buildDetailItem(
                                'Bank',
                                data.loginBank ?? 'N/A',
                                textColor: AppColors.secondayColor,
                              ),
                              _buildDivider(),
                              _buildStatusItem(
                                'Comments',
                                (data.comments ?? 'NA').toString(),
                              ),
                              _buildDivider(),
                              _buildStatusItem(
                                'Status',
                                data.status ?? 'N/A',
                                textColor:
                                    data.status?.toLowerCase() == 'active'
                                        ? Colors.green
                                        : Colors.redAccent.shade100,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, {Color? textColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          ':', // Add colon here
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(width: 4),
        Expanded(
          flex: 4,
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              color: textColor ?? const Color.fromARGB(255, 43, 42, 42),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusItem(String label, String value,
      {Color? textColor, int? maxLines}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          ':', // Add colon here
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(width: 4),
        Expanded(
          flex: 4,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: textColor ?? const Color.fromARGB(255, 43, 42, 42),
            ),
            softWrap: true,
            overflow:
                maxLines != null ? TextOverflow.ellipsis : TextOverflow.visible,
            maxLines: maxLines,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return const Divider(
      color: Colors.grey,
      height: 20,
      thickness: 1,
    );
  }

  void showDetailsDialogue(String content) {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                content,
                style: const TextStyle(color: Colors.black),
              ),
            ],
          ),
        );
      },
    );
  }
}
