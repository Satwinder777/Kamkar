import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/bindings/initial_binding.dart';
import 'core/localization/app_translations.dart';
import 'core/routes/app_pages.dart';
import 'core/storage/secure_storage_service.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Core Storage
  final storageService = SecureStorageService();
  await storageService.init();
  Get.put<SecureStorageService>(storageService, permanent: true);

  runApp(KamkarApp(storageService: storageService));
}

class KamkarApp extends StatelessWidget {
  final SecureStorageService storageService;
  const KamkarApp({super.key, required this.storageService});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Kamkar',
      debugShowCheckedModeBanner: false,
      initialBinding: InitialBinding(),
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: storageService.getThemeMode() == 'dark' ? ThemeMode.dark : ThemeMode.light,
      translations: AppTranslations(),
      locale: const Locale('en', 'US'),
      fallbackLocale: const Locale('en', 'US'),
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
    );
  }
}
