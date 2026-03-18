# Emotional Status And Presence

## Purpose

Defines the backend model for status, mood, energy, and live presence sharing between partners and widgets.

## Domain Responsibilities

- Persist the latest durable emotional state for each user.
- Distribute low-latency updates to the partner and eligible widget read models.
- Distinguish between durable emotional signals and ephemeral online presence.

## Data Model

- `status`: short controlled or custom label such as busy, sleeping, or in a meeting.
- `mood`: controlled or custom emotional label.
- `energy`: integer percentage from 0 to 100.
- `presence`: ephemeral state such as online, offline, idle, or recently active.
- `updated_at`: server timestamp used for ordering and freshness.

## Write Rules

- Validate energy range strictly between 0 and 100.
- Allow custom mood or status labels within safe length limits.
- Debounce or rate-limit frequent client updates to reduce noisy writes.
- Persist only the latest state unless historical mood tracking is explicitly introduced later.

## Delivery Rules

- Partner should receive near-real-time updates through websocket when connected.
- Offline partner should receive the latest state on next API fetch.
- Widget read models may be refreshed from a compact denormalized store or cached API projection.

## Presence Strategy

- Presence is stored in Redis with TTL-based expiry.
- Heartbeats extend TTL while a websocket session is active.
- Presence loss due to disconnect should degrade gracefully to recently active before offline.

## Notification Hooks

- Large energy drops or significant mood changes can emit engagement events for notification policies.
- Notification policies must be throttled to avoid over-alerting.

## Primary API Surface

- `GET /v1/presence/partner`
- `PUT /v1/me/emotional-state`
- `GET /v1/me/emotional-state`
- `GET /v1/partner/emotional-state`
- `WS /v1/realtime`

## Cross-References

- Frontend emotional system: `../frontend/03-emotional-status-system.md`
- Frontend widget behavior: `../frontend/07-widgets-ios-android.md`
