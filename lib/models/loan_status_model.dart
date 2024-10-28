class LoanStatus {
  final String id;
  final String title;
  final DateTime? created;

  LoanStatus({
    required this.id,
    required this.title,
    this.created,
  });

  // Factory constructor to create a LoanStatus from JSON
  factory LoanStatus.fromJson(Map<String, dynamic> json) {
    return LoanStatus(
      id: json['id'] as String,
      title: json['title'] as String,
      created: json['created'] != null
          ? DateTime.tryParse(json['created']) // Use tryParse for safe parsing
          : null,
    );
  }

  // Method to convert a LoanStatus object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'created': created?.toIso8601String(),
    };
  }
}
