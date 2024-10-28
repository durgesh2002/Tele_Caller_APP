class DashboardTodayModel {
  Data? data;

  DashboardTodayModel({this.data});

  DashboardTodayModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class DashboardMonthlyModel {
  Data? data;

  DashboardMonthlyModel({this.data});

  DashboardMonthlyModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? totalAttempt;
  int? totalContact;
  int? totalNocontact;
  int? totalLead;

  Data(
      {this.totalAttempt,
      this.totalContact,
      this.totalNocontact,
      this.totalLead});

  Data.fromJson(Map<String, dynamic> json) {
    totalAttempt = json['total_attempt'];
    totalContact = json['total_contact'];
    totalNocontact = json['total_nocontact'];
    totalLead = json['total_lead'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_attempt'] = totalAttempt;
    data['total_contact'] = totalContact;
    data['total_nocontact'] = totalNocontact;
    data['total_lead'] = totalLead;
    return data;
  }
}
