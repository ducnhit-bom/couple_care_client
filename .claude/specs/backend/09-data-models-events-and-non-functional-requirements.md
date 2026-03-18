# Data Models Events And Non-Functional Requirements

## Purpose

Defines shared backend data primitives, event taxonomy, and quality requirements that cut across all domains.

## Canonical Core Entities

- User.
- Device.
- Couple.
- Pairing invite.
- Emotional state.
- Story.
- Media asset.
- Conversation.
- Message.
- Call session.
- Notification preference.
- Push device token.
- Streak snapshot.
- Memory item.
- Subscription.
- Entitlement snapshot.

## Event Taxonomy

- Authentication events: signed in, refreshed, revoked, provider linked.
- Couple events: paired, updated, break enabled, break disabled, blocked, deleted.
- Presence events: online, offline, emotional state updated.
- Story events: upload requested, published, deleted.
- Messaging events: sent, delivered, seen, call started, call ended.
- Engagement events: streak updated, inactivity detected, mood swing detected, memory generated.
- Billing events: purchase verified, renewed, expired, revoked.

## Consistency Guidelines

- PostgreSQL is the source of truth for durable records.
- Redis is best-effort and must be reconstructable from canonical data.
- Async event consumers must be idempotent.
- Public API writes should return only after canonical persistence succeeds.

## Security Requirements

- Encrypt data in transit and at rest where supported by infrastructure.
- Store secrets outside the codebase.
- Limit access to private couple data strictly to the linked pair and authorized operators.
- Audit destructive actions, auth changes, and premium state changes.

## Privacy Requirements

- Default all couple content to private.
- Minimize retention of sensitive derived data that is not needed for product value.
- Support account or relationship deletion workflows that cascade to associated data.

## Observability Requirements

- Structured logs for API, websocket, worker, and billing flows.
- Metrics for request latency, websocket connections, queue depth, notification delivery, and media processing outcomes.
- Error tracking for failed jobs, failed receipt verification, and degraded realtime delivery.

## Performance And Scale Expectations

- Support low-latency partner updates for presence and messaging.
- Avoid loading raw media through the API server when direct object storage access is possible.
- Prepare for horizontal scale by keeping websocket fanout and ephemeral state Redis-backed.

## Reliability Expectations

- Background jobs should support retries with backoff.
- Realtime outages must degrade to fetch-based recovery without data loss.
- Media processing failures should not corrupt the original upload state.

## Suggested Initial Database Tables

- `users`
- `devices`
- `couples`
- `pairing_invites`
- `emotional_states`
- `stories`
- `media_assets`
- `conversations`
- `messages`
- `call_sessions`
- `notification_preferences`
- `push_tokens`
- `streaks`
- `memory_items`
- `subscriptions`
- `entitlements`

## Cross-References

- Frontend domain behavior index: `../frontend/README.md`
- Backend platform overview: `./01-system-overview-and-architecture.md`
