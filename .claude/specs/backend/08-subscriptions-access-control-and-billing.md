# Subscriptions Access Control And Billing

## Purpose

Defines subscription-backed entitlements, premium access checks, and mobile billing validation.

## Supported Plans

- Monthly.
- Yearly.
- Lifetime.

## Premium Entitlements

- Archive memories during break mode.
- Block partner.
- Video stories.
- Extended text messages beyond 100 characters.
- Extended voice messages up to 60 seconds.
- Video calls.

## Domain Responsibilities

- Persist subscription state and entitlement snapshots.
- Validate purchase receipts or server notifications from mobile app stores.
- Expose a consistent access-control layer used by all feature modules.
- Handle expiration, renewal, cancellation, grace period, and lifetime ownership semantics.

## Access Control Rules

- Every premium-gated write path must perform a server-side entitlement check.
- Frontend gating improves UX but never replaces backend enforcement.
- Entitlement responses should be cacheable for short windows but sourced from durable records.

## Billing Integration Strategy

- App Store purchases should be verified through App Store Server APIs or notifications.
- Google Play purchases should be verified through Google Play Developer APIs or real-time developer notifications.
- Web billing should remain optional and separate from mobile-native subscription flows.

## Data To Track

- Provider source.
- Product id.
- Original transaction id or purchase token.
- Current entitlement status.
- Renewal and expiration timestamps.
- Last verification timestamp.

## Failure Handling

- If verification is temporarily unavailable, use the last known valid entitlement with conservative expiry rules.
- Never grant permanent premium access from unverified client claims.
- Log billing mismatches for manual investigation.

## Primary API Surface

- `GET /v1/subscriptions/me`
- `POST /v1/subscriptions/verify/apple`
- `POST /v1/subscriptions/verify/google`
- `POST /v1/subscriptions/webhook/apple`
- `POST /v1/subscriptions/webhook/google`

## Cross-References

- Frontend premium behavior: `../frontend/08-subscription-model-and-premium-access.md`
- Frontend relationship and communication gates: `../frontend/02-couple-profile-and-relationship-management.md`, `../frontend/05-direct-messaging-and-calls.md`
