import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/user_model.dart';

class AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSource({required this.apiClient});

  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String fullName,
    String? phoneNumber,
    required String role,
  }) async {
    final response = await apiClient.post(
      ApiConstants.register,
      data: {
        'email': email,
        'password': password,
        'fullName': fullName,
        'phoneNumber': phoneNumber,
        'role': role,
      },
    );
    return response is Map<String, dynamic> ? response : {};
  }

  Future<AuthResponse> verifyOtp({
    required String email,
    required String otp,
  }) async {
    final response = await apiClient.post(
      ApiConstants.verifyOtp,
      data: {
        'email': email,
        'otp': otp,
      },
    );
    return AuthResponse.fromJson(response as Map<String, dynamic>);
  }

  Future<void> resendOtp(String email) async {
    await apiClient.post(
      ApiConstants.resendOtp,
      data: {'email': email},
    );
  }

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    final response = await apiClient.post(
      ApiConstants.login,
      data: {
        'email': email,
        'password': password,
      },
    );
    return AuthResponse.fromJson(response as Map<String, dynamic>);
  }

  Future<AuthResponse> loginWithGoogle(String idToken) async {
    final response = await apiClient.post(
      ApiConstants.googleLogin,
      data: {'idToken': idToken},
    );
    return AuthResponse.fromJson(response as Map<String, dynamic>);
  }

  Future<void> logout() async {
    try {
      await apiClient.post(ApiConstants.logout);
    } catch (_) {}
  }
}
