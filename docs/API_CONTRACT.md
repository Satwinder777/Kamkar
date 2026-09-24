# Kamkar API Contract Specification

Base URL: `/api/v1`  
Realtime Hub: `/hubs/negotiate`

---

## 1. Authentication & User Management (`/auth`)

### POST `/auth/register`
- **Description**: Register a new user (Customer, Worker, Organisation).
- **Request Body**:
  ```json
  {
    "email": "user@example.com",
    "password": "Password123!",
    "fullName": "John Doe",
    "phoneNumber": "+1234567890",
    "role": "Customer" // "Customer" | "Worker" | "Organisation"
  }
  ```
- **Response (200 OK)**:
  ```json
  {
    "success": true,
    "message": "OTP sent to email",
    "userId": "guid-here",
    "requiresOtp": true
  }
  ```

### POST `/auth/verify-otp`
- **Description**: Verify 6-digit email OTP.
- **Request Body**:
  ```json
  {
    "email": "user@example.com",
    "otp": "123456"
  }
  ```
- **Response (200 OK)**:
  ```json
  {
    "accessToken": "jwt-access-token",
    "refreshToken": "jwt-refresh-token",
    "expiresAt": "2026-09-25T12:00:00Z",
    "user": {
      "id": "guid-here",
      "email": "user@example.com",
      "fullName": "John Doe",
      "role": "Customer",
      "isProfileComplete": false,
      "verificationStatus": "Pending" // "Pending" | "Approved" | "Rejected"
    }
  }
  ```

### POST `/auth/login`
- **Description**: Authenticate with email and password.
- **Request Body**:
  ```json
  {
    "email": "user@example.com",
    "password": "Password123!"
  }
  ```
- **Response (200 OK)**: Same as `/auth/verify-otp`.

### POST `/auth/google`
- **Description**: Authenticate using Google ID token.
- **Request Body**:
  ```json
  {
    "idToken": "google-oauth-token-string"
  }
  ```

### POST `/auth/refresh-token`
- **Description**: Refresh expired JWT access token.
- **Request Body**:
  ```json
  {
    "refreshToken": "existing-refresh-token"
  }
  ```
- **Response (200 OK)**:
  ```json
  {
    "accessToken": "new-jwt-access-token",
    "refreshToken": "new-refresh-token"
  }
  ```

---

## 2. Catalog & Worker Marketplace (`/catalog`, `/workers`)

### GET `/catalog/worker-types`
- Returns all supported trade categories (e.g. Electrician, Plumber, Carpenter, Painter, HVAC Technician).

### GET `/catalog/services?workerTypeId={id}`
- Returns specific services offered under a worker type with standard baseline rates.

### GET `/workers/search`
- **Query Params**: `query`, `workerTypeId`, `minRating`, `maxHourlyRate`, `city`, `isAvailable`, `page`, `pageSize`
- **Response**: Paginated list of `WorkerProfile` items.

### GET `/workers/{id}`
- Returns detailed worker profile including verified credentials, services, hourly rates, portfolio photos, and reviews summary.

---

## 3. Bookings (`/bookings`)

### POST `/bookings`
- **Request Body**:
  ```json
  {
    "workerId": "guid-here",
    "serviceId": "guid-service-here",
    "scheduledDate": "2026-09-28T10:00:00Z",
    "address": "123 Main St, City",
    "notes": "Emergency pipe leak",
    "negotiatedRate": 50.0
  }
  ```

### GET `/bookings/my-bookings`
- Returns customer or worker bookings filtered by role & status (`Pending`, `Confirmed`, `InProgress`, `Completed`, `Cancelled`).

### GET `/bookings/{id}`
- Detailed booking timeline, agreed rate, worker info, and action states.

### PUT `/bookings/{id}/status`
- Update status based on actor authorization (e.g. Worker confirms/starts/completes; Customer cancels).

---

## 4. Realtime Negotiation & Chat (`/negotiate`, `/hubs/negotiate`)

### Hub Methods (SignalR):
- `JoinThread(string threadId)`
- `SendMessage(string threadId, string message, decimal? proposedRate)`
- `AcceptNegotiationRate(string threadId, decimal agreedRate)`

### SignalR Client Listeners:
- `MessageReceived(ChatMessage message)`
- `NegotiationRateUpdated(string threadId, decimal rate, string status)`
- `NotificationReceived(AppNotification notification)`

---

## 5. Worker Onboarding & Admin Verification (`/onboarding`, `/admin`)

### POST `/onboarding/worker-profile`
- Complete worker profile, trade selection, experience years, hourly baseline.

### POST `/onboarding/upload-document`
- Upload ID proof, trade certifications, license documents.

### GET `/admin/verifications`
- Admin queue of pending worker applications with document URLs.

### POST `/admin/verifications/{workerId}/decision`
- **Request Body**: `{ "isApproved": true, "rejectionReason": null }`
