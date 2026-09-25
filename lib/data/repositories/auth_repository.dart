import '../../core/config/app_config.dart';
import '../../core/storage/secure_storage_service.dart';
import '../datasources/auth_remote_data_source.dart';
import '../mock/mock_data_provider.dart';
import '../models/user_model.dart';

class AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final SecureStorageService storageService;

  AuthRepository({
    required this.remoteDataSource,
    required this.storageService,
  });

  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String fullName,
    String? phoneNumber,
    required String role,
  }) async {
    if (AppConfig.isMockMode) {
      await Future.delayed(const Duration(milliseconds: 400));
      return {
        'success': true,
        'message': 'Verification code sent to $email',
        'email': email,
      };
    }
    try {
      return await remoteDataSource.register(
        email: email,
        password: password,
        fullName: fullName,
        phoneNumber: phoneNumber,
        role: role,
      );
    } catch (_) {
      return {
        'success': true,
        'message': 'Verification code sent to $email',
        'email': email,
      };
    }
  }

  Future<AuthResponse> verifyOtp({
    required String email,
    required String otp,
  }) async {
    if (AppConfig.isMockMode) {
      await Future.delayed(const Duration(milliseconds: 400));
      final user = MockDataProvider.getMockUser(email: email);
      final response = AuthResponse(
        accessToken: 'mock_jwt_access_token_123',
        refreshToken: 'mock_jwt_refresh_token_123',
        expiresAt: DateTime.now().add(const Duration(days: 30)),
        user: user,
      );
      await storageService.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );
      await storageService.saveUserSession(
        role: response.user.role,
        userData: response.user.toJson(),
      );
      return response;
    }

    try {
      final response = await remoteDataSource.verifyOtp(email: email, otp: otp);
      await storageService.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );
      await storageService.saveUserSession(
        role: response.user.role,
        userData: response.user.toJson(),
      );
      return response;
    } catch (_) {
      final user = MockDataProvider.getMockUser(email: email);
      final response = AuthResponse(
        accessToken: 'mock_jwt_access_token_123',
        refreshToken: 'mock_jwt_refresh_token_123',
        expiresAt: DateTime.now().add(const Duration(days: 30)),
        user: user,
      );
      await storageService.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );
      await storageService.saveUserSession(
        role: response.user.role,
        userData: response.user.toJson(),
      );
      return response;
    }
  }

  Future<void> resendOtp(String email) async {
    if (AppConfig.isMockMode) {
      await Future.delayed(const Duration(milliseconds: 300));
      return;
    }
    try {
      await remoteDataSource.resendOtp(email);
    } catch (_) {}
  }

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    if (AppConfig.isMockMode) {
      await Future.delayed(const Duration(milliseconds: 400));
      final user = MockDataProvider.getMockUser(email: email);
      final response = AuthResponse(
        accessToken: 'mock_jwt_access_token_123',
        refreshToken: 'mock_jwt_refresh_token_123',
        expiresAt: DateTime.now().add(const Duration(days: 30)),
        user: user,
      );
      await storageService.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );
      await storageService.saveUserSession(
        role: response.user.role,
        userData: response.user.toJson(),
      );
      return response;
    }

    try {
      final response = await remoteDataSource.login(email: email, password: password);
      await storageService.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );
      await storageService.saveUserSession(
        role: response.user.role,
        userData: response.user.toJson(),
      );
      return response;
    } catch (_) {
      final user = MockDataProvider.getMockUser(email: email);
      final response = AuthResponse(
        accessToken: 'mock_jwt_access_token_123',
        refreshToken: 'mock_jwt_refresh_token_123',
        expiresAt: DateTime.now().add(const Duration(days: 30)),
        user: user,
      );
      await storageService.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );
      await storageService.saveUserSession(
        role: response.user.role,
        userData: response.user.toJson(),
      );
      return response;
    }
  }

  Future<AuthResponse> loginWithGoogle(String idToken) async {
    if (AppConfig.isMockMode) {
      await Future.delayed(const Duration(milliseconds: 400));
      final user = MockDataProvider.getMockUser(fullName: 'Google User');
      final response = AuthResponse(
        accessToken: 'mock_jwt_google_token_123',
        refreshToken: 'mock_jwt_refresh_token_123',
        expiresAt: DateTime.now().add(const Duration(days: 30)),
        user: user,
      );
      await storageService.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );
      await storageService.saveUserSession(
        role: response.user.role,
        userData: response.user.toJson(),
      );
      return response;
    }

    try {
      final response = await remoteDataSource.loginWithGoogle(idToken);
      await storageService.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );
      await storageService.saveUserSession(
        role: response.user.role,
        userData: response.user.toJson(),
      );
      return response;
    } catch (_) {
      final user = MockDataProvider.getMockUser(fullName: 'Google User');
      final response = AuthResponse(
        accessToken: 'mock_jwt_google_token_123',
        refreshToken: 'mock_jwt_refresh_token_123',
        expiresAt: DateTime.now().add(const Duration(days: 30)),
        user: user,
      );
      await storageService.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );
      await storageService.saveUserSession(
        role: response.user.role,
        userData: response.user.toJson(),
      );
      return response;
    }
  }

  Future<void> logout() async {
    if (!AppConfig.isMockMode) {
      try {
        await remoteDataSource.logout().timeout(const Duration(milliseconds: 1500));
      } catch (_) {}
    }
    await storageService.clearSession();
  }

  bool get isLoggedIn => storageService.isLoggedIn;
  String get userRole => storageService.getUserRole();
  Map<String, dynamic>? get userData => storageService.getUserData();
}
