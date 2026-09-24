class ChatMessage {
  final String id;
  final String threadId;
  final String senderId;
  final String senderName;
  final String message;
  final double? proposedRate;
  final String? rateStatus; // "Proposed" | "Accepted" | "Rejected"
  final DateTime createdAt;
  final bool isMine;

  ChatMessage({
    required this.id,
    required this.threadId,
    required this.senderId,
    required this.senderName,
    required this.message,
    this.proposedRate,
    this.rateStatus,
    required this.createdAt,
    this.isMine = false,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json, {String? currentUserId}) {
    final sender = json['senderId']?.toString() ?? '';
    return ChatMessage(
      id: json['id']?.toString() ?? '',
      threadId: json['threadId']?.toString() ?? '',
      senderId: sender,
      senderName: json['senderName']?.toString() ?? 'User',
      message: json['message']?.toString() ?? '',
      proposedRate: (json['proposedRate'] as num?)?.toDouble(),
      rateStatus: json['rateStatus']?.toString(),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt']) ?? DateTime.now()
          : DateTime.now(),
      isMine: currentUserId != null ? sender == currentUserId : (json['isMine'] == true),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'threadId': threadId,
      'senderId': senderId,
      'senderName': senderName,
      'message': message,
      'proposedRate': proposedRate,
      'rateStatus': rateStatus,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class NegotiationThread {
  final String id;
  final String customerId;
  final String customerName;
  final String workerId;
  final String workerName;
  final String? workerImageUrl;
  final String serviceName;
  final double currentOfferedRate;
  final String? lastMessage;
  final DateTime updatedAt;
  final int unreadCount;

  NegotiationThread({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.workerId,
    required this.workerName,
    this.workerImageUrl,
    required this.serviceName,
    required this.currentOfferedRate,
    this.lastMessage,
    required this.updatedAt,
    this.unreadCount = 0,
  });

  factory NegotiationThread.fromJson(Map<String, dynamic> json) {
    return NegotiationThread(
      id: json['id']?.toString() ?? '',
      customerId: json['customerId']?.toString() ?? '',
      customerName: json['customerName']?.toString() ?? 'Customer',
      workerId: json['workerId']?.toString() ?? '',
      workerName: json['workerName']?.toString() ?? 'Worker',
      workerImageUrl: json['workerImageUrl']?.toString(),
      serviceName: json['serviceName']?.toString() ?? 'Service Consultation',
      currentOfferedRate: (json['currentOfferedRate'] as num?)?.toDouble() ?? 0.0,
      lastMessage: json['lastMessage']?.toString(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt']) ?? DateTime.now()
          : DateTime.now(),
      unreadCount: json['unreadCount'] is int ? json['unreadCount'] : 0,
    );
  }
}
