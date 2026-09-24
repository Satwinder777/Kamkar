class VerificationRequest {
  final String id;
  final String workerId;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String workerType;
  final int yearsOfExperience;
  final String idDocumentUrl;
  final String? certificateUrl;
  final String status; // "Pending" | "Approved" | "Rejected"
  final String? rejectionReason;
  final DateTime submittedAt;

  VerificationRequest({
    required this.id,
    required this.workerId,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.workerType,
    required this.yearsOfExperience,
    required this.idDocumentUrl,
    this.certificateUrl,
    required this.status,
    this.rejectionReason,
    required this.submittedAt,
  });

  factory VerificationRequest.fromJson(Map<String, dynamic> json) {
    return VerificationRequest(
      id: json['id']?.toString() ?? '',
      workerId: json['workerId']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phoneNumber: json['phoneNumber']?.toString() ?? '',
      workerType: json['workerType']?.toString() ?? 'General Worker',
      yearsOfExperience: json['yearsOfExperience'] is int ? json['yearsOfExperience'] : 1,
      idDocumentUrl: json['idDocumentUrl']?.toString() ?? '',
      certificateUrl: json['certificateUrl']?.toString(),
      status: json['status']?.toString() ?? 'Pending',
      rejectionReason: json['rejectionReason']?.toString(),
      submittedAt: json['submittedAt'] != null
          ? DateTime.tryParse(json['submittedAt']) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
