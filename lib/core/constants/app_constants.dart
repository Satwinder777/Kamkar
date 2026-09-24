class AppConstants {
  // Storage Keys
  static const String accessTokenKey = 'kamkar_access_token';
  static const String refreshTokenKey = 'kamkar_refresh_token';
  static const String userRoleKey = 'kamkar_user_role';
  static const String userDataKey = 'kamkar_user_data';
  static const String themeModeKey = 'kamkar_theme_mode';
  static const String languageKey = 'kamkar_language_code';
  static const String onboardingCompletedKey = 'kamkar_onboarding_completed';

  // Role Strings
  static const String roleGuest = 'Guest';
  static const String roleCustomer = 'Customer';
  static const String roleWorker = 'Worker';
  static const String roleOrganisation = 'Organisation';
  static const String roleAdmin = 'Admin';

  // UI Durations
  static const Duration splashDuration = Duration(milliseconds: 2200);
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationNormal = Duration(milliseconds: 350);
  static const Duration debounceDuration = Duration(milliseconds: 400);
}
