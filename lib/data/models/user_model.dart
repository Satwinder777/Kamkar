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
    String roleStr = 'Customer';
    if (json['role'] != null) {
      roleStr = json['role'].toString();
    } else if (json['roles'] is List && (json['roles'] as List).isNotEmpty) {
      roleStr = (json['roles'] as List).first.toString();
    } else if (json['accountType'] != null) {
      roleStr = json['accountType'].toString();
    }

    String name = json['fullName']?.toString() ?? '';
    if (name.isEmpty) {
      final fName = json['firstName']?.toString() ?? '';
      final lName = json['lastName']?.toString() ?? '';
      name = '$fName $lName'.trim();
      if (name.isEmpty) {
        name = json['displayName']?.toString() ?? json['email']?.toString().split('@').first ?? 'User';
      }
    }

    return UserModel(
      id: json['id']?.toString() ?? json['userId']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      fullName: name,
      phoneNumber: json['phoneNumber']?.toString() ?? json['phone']?.toString(),
      role: roleStr,
      isProfileComplete: json['isProfileComplete'] == true,
      verificationStatus: json['verificationStatus']?.toString() ?? 'Approved',
      profileImageUrl: json['profileImageUrl']?.toString() ?? json['profilePhotoUrl']?.toString(),
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
    UserModel parsedUser;
    if (json['user'] is Map<String, dynamic>) {
      parsedUser = UserModel.fromJson(json['user'] as Map<String, dynamic>);
    } else {
      parsedUser = UserModel.fromJson(json);
    }

    final expRaw = json['expiresAtUtc'] ?? json['expiresAt'];
    final exp = expRaw != null ? DateTime.tryParse(expRaw.toString()) : null;

    return AuthResponse(
      accessToken: json['accessToken']?.toString() ?? '',
      refreshToken: json['refreshToken']?.toString() ?? '',
      expiresAt: exp,
      user: parsedUser,
    );
  }
}
