class AppConfig {
  static const String appName = 'Kamkar';
  static const String appTagline = 'Instant, Verified On-Demand Workforce';
  static const String appVersion = '1.0.0';

  /// Set to false to run fully dynamic with live ASP.NET Core 8 API backend
  static const bool isMockMode = false;

  /// Live Cloudflare Tunnel Base URL for ASP.NET Core 8 API
  static const String liveServerUrl = 'https://favour-walk-casa-methodology.trycloudflare.com';

  static String get baseUrl => '$liveServerUrl/api/v1';

  static String get signalRHubUrl => '$liveServerUrl/hubs/negotiate';

  static const Duration connectTimeout = Duration(seconds: 25);
  static const Duration receiveTimeout = Duration(seconds: 25);
}
