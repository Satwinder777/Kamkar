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
    final sender = json['senderUserId']?.toString() ?? json['senderId']?.toString() ?? '';
    final msg = json['body']?.toString() ?? json['message']?.toString() ?? '';
    final timeRaw = json['createdAtUtc'] ?? json['createdAt'];
    final isMineFlag = json['mine'] == true || json['isMine'] == true;

    return ChatMessage(
      id: json['messageId']?.toString() ?? json['id']?.toString() ?? '',
      threadId: json['threadId']?.toString() ?? '',
      senderId: sender,
      senderName: json['senderName']?.toString() ?? (isMineFlag ? 'You' : 'Participant'),
      message: msg,
      proposedRate: (json['proposedRate'] as num?)?.toDouble(),
      rateStatus: json['rateStatus']?.toString(),
      createdAt: timeRaw != null
          ? DateTime.tryParse(timeRaw.toString()) ?? DateTime.now()
          : DateTime.now(),
      isMine: currentUserId != null ? sender == currentUserId : isMineFlag,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'messageId': id,
      'threadId': threadId,
      'senderUserId': senderId,
      'senderId': senderId,
      'senderName': senderName,
      'body': message,
      'message': message,
      'proposedRate': proposedRate,
      'rateStatus': rateStatus,
      'createdAtUtc': createdAt.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'mine': isMine,
      'isMine': isMine,
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
    final tId = json['threadId']?.toString() ?? json['id']?.toString() ?? '';
    final wId = json['workerProfileId']?.toString() ?? json['workerId']?.toString() ?? '';
    final cId = json['customerUserId']?.toString() ?? json['customerId']?.toString() ?? '';
    final name = json['workerName']?.toString() ?? json['customerName']?.toString() ?? 'Conversation';
    final photo = json['workerPhotoUrl']?.toString() ?? json['workerImageUrl']?.toString();
    final price = (json['currentPrice'] ?? json['currentOfferedRate']) as num?;
    final timeRaw = json['lastMessageAtUtc'] ?? json['updatedAt'];

    return NegotiationThread(
      id: tId,
      customerId: cId,
      customerName: json['customerName']?.toString() ?? 'Customer',
      workerId: wId,
      workerName: name,
      workerImageUrl: photo,
      serviceName: json['serviceName']?.toString() ?? 'Trade Service Negotiation',
      currentOfferedRate: price?.toDouble() ?? 45.0,
      lastMessage: json['lastMessage']?.toString() ?? 'Consultation active',
      updatedAt: timeRaw != null
          ? DateTime.tryParse(timeRaw.toString()) ?? DateTime.now()
          : DateTime.now(),
      unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
    );
  }
}
