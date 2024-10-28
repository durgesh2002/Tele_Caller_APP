class FetchingNumber {
  String? message;
  String? mobileNo;
  String? name;
  double? amount; // Use double to handle both null and numeric values
  String? dataType; // New field for data_type
  String? excelId; // New field for excel_id

  FetchingNumber({
    this.message,
    this.mobileNo,
    this.name,
    this.amount,
    this.dataType,
    this.excelId, // New field added
  });

  FetchingNumber.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    mobileNo = json['mobile_no'];
    name = json['name'];
    dataType = json['data_type'];
    excelId = json['excel_id']; // Parse excel_id

    // Ensure the amount is parsed correctly
    var amountValue = json['amount'];
    if (amountValue is String) {
      amount = double.tryParse(amountValue); // Convert String to double
    } else if (amountValue is num) {
      amount = amountValue.toDouble(); // Convert int or double to double
    } else {
      amount = null; // Handle unexpected types
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['mobile_no'] = mobileNo;
    data['name'] = name;
    data['amount'] = amount;
    data['data_type'] = dataType;
    data['excel_id'] = excelId; // Serialize excel_id
    return data;
  }
}
