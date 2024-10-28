class FollowUpSubmitedList {
  List<Data>? data;

  FollowUpSubmitedList({this.data});

  FollowUpSubmitedList.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? id;
  String? entryDate;
  String? customerName;
  String? contactNumber;
  String? bankName;
  String? dataType;
  String? salary;
  String? followupDate;
  String? contactStatus;
  String? remarkStatus;
  String? remark;
  String? telecallerId;
  String? tcname;

  Data(
      {this.id,
      this.entryDate,
      this.customerName,
      this.contactNumber,
      this.bankName,
      this.dataType,
      this.salary,
      this.followupDate,
      this.contactStatus,
      this.remarkStatus,
      this.remark,
      this.telecallerId,
      this.tcname});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    entryDate = json['entry_date'];
    customerName = json['customer_name'];
    contactNumber = json['contact_number'];
    bankName = json['bank_name'];
    dataType = json['data_type'];
    salary = json['salary'];
    followupDate = json['followup_date'];
    contactStatus = json['contact_status'];
    remarkStatus = json['remark_status'];
    remark = json['remark'];
    telecallerId = json['telecaller_id'];
    tcname = json['tcname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['entry_date'] = entryDate;
    data['customer_name'] = customerName;
    data['contact_number'] = contactNumber;
    data['bank_name'] = bankName;
    data['data_type'] = dataType;
    data['salary'] = salary;
    data['followup_date'] = followupDate;
    data['contact_status'] = contactStatus;
    data['remark_status'] = remarkStatus;
    data['remark'] = remark;
    data['telecaller_id'] = telecallerId;
    data['tcname'] = tcname;
    return data;
  }
}
