class ComplaintModel {
  final int id;
  final String requestType;
  final String details;
  final String status;
  final String? comment;
  final DateTime createdAt;

  ComplaintModel({
    required this.id,
    required this.requestType,
    required this.details,
    required this.status,
    this.comment,
    required this.createdAt,
  });

  factory ComplaintModel.fromJson(Map<String, dynamic> json) {
    return ComplaintModel(
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

  /// Helper to extract the category if we prefixed it like "Category: Academic\n..."
  String get category {
    if (details.startsWith('Category: ')) {
      final lines = details.split('\n');
      if (lines.isNotEmpty) {
        return lines.first.replaceFirst('Category: ', '').trim();
      }
    }
    return 'General';
  }

  /// Helper to extract the message without the category prefix
  String get message {
    if (details.startsWith('Category: ')) {
      final lines = details.split('\n');
      if (lines.length > 1) {
        return lines.sublist(1).join('\n').replaceFirst('Message: ', '').trim();
      }
    }
    return details;
  }
}
