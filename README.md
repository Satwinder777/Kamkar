# 🛠️ Kamkar — On-Demand Skilled Trades & Home Services Marketplace

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.29+-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.7+-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![GetX](https://img.shields.io/badge/State_Management-GetX-8A2BE2?style=for-the-badge)
![Clean Architecture](https://img.shields.io/badge/Architecture-Clean_Layered-10B981?style=for-the-badge)
![SignalR](https://img.shields.io/badge/Realtime-SignalR_Core-F97316?style=for-the-badge&logo=dotnet&logoColor=white)
![Tests](https://img.shields.io/badge/Tests-100%25_Passed-success?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)

<br/>

**Kamkar** is an enterprise-grade on-demand marketplace mobile & web application connecting homeowners, tenants, and businesses with certified skilled trade professionals (Electricians, Plumbers, HVAC Technicians, Carpenters, Painters, and more).

[Features](#-key-features) • [Design System](#-design-system--uiux) • [Architecture](#-clean-architecture) • [Quick Start](#-quick-start--setup) • [Mock Mode](#-dual-mode-operation-mock-vs-live-api) • [API & Hubs](#-api--signalr-integration)

</div>

---

## 📱 Screenshots & Visual Flow

| 1. Onboarding Walkthrough | 2. Trade Pros Marketplace | 3. Pro Profile & Services |
| :---: | :---: | :---: |
| 5-page animated onboarding walkthrough with trade showcase | Real-time search, category pills & verified pro cards | Ratings, reviews, portfolio gallery & instant booking CTA |

| 4. Real-Time Price Negotiation | 5. Instant Dispatch Booking | 6. Worker Dashboard & Earnings |
| :---: | :---: | :---: |
| In-app chat with live counter-offer proposals | Date/time picker, address validation & order dispatch | Weekly earnings chart, active leads & jobs counters |

---

## 🌟 Key Features

### 👤 1. Customer Experience
- **Trade Discovery**: Instant category filtering across Electricians, Plumbers, HVAC specialists, Carpenters, and Painters.
- **Dynamic Price Negotiation**: Propose custom hourly rates or package offers directly inside the live chat interface.
- **Instant Booking & Dispatch**: Schedule immediate emergency visits or future appointments with address autofill and note attachments.
- **Milestone Escrow Security**: Funds protected until work is inspected and marked completed.
- **Verified Reviews & Ratings**: Submit detailed feedback with multi-criteria ratings (Quality, Punctuality, Value).

### ⚡ 2. Worker & Trade Pro Hub
- **KYC Onboarding**: Upload government photo IDs, trade licenses, certifications, and portfolio photos.
- **Service Catalog Management**: Add custom services with custom base prices and estimated turnaround times.
- **Worker Analytics Dashboard**: Track weekly earnings with interactive trend charts, completed jobs metrics, and incoming job leads.
- **Live Dispatch Alerts**: Receive real-time push and in-app notifications for booking requests.

### 🏢 3. Organisation / Contractor Fleet
- Manage multi-worker crews, assign bookings to technicians, and view centralized performance analytics.

### 🛡️ 4. Admin Verification Engine
- **Review Queue**: Verify worker KYC documents, inspect uploaded trade certificates, and **Approve / Reject** applications with reason logs.

---

## 🎨 Design System & UI/UX

Kamkar is crafted adhering to modern design principles:

- **Primary Color Palette**:
  - `Electric Indigo` (`#4338CA`) — Brand Anchor
  - `Royal Violet` (`#6366F1`) — Interactive Accents & Highlights
  - `Emerald Success` (`#10B981`) — Confirmed & Verified Badges
  - `Amber Warning` (`#F59E0B`) — Pending & In-Progress States
  - `Clean Background` (`#F8FAFC` Light Mode / `#0B0F19` Dark Mode)
- **Typography**: 
  - **Outfit** for bold hero titles, section headlines, and numerical stats.
  - **Plus Jakarta Sans** for body copy, form fields, and metadata.
- **Theme Support**: Default **Light Mode** with high-contrast elements + instant toggle to sleek **Dark Mode**.
- **Micro-Interactions**: Smooth card elevations, soft colored glow drop shadows, and subtle fade transitions.

---

## 🏗️ Clean Architecture

Kamkar follows strict clean layered architecture:

```text
lib/
├── core/
│   ├── bindings/              # Dependency Injection bindings (InitialBinding, GetX)
│   ├── config/                # AppConfig (Mock Mode toggle, Base URLs, Environment)
│   ├── constants/             # API constants, Asset keys, Storage keys
│   ├── errors/                # Unified AppException & failure mapping
│   ├── localization/          # Translations (English / Arabic support)
│   ├── network/               # Dio Client with JWT Refresh Interceptor & SignalR Hub Service
│   ├── routes/                # Named AppRoutes & GetPages routing table
│   ├── storage/               # FlutterSecureStorage & SharedPreferences wrapper
│   ├── theme/                 # AppColors, AppTextTheme, Light & Dark AppTheme
│   └── widgets/               # Reusable atomic UI (CustomButton, CustomTextField, StatusBadge, WorkerCard, FloatingNavBar)
├── data/
│   ├── datasources/           # Remote HTTP & WebSocket datasources (Dio / SignalR)
│   ├── mock/                  # MockDataProvider (Complete offline realistic datasets)
│   ├── models/                # Strongly typed JSON serializable models (UserModel, WorkerProfile, Booking, Chat, Admin)
│   └── repositories/          # 7 Repositories with dual-mode bypass fallback
└── modules/
    ├── admin/                 # Admin Verification List & Detail Views
    ├── auth/                  # Splash, Login, Register, OTP Verification Views
    ├── booking/               # Create Booking, Booking List & Detail Views
    ├── chat/                  # Conversation List & Realtime Negotiation Chat Views
    ├── customer/              # Customer Dashboard & Profile Views
    ├── main_nav/              # Main Navigation Shell with Floating Glass Nav Bar
    ├── marketplace/           # Explore Categories, Search & Worker Detail Views
    ├── notifications/         # In-App Notifications Feed & Realtime Stream
    ├── onboarding/            # 5-Page Interactive Animated Onboarding Walkthrough
    ├── reviews/               # Create Review Modal with Star Rating Selector
    ├── settings/              # User Settings, Language & Theme Switcher
    └── worker/                # Worker Dashboard, Onboarding & Pending Approval Views
```

---

## ⚡ Dual-Mode Operation (Mock vs Live API)

Kamkar includes a zero-latency **Offline Mock Mode** that allows instant testing of every flow without running the ASP.NET Core backend.

To toggle between **Mock Mode** and **Live ASP.NET Core 8 Backend**:

Open [`lib/core/config/app_config.dart`](file:///Users/satwindersingh/Desktop/satwinder_ws/Flutter_Project_24_Sep/Kamkar/lib/core/config/app_config.dart):

```dart
class AppConfig {
  // Set to 'true' for offline dummy data bypass
  // Set to 'false' to connect to live ASP.NET Core 8 REST APIs & SignalR Hubs
  static const bool isMockMode = true; 
}
```

When `isMockMode = false`, the app automatically connects to:
- **REST API Base**: `http://localhost:5294/api/v1` (or `http://10.0.2.2:5294/api/v1` on Android)
- **SignalR Realtime Hub**: `http://localhost:5294/hubs/negotiate`

---

## 🚀 Quick Start & Setup

### Prerequisites
- **Flutter SDK**: `3.29.0+`
- **Dart SDK**: `3.7.0+`
- **Xcode** (for iOS / macOS) or **Android Studio** (for Android)

### 1. Clone the Repository
```bash
git clone https://github.com/Satwinder777/Kamkar.git
cd Kamkar
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Run the Application

#### 🌐 On Web Browser:
```bash
flutter run -d chrome
# OR
flutter run -d web-server --web-port 3000
```

#### 💻 On macOS Desktop:
```bash
flutter run -d macos
```

#### 📱 On Mobile Simulator / Device:
```bash
flutter run
```

---

## 🧪 Testing & Code Quality

The project maintains 100% clean static analysis and a comprehensive automated test suite.

### Run Static Analysis:
```bash
flutter analyze
```
> **Result**: `No issues found!`

### Run Automated Unit & Widget Tests:
```bash
flutter test
```
> **Result**: `16/16 All tests passed!`

---

## 🔌 API & SignalR Integration

| Module | HTTP Method / Event | Endpoint / Hub Method | Description |
| :--- | :--- | :--- | :--- |
| **Auth** | `POST` | `/api/v1/auth/login` | Email/password sign-in |
| **Auth** | `POST` | `/api/v1/auth/register` | Multi-role user registration |
| **Auth** | `POST` | `/api/v1/auth/verify-otp` | 6-digit OTP confirmation |
| **Marketplace** | `GET` | `/api/v1/workers` | Query workers by trade & city |
| **Bookings** | `POST` | `/api/v1/bookings` | Create new service booking |
| **Bookings** | `GET` | `/api/v1/bookings/my` | Retrieve active & past bookings |
| **Negotiation Hub** | `SignalR Invoke` | `SendOffer` | Propose counter hourly rate |
| **Negotiation Hub** | `SignalR On` | `ReceiveOfferUpdate` | Live offer status streaming |
| **Admin** | `POST` | `/api/v1/admin/workers/{id}/verify` | Approve or reject KYC docs |

---

## 👥 Demo Quick Login Credentials (Mock Mode)

In **Mock Mode**, you can use any email or the following presets:

| Role | Email | Password | Target Dashboard |
| :--- | :--- | :--- | :--- |
| **Customer** | `customer@example.com` | `Password123!` | Marketplace & Bookings |
| **Worker (Pro)** | `worker@example.com` | `Password123!` | Worker Analytics Hub |
| **Admin** | `admin@kamkar.com` | `Password123!` | KYC Verification Queue |

---

## 📄 License

This project is licensed under the **MIT License**.
See the [LICENSE](LICENSE) file for details.

<div align="center">
Built with ❤️ for the future of skilled trade services.
</div>
