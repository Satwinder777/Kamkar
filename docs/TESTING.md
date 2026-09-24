# Kamkar Testing & Quality Assurance

## Automated Test Strategy
The app includes comprehensive testing across all levels:

1. **Unit Tests**:
   - Model JSON serialization and deserialization
   - Business logic validation (phone numbers, emails, passwords, OTP)
   - Status transitions (Booking, Worker verification, Negotiation state)
   - API Client error mapping & token refresh handling

2. **Widget Tests**:
   - Authentication screens (Login, OTP, Register)
   - Marketplace worker card rendering & filters
   - Booking creation flow & custom buttons
   - Empty states with resilient Lottie loaders

3. **Execution**:
   ```bash
   flutter test
   ```
