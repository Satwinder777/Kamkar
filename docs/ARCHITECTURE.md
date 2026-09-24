# Kamkar Flutter Architecture Document

## 1. Architectural Philosophy
Kamkar is built using clean, modular GetX architecture structured for maintainability, high testability, and separation of concerns.

```text
lib/
├── core/
│   ├── config/          # Environment & app configuration
│   ├── constants/       # API endpoints, Lottie URLs, App constants
│   ├── errors/          # AppException, Failure models, error parser
│   ├── localization/    # English & Arabic translation dictionaries
│   ├── network/         # Dio client, Auth interceptor, SignalR service
│   ├── routes/          # AppRoutes & AppPages navigation map
│   ├── storage/         # FlutterSecureStorage & SharedPreferences
│   ├── theme/           # AppColors, AppTextTheme, AppTheme
│   ├── utils/           # Formatters, haptic triggers, form validators
│   └── widgets/         # Design system components (CustomButton, Badges, LottieView, NavBar, etc.)
├── data/
│   ├── models/          # Strongly typed JSON serializable DTOs
│   ├── datasources/     # Remote API datasources (Dio calls)
│   └── repositories/    # Repositories bridging controllers with datasources
└── modules/
    ├── auth/            # Splash, Login, Register, OTP, Complete Profile, Pending Approval
    ├── marketplace/     # Explore, Search, Worker Detail, Filter Sheet
    ├── booking/         # Create Booking, My Bookings, Booking Detail
    ├── chat/            # Live Negotiation Chat & Thread List (SignalR)
    ├── notifications/   # In-app notifications & unread badges
    ├── customer/        # Customer Dashboard & Profile
    ├── worker/          # Worker Dashboard, Onboarding, Documents, Services
    ├── organisation/    # Organisation Register & Dashboard
    ├── reviews/         # Worker reviews & Submit review modal
    ├── settings/        # Theme switcher, Language switcher (en/ar)
    └── admin/           # Admin Verification Queue & Worker Approval
```

---

## 2. Layer Responsibilities

1. **View (UI Layer)**:
   - Stateless or GetView widgets.
   - Consumes theme tokens (`AppColors`, `AppTextTheme`).
   - Micro-animations via `flutter_animate`.
   - Never calls API directly; interacts only via controller.

2. **GetX Controller (Presentation Logic)**:
   - Holds observable reactive state (`Rx<T>`, `RxList`, `RxBool`).
   - Handles user interactions, form validation, and lifecycle.
   - Calls Repository methods and handles loading/error states.

3. **Repository (Data Abstraction)**:
   - Aggregates remote datasources and local storage.
   - Enforces business logic and model transformations.

4. **Remote DataSource & Network Layer**:
   - Executes HTTP calls via configured `Dio` client.
   - Handles SignalR connections via `SignalRService`.
   - Attaches Bearer authorization token and refreshes on 401.

5. **Design System & Micro-Interactions**:
   - Google Fonts pairing: **Outfit** (Display / Headers) + **Plus Jakarta Sans** (Body).
   - Soft colored shadows with `color.withValues(alpha: 0.12)`.
   - 1px subtle borders (`Color(0xFFE2E8F0)`).
   - Consistent corner radii (Cards: 24px, Buttons: 16px, Badges: 8px, BottomSheets: 28px).
   - Resilient Lottie animations with Shimmer fallback.
