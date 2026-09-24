class ApiConstants {
  // Auth
  static const String register = '/auth/register';
  static const String verifyOtp = '/auth/verify-otp';
  static const String resendOtp = '/auth/resend-otp';
  static const String login = '/auth/login';
  static const String googleLogin = '/auth/google';
  static const String refreshToken = '/auth/refresh-token';
  static const String logout = '/auth/logout';
  static const String onboardingStatus = '/users/me/status';

  // Catalog
  static const String workerTypes = '/catalog/worker-types';
  static const String services = '/catalog/services';

  // Workers
  static const String workerSearch = '/workers/search';
  static const String workerDetail = '/workers'; // /workers/{id}
  static const String workerPhotos = '/workers'; // /workers/{id}/photos

  // Bookings
  static const String bookings = '/bookings';
  static const String myBookings = '/bookings/my-bookings';
  static const String bookingStatus = '/bookings'; // /bookings/{id}/status

  // Negotiation & Chat
  static const String threads = '/negotiate/threads';
  static const String messages = '/negotiate/messages';
  static const String proposeOffer = '/negotiate/offer';

  // Notifications
  static const String notifications = '/notifications';
  static const String markNotificationRead = '/notifications'; // /notifications/{id}/read

  // Dashboards
  static const String customerDashboard = '/dashboards/customer';
  static const String workerDashboard = '/dashboards/worker';
  static const String organisationDashboard = '/dashboards/organisation';

  // Onboarding
  static const String workerProfile = '/onboarding/worker-profile';
  static const String uploadDocument = '/onboarding/upload-document';

  // Organisations
  static const String registerOrganisation = '/organisations/register';
  static const String organisationProfile = '/organisations/me';

  // Reviews
  static const String reviews = '/reviews';
  static const String workerReviews = '/reviews/worker';

  // User Settings
  static const String userSettings = '/users/me/settings';
  static const String updateProfile = '/users/me/profile';

  // Admin
  static const String adminVerifications = '/admin/verifications';
  static const String adminVerificationDecision = '/admin/verifications'; // /admin/verifications/{id}/decision
}
