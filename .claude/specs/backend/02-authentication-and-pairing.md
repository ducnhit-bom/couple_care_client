# Authentication And Pairing

## Purpose

Defines how identities are created, authenticated, and linked into a private two-person relationship space.

## Supported Authentication Methods

- Google sign-in.
- Apple sign-in.
- Phone number sign-in with OTP verification.

## Account Model

- A user account represents one person across devices.
- A user can belong to at most one active couple relationship at a time.
- Providers may be linked to the same account when verified against trusted identity data.

## Session Model

- Use short-lived access tokens and refresh tokens.
- Support device-scoped sessions so users can revoke a single device without logging out everywhere.
- Record last active timestamp, device type, and push token per session-capable device.

## Pairing Flows

### Code Pairing

- Generate a short alphanumeric invite code tied to the requesting user.
- Code must expire automatically after a short window.
- Confirm both users are not already in separate active couples before completing the link.

### QR Pairing

- QR payload should encode a short-lived pairing token or deep link, not raw personal data.
- Scanning user must confirm pairing before the relationship becomes active.

### Deeplink Pairing

- Deep links resolve to the app, validate the invite token, and show a confirmation screen.
- Expired or already-used links return a recoverable error with a path to request a new invite.

## Pairing Rules

- Pairing is successful only when both users explicitly confirm.
- Backend must reject self-pairing and duplicate active relationships.
- Pairing actions must be idempotent to handle retries from poor network conditions.

## Security Controls

- Rate-limit OTP requests and pairing attempts.
- Hash or securely store one-time pairing tokens.
- Audit authentication, provider linking, and successful or failed pairing events.

## Primary API Surface

- `POST /v1/auth/google`
- `POST /v1/auth/apple`
- `POST /v1/auth/phone/request-otp`
- `POST /v1/auth/phone/verify-otp`
- `POST /v1/pairing/code`
- `POST /v1/pairing/qr`
- `POST /v1/pairing/accept`
- `POST /v1/pairing/reject`

## Cross-References

- Frontend entry and pairing flows: `../frontend/01-introduction-and-onboarding.md`
