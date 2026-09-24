import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class SecureStorageService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Tokens
  Future<void> saveTokens({required String accessToken, required String refreshToken}) async {
    await _secureStorage.write(key: AppConstants.accessTokenKey, value: accessToken);
    await _secureStorage.write(key: AppConstants.refreshTokenKey, value: refreshToken);
  }

  Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: AppConstants.accessTokenKey);
  }

  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: AppConstants.refreshTokenKey);
  }

  // User Role & Data
  Future<void> saveUserSession({
    required String role,
    required Map<String, dynamic> userData,
  }) async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs?.setString(AppConstants.userRoleKey, role);
    await _prefs?.setString(AppConstants.userDataKey, jsonEncode(userData));
  }

  String getUserRole() {
    return _prefs?.getString(AppConstants.userRoleKey) ?? AppConstants.roleGuest;
  }

  Map<String, dynamic>? getUserData() {
    final str = _prefs?.getString(AppConstants.userDataKey);
    if (str != null && str.isNotEmpty) {
      try {
        return jsonDecode(str) as Map<String, dynamic>;
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  bool get isLoggedIn {
    final role = getUserRole();
    return role != AppConstants.roleGuest;
  }

  // Preferences
  Future<void> setThemeMode(String mode) async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs?.setString(AppConstants.themeModeKey, mode);
  }

  String getThemeMode() {
    return _prefs?.getString(AppConstants.themeModeKey) ?? 'light';
  }

  Future<void> setLanguage(String langCode) async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs?.setString(AppConstants.languageKey, langCode);
  }

  String getLanguage() {
    return _prefs?.getString(AppConstants.languageKey) ?? 'en';
  }

  Future<void> setOnboardingCompleted(bool completed) async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs?.setBool(AppConstants.onboardingCompletedKey, completed);
  }

  bool isOnboardingCompleted() {
    return _prefs?.getBool(AppConstants.onboardingCompletedKey) ?? false;
  }

  // Clear on Logout
  Future<void> clearSession() async {
    await _secureStorage.delete(key: AppConstants.accessTokenKey);
    await _secureStorage.delete(key: AppConstants.refreshTokenKey);
    await _prefs?.remove(AppConstants.userRoleKey);
    await _prefs?.remove(AppConstants.userDataKey);
  }
}
