import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/routes/app_routes.dart';
import '../../core/storage/secure_storage_service.dart';

class OnboardingController extends GetxController {
  final SecureStorageService storageService = Get.find<SecureStorageService>();
  final PageController pageController = PageController();
  final RxInt currentPage = 0.obs;

  final int totalPages = 5;

  void onPageChanged(int page) {
    currentPage.value = page;
  }

  void nextPage() {
    if (currentPage.value < totalPages - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    } else {
      finishOnboarding();
    }
  }

  void skipOnboarding() {
    finishOnboarding();
  }

  Future<void> finishOnboarding({String? targetRoute}) async {
    await storageService.setOnboardingCompleted(true);
    if (targetRoute != null) {
      Get.offAllNamed(targetRoute);
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
