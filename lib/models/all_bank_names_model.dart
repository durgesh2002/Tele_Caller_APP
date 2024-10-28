class AllBankNames {
  List<AllBankNamesData>? data;

  AllBankNames({this.data});

  AllBankNames.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <AllBankNamesData>[];
      json['data'].forEach((v) {
        data!.add(new AllBankNamesData.fromJson(v));
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

class AllBankNamesData {
  String? id;
  String? bankName;
  String? bankerName;
  String? bankerCode;
  String? source;
  String? product;
  String? state;
  String? location;
  String? designation;
  String? mobile;
  String? email;
  String? created;

  AllBankNamesData(
      {this.id,
      this.bankName,
      this.bankerName,
      this.bankerCode,
      this.source,
      this.product,
      this.state,
      this.location,
      this.designation,
      this.mobile,
      this.email,
      this.created});

  AllBankNamesData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bankName = json['bank_name'];
    bankerName = json['banker_name'];
    bankerCode = json['banker_code'];
    source = json['source'];
    product = json['product'];
    state = json['state'];
    location = json['location'];
    designation = json['designation'];
    mobile = json['mobile'];
    email = json['email'];
    created = json['created'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['bank_name'] = bankName;
    data['banker_name'] = bankerName;
    data['banker_code'] = bankerCode;
    data['source'] = source;
    data['product'] = product;
    data['state'] = state;
    data['location'] = location;
    data['designation'] = designation;
    data['mobile'] = mobile;
    data['email'] = email;
    data['created'] = created;
    return data;
  }
}
