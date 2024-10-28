class UserModel {
  Profile? profile;

  UserModel({this.profile});

  UserModel.fromJson(Map<String, dynamic> json) {
    profile =
        json['profile'] != null ? new Profile.fromJson(json['profile']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (profile != null) {
      data['profile'] = profile!.toJson();
    }
    return data;
  }
}

class Profile {
  String? id;
  String? name;
  String? username;
  String? password;
  String? roleId;
  String? usertype;
  String? created;

  Profile(
      {this.id,
      this.name,
      this.username,
      this.password,
      this.roleId,
      this.usertype,
      this.created});

  Profile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    username = json['username'];
    password = json['password'];
    roleId = json['role_id'];
    usertype = json['usertype'];
    created = json['created'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['username'] = username;
    data['password'] = password;
    data['role_id'] = roleId;
    data['usertype'] = usertype;
    data['created'] = created;
    return data;
  }
}
