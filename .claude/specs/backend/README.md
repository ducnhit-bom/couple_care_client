# Backend Specs

This directory is the source of truth for backend architecture, domain ownership, APIs, realtime delivery, storage, notification orchestration, and non-functional requirements for the Couples Connection app.

## Scope

The backend spec follows a hybrid approach:

- Define enough structure to implement an MVP safely.
- Capture the production-facing concerns needed for scaling realtime, media, and notification features later.

## File Index

1. `01-system-overview-and-architecture.md` - System boundaries, deployment shape, and platform-wide backend principles.
2. `02-authentication-and-pairing.md` - Identity, account linking, session management, and couple pairing.
3. `03-couple-profile-and-relationship-domain.md` - Relationship settings, profile ownership, break mode, and block flows.
4. `04-emotional-status-and-presence.md` - Status, mood, energy, presence sync, and widget read models.
5. `05-stories-media-and-storage.md` - Story APIs, uploads, processing, media storage, and delivery rules.
6. `06-messaging-realtime-and-calls.md` - Messaging, websocket events, voice messages, and call signaling responsibilities.
7. `07-engagement-notifications-and-memories.md` - Engagement engine, reminders, streaks, and memory aggregation.
8. `08-subscriptions-access-control-and-billing.md` - Entitlements, billing validation, and feature gating.
9. `09-data-models-events-and-non-functional-requirements.md` - Canonical entities, event taxonomy, security, and scalability expectations.

## Relationship To Frontend Specs

- `../frontend/` describes user-facing behavior.
- `./` describes how backend systems make those experiences possible.
- If there is overlap, frontend files win for UX wording and backend files win for service responsibilities.
