import 'dart:io';
import 'package:flutter/foundation.dart';

class AppConfig {
  static const String appName = 'Kamkar';
  static const String appTagline = 'Instant, Verified On-Demand Workforce';
  static const String appVersion = '1.0.0';

  /// Set to true while backend API is pending/offline to bypass and mock all flows smoothly
  /// Set to false when connecting to live ASP.NET Core 8 backend
  static const bool isMockMode = true;

  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:5294/api/v1';
    }
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:5294/api/v1';
    }
    return 'http://localhost:5294/api/v1';
  }

  static String get signalRHubUrl {
    if (kIsWeb) {
      return 'http://localhost:5294/hubs/negotiate';
    }
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:5294/hubs/negotiate';
    }
    return 'http://localhost:5294/hubs/negotiate';
  }

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
}
