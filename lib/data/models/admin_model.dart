class VerificationRequest {
  final String id;
  final String requestType;
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
    this.requestType = 'Worker',
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
    final reqId = json['requestId']?.toString() ?? json['id']?.toString() ?? '';
    final wId = json['workerProfileId']?.toString() ?? json['workerId']?.toString() ?? reqId;
    final rType = json['requestType']?.toString() ?? 'Worker';
    final name = json['fullName']?.toString() ?? 'Craftsman';
    final email = json['email']?.toString() ?? '';
    final phone = json['phone']?.toString() ?? json['phoneNumber']?.toString() ?? '';
    final wType = json['workerTypeName']?.toString() ?? json['workerType']?.toString() ?? 'Specialist';
    final docUrl = json['governmentIdDocumentUrl']?.toString() ?? json['idDocumentUrl']?.toString() ?? '';
    final docUrl2 = json['governmentIdDocumentUrl2']?.toString() ?? json['certificateUrl']?.toString();
    final timeRaw = json['submittedAtUtc'] ?? json['submittedAt'];

    return VerificationRequest(
      id: reqId,
      requestType: rType,
      workerId: wId,
      fullName: name,
      email: email,
      phoneNumber: phone,
      workerType: wType,
      yearsOfExperience: json['yearsOfExperience'] is int ? json['yearsOfExperience'] : 4,
      idDocumentUrl: docUrl,
      certificateUrl: docUrl2,
      status: json['status']?.toString() ?? 'Pending',
      rejectionReason: json['rejectionReason']?.toString() ?? json['notes']?.toString(),
      submittedAt: timeRaw != null
          ? DateTime.tryParse(timeRaw.toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
