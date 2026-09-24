# Kamkar Feature Traceability Map

| ID | Feature Name | Source Backend Area | Flutter Module & Screen | Allowed Roles |
|---|---|---|---|---|
| **AUTH-01** | User Registration | `/auth/register` | `auth/RegisterView` | Guest |
| **AUTH-02** | Email OTP Verification | `/auth/verify-otp` | `auth/OtpVerificationView` | Guest |
| **AUTH-03** | Email/Password Login | `/auth/login` | `auth/LoginView` | Guest |
| **AUTH-04** | Google OAuth Login | `/auth/google` | `auth/LoginView` | Guest |
| **AUTH-05** | Refresh JWT Token | `/auth/refresh-token` | `core/network/api_client` | All |
| **AUTH-06** | Logout & Cache Clear | `/auth/logout` | `modules/settings` | All |
| **AUTH-07** | Onboarding Status Check | `/users/me/status` | `auth/SplashView` | All |
| **AUTH-08** | Complete User Profile | `/users/me/profile` | `auth/CompleteProfileView` | Uncompleted |
| **AUTH-09** | Pending Approval Screen | `/worker/status` | `worker/PendingApprovalView` | Worker (Pending) |
| **MARKET-01** | Worker Live Search | `/workers/search` | `marketplace/WorkerSearchView` | Guest, Customer |
| **MARKET-02** | Worker Types Catalog | `/catalog/worker-types` | `marketplace/ExploreView` | Guest, Customer |
| **MARKET-03** | Services by Type | `/catalog/services` | `marketplace/ExploreView` | Guest, Customer |
| **MARKET-04** | Multi-Factor Filter Sheet | `/workers/search` | `marketplace/FilterBottomSheet` | Guest, Customer |
| **MARKET-05** | Worker Profile & Detail | `/workers/{id}` | `marketplace/WorkerDetailView` | Guest, Customer |
| **MARKET-06** | Worker Portfolio Photos | `/workers/{id}/photos` | `marketplace/WorkerDetailView` | Guest, Customer |
| **BOOK-01** | Create Booking Request | `/bookings` (POST) | `booking/CreateBookingView` | Customer |
| **BOOK-02** | Booking Confirmation Screen | `/bookings/{id}` | `booking/BookingConfirmationView` | Customer |
| **BOOK-03** | My Bookings List | `/bookings/my-bookings` | `booking/BookingListView` | Customer, Worker |
| **BOOK-04** | Booking Timeline & Actions | `/bookings/{id}` | `booking/BookingDetailView` | Customer, Worker |
| **CHAT-01** | Negotiation Threads List | `/negotiate/threads` | `chat/ConversationListView` | Customer, Worker |
| **CHAT-02** | Thread Message History | `/negotiate/threads/{id}` | `chat/ChatDetailView` | Customer, Worker |
| **CHAT-03** | Realtime Messaging | `/negotiate` & SignalR | `chat/ChatDetailView` | Customer, Worker |
| **CHAT-04** | Rate Negotiation Offer | `/negotiate/offer` | `chat/ChatDetailView` | Customer, Worker |
| **NOTIF-01** | Notifications Inbox | `/notifications` | `notifications/NotificationListView` | Customer, Worker, Org |
| **NOTIF-02** | Mark As Read | `/notifications/{id}/read`| `notifications/NotificationListView` | Customer, Worker, Org |
| **NOTIF-03** | Realtime Notification Pop | SignalR `NotificationReceived` | `core/widgets/app_overlay` | All |
| **WORK-01** | Worker Onboarding Wizard | `/onboarding/worker` | `worker/WorkerOnboardingView` | Worker |
| **WORK-02** | Worker Document Uploads | `/onboarding/documents` | `worker/WorkerDocumentsView` | Worker |
| **WORK-03** | Worker Service Config | `/worker/services` | `worker/WorkerServicesView` | Worker |
| **WORK-04** | Worker Earnings Dashboard | `/dashboards/worker` | `worker/WorkerDashboardView` | Worker |
| **WORK-05** | Worker Job Dispatch Actions | `/bookings/{id}/status` | `worker/WorkerBookingsView` | Worker |
| **CUSTOMER-01**| Customer Hub Dashboard | `/dashboards/customer` | `customer/CustomerDashboardView`| Customer |
| **CUSTOMER-02**| Customer Profile Settings | `/customers/me` | `customer/CustomerProfileView` | Customer |
| **ORG-01** | Organisation Registration | `/organisations/register`| `organisation/OrgRegisterView` | Organisation |
| **ORG-02** | Organisation Dashboard | `/dashboards/organisation`| `organisation/OrgDashboardView` | Organisation |
| **REVIEW-01** | Submit Worker Review | `/reviews` (POST) | `reviews/CreateReviewModal` | Customer |
| **REVIEW-02** | View Worker Reviews | `/reviews/worker/{id}` | `reviews/WorkerReviewsView` | All |
| **SET-01** | User Theme & Language | `/users/me/settings` | `settings/UserSettingsView` | All |
| **ADMIN-01** | Worker Verification Queue | `/admin/verifications` | `admin/AdminVerificationListView` | Admin |
| **ADMIN-02** | Worker Verification Detail | `/admin/verifications/{id}`| `admin/AdminVerificationDetailView`| Admin |
| **ADMIN-03** | Approve Worker Application | `/admin/verifications/{id}/approve` | `admin/AdminVerificationDetailView`| Admin |
| **ADMIN-04** | Reject Worker Application | `/admin/verifications/{id}/reject` | `admin/AdminVerificationDetailView`| Admin |
