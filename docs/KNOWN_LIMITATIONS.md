# Kamkar Known Backend & System Limitations

As mandated by rule #7 and #30 in `KAMKAR.md`, this document tracks behavior where backend contracts are pending or require specific local development environment configurations without inventing unsupported behavior.

1. **Direct SignalR in Web Worker without SSL**:
   - SignalR WebSockets require secure WebSocket `wss://` when running over HTTPS. In local debug, `ws://` is supported.

2. **Cloudinary Direct Upload vs Server-Side Proxy**:
   - If direct signed Cloudinary parameters are omitted by backend, fallback to multi-part form upload on `/onboarding/upload-document`.

3. **Google Sign-In Web Client ID**:
   - Requires Google Developer Console OAuth 2.0 Web Client ID configured in app environment settings.
