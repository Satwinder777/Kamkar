import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/routes/app_routes.dart';
import '../../core/storage/secure_storage_service.dart';
import '../../data/repositories/auth_repository.dart';

class SettingsController extends GetxController {
  final SecureStorageService storageService = Get.find<SecureStorageService>();
  final AuthRepository authRepository = Get.find<AuthRepository>();

  final RxBool isDarkMode = false.obs;
  final RxString currentLanguage = 'en'.obs;

  @override
  void onInit() {
    super.onInit();
    isDarkMode.value = storageService.getThemeMode() == 'dark';
    currentLanguage.value = storageService.getLanguage();
  }

  void toggleTheme(bool val) {
    isDarkMode.value = val;
    final mode = val ? 'dark' : 'light';
    storageService.setThemeMode(mode);
    Get.changeThemeMode(val ? ThemeMode.dark : ThemeMode.light);
  }

  void changeLanguage(String langCode) {
    currentLanguage.value = langCode;
    storageService.setLanguage(langCode);
    if (langCode == 'ar') {
      Get.updateLocale(const Locale('ar', 'SA'));
    } else {
      Get.updateLocale(const Locale('en', 'US'));
    }
  }

  Future<void> logout() async {
    await authRepository.logout();
    Get.offAllNamed(AppRoutes.login);
  }
}
