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
    return Booking(
      id: json['id']?.toString() ?? '',
      customerId: json['customerId']?.toString() ?? '',
      customerName: json['customerName']?.toString() ?? 'Customer',
      workerId: json['workerId']?.toString() ?? '',
      workerName: json['workerName']?.toString() ?? 'Skilled Worker',
      workerImageUrl: json['workerImageUrl']?.toString(),
      serviceName: json['serviceName']?.toString() ?? 'General Maintenance',
      scheduledDate: json['scheduledDate'] != null
          ? DateTime.tryParse(json['scheduledDate']) ?? DateTime.now()
          : DateTime.now(),
      address: json['address']?.toString() ?? '',
      notes: json['notes']?.toString(),
      agreedRate: (json['agreedRate'] as num?)?.toDouble() ?? 0.0,
      status: json['status']?.toString() ?? 'Pending',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt']) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'customerName': customerName,
      'workerId': workerId,
      'workerName': workerName,
      'workerImageUrl': workerImageUrl,
      'serviceName': serviceName,
      'scheduledDate': scheduledDate.toIso8601String(),
      'address': address,
      'notes': notes,
      'agreedRate': agreedRate,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
