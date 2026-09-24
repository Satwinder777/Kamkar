class UserModel {
  final String id;
  final String email;
  final String fullName;
  final String? phoneNumber;
  final String role; // "Customer" | "Worker" | "Organisation" | "Admin"
  final bool isProfileComplete;
  final String verificationStatus; // "Pending" | "Approved" | "Rejected"
  final String? profileImageUrl;

  UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    this.phoneNumber,
    required this.role,
    this.isProfileComplete = false,
    this.verificationStatus = 'Pending',
    this.profileImageUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
      phoneNumber: json['phoneNumber']?.toString(),
      role: json['role']?.toString() ?? 'Customer',
      isProfileComplete: json['isProfileComplete'] == true,
      verificationStatus: json['verificationStatus']?.toString() ?? 'Pending',
      profileImageUrl: json['profileImageUrl']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'role': role,
      'isProfileComplete': isProfileComplete,
      'verificationStatus': verificationStatus,
      'profileImageUrl': profileImageUrl,
    };
  }
}

class AuthResponse {
  final String accessToken;
  final String refreshToken;
  final DateTime? expiresAt;
  final UserModel user;

  AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    this.expiresAt,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['accessToken']?.toString() ?? '',
      refreshToken: json['refreshToken']?.toString() ?? '',
      expiresAt: json['expiresAt'] != null ? DateTime.tryParse(json['expiresAt']) : null,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>? ?? {}),
    );
  }
}
