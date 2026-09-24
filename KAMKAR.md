# KAMKAR — Flutter Mobile App Master Execution & Architecture Plan

> Master execution plan and single source of truth for the Kamkar Flutter application.
> Built following the ASP.NET Core 8 backend API (`/api/v1`), Angular 19 web behavior, and the Premium UI/UX Design System Blueprint.

---

## 0. Source of Truth & Architecture Overview

- **Backend API Base**: `/api/v1`
- **Default Local API**: `http://localhost:5294/api/v1` (iOS Simulator / Web), `http://10.0.2.2:5294/api/v1` (Android Emulator)
- **Realtime SignalR Hub**: `/hubs/negotiate`
- **State Management & Routing**: GetX (`GetxController`, `GetPage`, `Bindings`)
- **Networking**: Dio with interceptors (JWT bearer, automatic 401 token refresh, error formatting)
- **Realtime**: `signalr_netcore` singleton client for live negotiation chat & notifications
- **Secure Persistence**: `FlutterSecureStorage` for access/refresh tokens, `SharedPreferences` for UI preferences (theme, language)
- **Design System**: Outfit + Plus Jakarta Sans typography, Indigo Electric brand palette, double borders, colored soft shadows, `flutter_animate` micro-interactions, Lottie animations with shimmer fallbacks.

---

## 1. Documentation Index

- [docs/API_CONTRACT.md](file:///Users/satwindersingh/Desktop/satwinder_ws/Flutter_Project_24_Sep/Kamkar/docs/API_CONTRACT.md) - Complete endpoints, parameters, DTOs, and error codes.
- [docs/ARCHITECTURE.md](file:///Users/satwindersingh/Desktop/satwinder_ws/Flutter_Project_24_Sep/Kamkar/docs/ARCHITECTURE.md) - Layered clean architecture (`View -> Controller -> Repository -> RemoteDataSource -> Dio/SignalR`).
- [docs/FEATURE_MAP.md](file:///Users/satwindersingh/Desktop/satwinder_ws/Flutter_Project_24_Sep/Kamkar/docs/FEATURE_MAP.md) - Role-by-role feature mapping across Guest, Customer, Worker, Organisation, Admin.
- [docs/SETUP.md](file:///Users/satwindersingh/Desktop/satwinder_ws/Flutter_Project_24_Sep/Kamkar/docs/SETUP.md) - Environment config, running emulator/simulator/device.
- [docs/TESTING.md](file:///Users/satwindersingh/Desktop/satwinder_ws/Flutter_Project_24_Sep/Kamkar/docs/TESTING.md) - Automated unit, widget, and integration test specifications.
- [docs/KNOWN_LIMITATIONS.md](file:///Users/satwindersingh/Desktop/satwinder_ws/Flutter_Project_24_Sep/Kamkar/docs/KNOWN_LIMITATIONS.md) - Explicit non-faked backend gaps.
- [docs/IMPLEMENTATION_STATUS.md](file:///Users/satwindersingh/Desktop/satwinder_ws/Flutter_Project_24_Sep/Kamkar/docs/IMPLEMENTATION_STATUS.md) - Real-time phase-by-phase completion matrix.

---

## 2. Roles & Access Matrix

| Role | Access Scope | Initial Route After Login |
|---|---|---|
| **Guest** | Marketplace search, catalog browsing, worker details | `/marketplace` |
| **Customer** | Bookings, negotiation chat, reviews, customer dashboard, profile | `/customer/dashboard` or `/main` |
| **Worker** | Onboarding/docs submit, worker dashboard, services, job requests, chat | `/worker/dashboard` (or `/worker/pending-approval` if unapproved) |
| **Organisation** | Bulk worker management, organisation dashboard, booking requests | `/organisation/dashboard` |
| **Admin** | Worker verification queue, document inspection, approve/reject | `/admin/verifications` |

---

## 3. Sequential Execution Phases

1. **Phase 0** — Repository Reconnaissance & Documentation Specifications
2. **Phase 1** — Flutter Foundation & Core Architecture (Theme, Network, Secure Storage, Routes)
3. **Phase 2** — Authentication & Session (Login, Register, OTP Verification, Google Auth, Auto-Refresh)
4. **Phase 3** — Catalog & Marketplace (Search, Worker Types, Categories, Filters, Worker Cards & Details)
5. **Phase 4** — Customer Booking (Create Booking, Date/Time Picker, Status Tracking, Booking Detail)
6. **Phase 5** — Worker Onboarding & Worker Hub (Profile, Services, Document Uploads, Pending Approval, Worker Hub)
7. **Phase 6** — Negotiation & Realtime Chat (SignalR Hub `/hubs/negotiate`, Live Messaging, Rate Negotiation)
8. **Phase 7** — Notifications (Live In-App Notifications, Badge Counts, Read State)
9. **Phase 8** — Customer Dashboard (Upcoming Bookings, Quick Actions, Activity Stats)
10. **Phase 9** — Organisation Management (Org Registration & Workforce Dashboard)
11. **Phase 10** — Reviews & Ratings (Review Eligibility, Star Ratings, Verified Worker Reviews)
12. **Phase 11** — User Settings (Theme Toggle, Language Switcher - English / Arabic, Profile Settings)
13. **Phase 12** — Admin Verification (Pending Worker Verifications, Document Inspection, Approve/Reject)
14. **Phase 13-22** — Cross-Cutting UX, Responsive Polish, Performance, Security & Automated Testing
