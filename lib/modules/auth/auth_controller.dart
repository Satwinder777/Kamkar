import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_constants.dart';
import '../../core/routes/app_routes.dart';
import '../../data/repositories/auth_repository.dart';

class AuthController extends GetxController {
  final AuthRepository authRepository = Get.find<AuthRepository>();

  // Observables
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString selectedRole = AppConstants.roleCustomer.obs;
  final RxString registeredEmail = ''.obs;
  final RxInt resendCountdown = 60.obs;
  final RxBool canResend = false.obs;
  Timer? _resendTimer;

  // Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  final registerFormKey = GlobalKey<FormState>();
  final loginFormKey = GlobalKey<FormState>();

  @override
  void onClose() {
    _resendTimer?.cancel();
    emailController.dispose();
    passwordController.dispose();
    fullNameController.dispose();
    phoneController.dispose();
    otpController.dispose();
    super.onClose();
  }

  void startResendTimer() {
    resendCountdown.value = 60;
    canResend.value = false;
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendCountdown.value > 0) {
        resendCountdown.value--;
      } else {
        canResend.value = true;
        timer.cancel();
      }
    });
  }

  Future<void> register() async {
    if (!registerFormKey.currentState!.validate()) return;

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final email = emailController.text.trim();
      registeredEmail.value = email;

      await authRepository.register(
        email: email,
        password: passwordController.text,
        fullName: fullNameController.text.trim(),
        phoneNumber: phoneController.text.trim(),
        role: selectedRole.value,
      );

      startResendTimer();
      Get.toNamed(AppRoutes.otpVerification);
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Registration Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOtp() async {
    final otp = otpController.text.trim();
    if (otp.length < 6) {
      Get.snackbar('Invalid OTP', 'Please enter a valid 6-digit code');
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await authRepository.verifyOtp(
        email: registeredEmail.value.isNotEmpty ? registeredEmail.value : emailController.text.trim(),
        otp: otp,
      );

      _navigatePostAuth(response.user.role, response.user.verificationStatus);
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Verification Failed', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendOtp() async {
    if (!canResend.value) return;

    try {
      await authRepository.resendOtp(
        registeredEmail.value.isNotEmpty ? registeredEmail.value : emailController.text.trim(),
      );
      startResendTimer();
      Get.snackbar('Code Sent', 'A new verification code has been sent to your email.');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> login() async {
    if (!loginFormKey.currentState!.validate()) return;

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await authRepository.login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      _navigatePostAuth(response.user.role, response.user.verificationStatus);
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Login Failed', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginWithGoogle() async {
    isLoading.value = true;
    try {
      final response = await authRepository.loginWithGoogle('demo_google_token');
      _navigatePostAuth(response.user.role, response.user.verificationStatus);
    } catch (e) {
      Get.snackbar('Google Login', 'Google authentication failed: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _navigatePostAuth(String role, String verificationStatus) {
    if (role == AppConstants.roleWorker && verificationStatus == 'Pending') {
      Get.offAllNamed(AppRoutes.workerPendingApproval);
    } else {
      Get.offAllNamed(AppRoutes.main);
    }
  }

  Future<void> logout() async {
    await authRepository.logout();
    Get.offAllNamed(AppRoutes.login);
  }
}
