class AppNotification {
  final String id;
  final String title;
  final String message;
  final String type; // "BookingUpdate" | "ChatOffer" | "Verification" | "System"
  final String? targetId;
  final bool isRead;
  final DateTime createdAt;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    this.targetId,
    this.isRead = false,
    required this.createdAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    final msg = json['body']?.toString() ?? json['message']?.toString() ?? '';
    final timeRaw = json['createdAtUtc'] ?? json['createdAt'];
    final tId = json['relatedEntityId']?.toString() ?? json['targetId']?.toString() ?? json['linkUrl']?.toString();

    return AppNotification(
      id: json['notificationId']?.toString() ?? json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Notification',
      message: msg,
      type: json['type']?.toString() ?? 'System',
      targetId: tId,
      isRead: json['isRead'] == true,
      createdAt: timeRaw != null
          ? DateTime.tryParse(timeRaw.toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
