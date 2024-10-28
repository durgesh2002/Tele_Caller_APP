class DataEntryModel {
  List<Data>? data;

  DataEntryModel({this.data});

  // Factory constructor for JSON parsing
  factory DataEntryModel.fromJson(Map<String, dynamic> json) {
    return DataEntryModel(
      data: json['data'] != null
          ? List<Data>.from(json['data'].map((v) => Data.fromJson(v)))
          : null,
    );
  }

  // Convert object to JSON map
  Map<String, dynamic> toJson() {
    return {
      if (data != null) 'data': data!.map((v) => v.toJson()).toList(),
    };
  }
}

class Data {
  String? id;
  String? subAdminId;
  String? dashboardType;
  String? dsaName;
  String? date;
  String? mobileNo;
  String? customerName;
  String? customerId;
  int? income; // Changed to int for calculation purposes
  String? companyName;
  String? caseType;
  String? caseStudy;
  String? dob;
  String? disbursementDate;
  double? loanAmount; // Changed to double for precision in financial data
  String? loginBank;
  String? bankerId;
  String? bankerName;
  String? bankerMobile;
  String? bankerEmail;
  String? losNo;
  String? teleCallerName;
  String? teleCallerId;
  String? teamLeader;
  String? status;
  String? comments;
  String? invoiceId;
  String? paidStatus;
  String? tcName;
  String? tlName;
  String? adminSubAdminName;
  String? calculationId;
  String? invoiceNumber;
  String? bankName;
  String? dataEntryStatus;

  // Constructor with named parameters
  Data({
    this.id,
    this.subAdminId,
    this.dashboardType,
    this.dsaName,
    this.date,
    this.mobileNo,
    this.customerName,
    this.customerId,
    this.income,
    this.companyName,
    this.caseType,
    this.caseStudy,
    this.dob,
    this.disbursementDate,
    this.loanAmount,
    this.loginBank,
    this.bankerId,
    this.bankerName,
    this.bankerMobile,
    this.bankerEmail,
    this.losNo,
    this.teleCallerName,
    this.teleCallerId,
    this.teamLeader,
    this.status,
    this.comments,
    this.invoiceId,
    this.paidStatus,
    this.tcName,
    this.tlName,
    this.adminSubAdminName,
    this.calculationId,
    this.invoiceNumber,
    this.bankName,
    this.dataEntryStatus,
  });

  // Factory constructor for JSON parsing
  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'],
      subAdminId: json['sub_admin_id'],
      dashboardType: json['dashboard_type'],
      dsaName: json['dsaName'] ?? json['dsa_name'],
      date: json['date'],
      mobileNo: json['mobile_no'],
      customerName: json['customer_name'],
      customerId: json['customer_id'],
      income: int.tryParse(json['income'] ?? '0'), // Safely parse income
      companyName: json['company_name'],
      caseType: json['caseType'],
      caseStudy: json['case_study'],
      dob: json['dob'],
      disbursementDate: json['disbursement_date'],
      loanAmount: double.tryParse(
          json['loanAmount'] ?? '0'), // Safely parse loan amount
      loginBank: json['loginBank'],
      bankerId: json['bankerid'],
      bankerName: json['bankerName'],
      bankerMobile: json['bankerMobile'],
      bankerEmail: json['bankerEmail'],
      losNo: json['losNo'],
      teleCallerName: json['teleCallerName'],
      teleCallerId: json['teleCallerid'],
      teamLeader: json['teamLeader'],
      status: json['status'],
      comments: json['comment_data'],
      invoiceId: json['invoice_id'],
      paidStatus: json['paid_status'],
      tcName: json['tcname'],
      tlName: json['tlname'],
      adminSubAdminName: json['admin_subadmin_name'],
      calculationId: json['calculationid'],
      invoiceNumber: json['invoice_number'],
      bankName: json['bank_name'],
      dataEntryStatus: json['data_entry_status'],
    );
  }

  // Convert object to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sub_admin_id': subAdminId,
      'dashboard_type': dashboardType,
      'dsaName': dsaName,
      'date': date,
      'mobile_no': mobileNo,
      'customer_name': customerName,
      'customer_id': customerId,
      'income':
          income?.toString(), // Store as string to avoid data loss in JSON
      'company_name': companyName,
      'caseType': caseType,
      'case_study': caseStudy,
      'dob': dob,
      'disbursement_date': disbursementDate,
      'loanAmount': loanAmount?.toString(), // Store as string for precision
      'loginBank': loginBank,
      'bankerid': bankerId,
      'bankerName': bankerName,
      'bankerMobile': bankerMobile,
      'bankerEmail': bankerEmail,
      'losNo': losNo,
      'teleCallerName': teleCallerName,
      'teleCallerid': teleCallerId,
      'teamLeader': teamLeader,
      'status': status,
      'comment_data': comments,
      'invoice_id': invoiceId,
      'paid_status': paidStatus,
      'tcname': tcName,
      'tlname': tlName,
      'admin_subadmin_name': adminSubAdminName,
      'calculationid': calculationId,
      'invoice_number': invoiceNumber,
      'bank_name': bankName,
      'data_entry_status': dataEntryStatus,
    };
  }
}
