class RemarkList {
  final String id;
  final String loginRequestId;
  final String userId;
  final String remark;
  final DateTime date;

  RemarkList({
    required this.id,
    required this.loginRequestId,
    required this.userId,
    required this.remark,
    required this.date,
  });

  // Factory constructor to create a RemarkList object from a JSON map
  factory RemarkList.fromJson(Map<String, dynamic> json) {
    return RemarkList(
      id: json['id'],
      loginRequestId: json['login_request_id'],
      userId: json['user_id'],
      remark: json['remark'] ?? '', // Default to an empty string if null
      date: DateTime.parse(json['date']),
    );
  }

  // Method to convert RemarkList object back to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'login_request_id': loginRequestId,
      'user_id': userId,
      'remark': remark,
      'date': date.toIso8601String(), // Convert DateTime to String
    };
  }
}
