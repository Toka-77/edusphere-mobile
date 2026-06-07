class OfficialRequestModel {
  final int id;
  final String requestType;
  final String details;
  final String status;
  final String? comment;
  final DateTime createdAt;

  OfficialRequestModel({
    required this.id,
    required this.requestType,
    required this.details,
    required this.status,
    this.comment,
    required this.createdAt,
  });

  factory OfficialRequestModel.fromJson(Map<String, dynamic> json) {
    return OfficialRequestModel(
      id: json['id'] ?? 0,
      requestType: json['request_type']?.toString() ?? '',
      details: json['details']?.toString() ?? '',
      status: json['status']?.toString() ?? 'pending',
      comment: json['comment']?.toString(),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  /// Returns a display-friendly date string like "02 May 2026"
  String get formattedDate {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${createdAt.day.toString().padLeft(2, '0')} '
        '${months[createdAt.month - 1]} '
        '${createdAt.year}';
  }

  /// Helper to extract document name from details
  String get documentName {
    if (details.startsWith('Document: ')) {
      return details.replaceFirst('Document: ', '').trim();
    }
    return 'Official Request';
  }
}
