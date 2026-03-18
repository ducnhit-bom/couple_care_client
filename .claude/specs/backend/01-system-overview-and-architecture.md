# System Overview And Architecture

## Purpose

Defines the backend shape for a Python-based Couples Connection platform that supports core app flows, realtime communication, media handling, and notification delivery.

## Architectural Style

- Start with a modular monolith to optimize delivery speed and keep operational complexity low.
- Organize the codebase by domain modules: auth, couples, presence, stories, messaging, calls, engagement, subscriptions, notifications, and media.
- Keep domain boundaries explicit so high-load modules can be extracted later if scale requires it.

## Recommended Python Stack

- API framework: FastAPI.
- Persistence: PostgreSQL.
- Cache and short-lived state: Redis.
- Background jobs: Celery with Redis as broker for async workflows.
- ORM and migrations: SQLAlchemy 2.0 and Alembic.
- Validation and serialization: Pydantic.
- Object storage: S3-compatible storage for media assets.

## Core Platform Responsibilities

- Expose authenticated REST APIs for app workflows.
- Expose websocket channels for presence, messaging, and realtime conversation events.
- Store durable relationship, message, media, and subscription data.
- Coordinate async processing for notifications, media transforms, and memory generation.
- Enforce product entitlements and freemium limits consistently across all domains.

## High-Level Components

### API Layer

- Handles mobile requests, validation, authorization, and response shaping.
- Publishes domain events when write operations change shared state.

### Realtime Gateway

- Manages websocket sessions for both partners.
- Broadcasts presence, message delivery updates, typing indicators, and lightweight call signaling.

### Worker Layer

- Processes media transcoding, thumbnail generation, push notification fanout, streak recalculation, and timeline aggregation.

### Storage Layer

- PostgreSQL stores canonical transactional records.
- Redis stores ephemeral presence and delivery coordination state.
- Object storage stores photos, audio, video, and derived media artifacts.

## Initial Deployment Shape

- One FastAPI application for HTTP and websocket traffic.
- One worker process pool for asynchronous jobs.
- One PostgreSQL instance.
- One Redis instance.
- One object storage bucket namespace segmented by environment.

## API Principles

- Prefer resource-oriented REST endpoints for CRUD-style operations.
- Use websocket events only for low-latency updates that would feel stale over polling.
- Use signed upload or download URLs for large media access.
- Version APIs from the start with a prefix such as `/v1`.

## Realtime Principles

- Presence state is soft state and may expire automatically.
- Message state is durable and must be persisted before being acknowledged as sent.
- Call media transport should rely on WebRTC clients; backend only handles signaling, session policy, and access checks.

## Cross-References

- Frontend behavior for user entry and UX: `../frontend/01-introduction-and-onboarding.md`
- Frontend communication behaviors: `../frontend/04-stories.md`, `../frontend/05-direct-messaging-and-calls.md`
