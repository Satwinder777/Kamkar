# Kamkar Setup & Execution Guide

## Prerequisites
- Flutter SDK 3.24+ (Dart 3.5+)
- Android Studio / Xcode for Simulator & Device Testing
- ASP.NET Core Backend running on port 5294 (or fallback to configured mock adapter)

## Environment Configuration
The application reads API endpoints dynamically from `AppConfig` with fallback defaults:
- **Localhost (iOS/macOS)**: `http://localhost:5294/api/v1`
- **Android Emulator**: `http://10.0.2.2:5294/api/v1`
- **SignalR Negotiation Hub**: `/hubs/negotiate`

## Running the App

1. Install dependencies:
   ```bash
   flutter pub get
   ```

2. Run code analysis:
   ```bash
   flutter analyze
   ```

3. Run automated tests:
   ```bash
   flutter test
   ```

4. Launch on targeted device:
   ```bash
   flutter run
   ```
