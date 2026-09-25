class Booking {
  final String id;
  final String customerId;
  final String customerName;
  final String workerId;
  final String workerName;
  final String? workerImageUrl;
  final String serviceName;
  final DateTime scheduledDate;
  final String address;
  final String? notes;
  final double agreedRate;
  final String status; // "Pending" | "Confirmed" | "InProgress" | "Completed" | "Cancelled" | "Rejected"
  final DateTime createdAt;

  Booking({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.workerId,
    required this.workerName,
    this.workerImageUrl,
    required this.serviceName,
    required this.scheduledDate,
    required this.address,
    this.notes,
    required this.agreedRate,
    required this.status,
    required this.createdAt,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    final schedRaw = json['scheduledStartUtc'] ?? json['scheduledDate'] ?? json['createdAtUtc'];
    final createdRaw = json['createdAtUtc'] ?? json['createdAt'];
    final rateRaw = json['agreedAmount'] ?? json['agreedRate'] ?? json['providerEarningAmount'];
    final addr = json['addressLine'] ?? json['address'] ?? json['city'] ?? 'Dubai, UAE';

    return Booking(
      id: json['id']?.toString() ?? '',
      customerId: json['customerProfileId']?.toString() ?? json['customerId']?.toString() ?? '',
      customerName: json['customerName']?.toString() ?? 'Customer',
      workerId: json['workerProfileId']?.toString() ?? json['workerId']?.toString() ?? '',
      workerName: json['workerName']?.toString() ?? 'Skilled Craftsman',
      workerImageUrl: json['workerImageUrl']?.toString() ?? json['profilePhotoUrl']?.toString(),
      serviceName: json['serviceName']?.toString() ?? 'General Trade Service',
      scheduledDate: schedRaw != null
          ? DateTime.tryParse(schedRaw.toString()) ?? DateTime.now()
          : DateTime.now(),
      address: addr.toString(),
      notes: json['notes']?.toString(),
      agreedRate: (rateRaw as num?)?.toDouble() ?? 50.0,
      status: json['status']?.toString() ?? 'Pending',
      createdAt: createdRaw != null
          ? DateTime.tryParse(createdRaw.toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Booking copyWith({
    String? id,
    String? customerId,
    String? customerName,
    String? workerId,
    String? workerName,
    String? workerImageUrl,
    String? serviceName,
    DateTime? scheduledDate,
    String? address,
    String? notes,
    double? agreedRate,
    String? status,
    DateTime? createdAt,
  }) {
    return Booking(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      workerId: workerId ?? this.workerId,
      workerName: workerName ?? this.workerName,
      workerImageUrl: workerImageUrl ?? this.workerImageUrl,
      serviceName: serviceName ?? this.serviceName,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      address: address ?? this.address,
      notes: notes ?? this.notes,
      agreedRate: agreedRate ?? this.agreedRate,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerProfileId': customerId,
      'customerId': customerId,
      'customerName': customerName,
      'workerProfileId': workerId,
      'workerId': workerId,
      'workerName': workerName,
      'workerImageUrl': workerImageUrl,
      'serviceName': serviceName,
      'scheduledStartUtc': scheduledDate.toIso8601String(),
      'scheduledDate': scheduledDate.toIso8601String(),
      'addressLine': address,
      'address': address,
      'notes': notes,
      'agreedAmount': agreedRate,
      'agreedRate': agreedRate,
      'status': status,
      'createdAtUtc': createdAt.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
