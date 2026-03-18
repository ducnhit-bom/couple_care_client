# Engagement Notifications And Memories

## Purpose

Defines backend rules for habit-building systems, push notifications, streak tracking, and shared memory generation.

## Domain Responsibilities

- Detect engagement signals and schedule notification workflows.
- Compute streaks from meaningful couple interactions.
- Aggregate memories and moments from shared content and notable events.
- Provide support APIs for future games or lightweight engagement mechanics.

## Smart Notification Policies

- Low energy notifications may trigger when a partner's energy drops below a configurable threshold.
- Inactivity notifications may trigger when the couple has not interacted within a configured time window.
- Mood swing notifications may trigger when the latest mood differs sharply from recent state or explicit heuristics.
- All notification policies must support cooldowns, quiet hours, and opt-out preferences.

## Streak Rules

- A streak day is counted when at least one qualifying interaction occurs in the couple space.
- Qualifying interactions should be configurable, for example message sent, story posted, or status updated.
- Streak recomputation should run idempotently in background jobs.

## Memories And Moments

- Aggregate stories, media, anniversaries, and other notable milestones into a timeline.
- Support asynchronous backfill when old events are imported or restored.
- Memory records should store references to canonical source entities, not duplicated media payloads.

## Notification Delivery Pipeline

- Backend decides whether to send in-app realtime events, push notifications, or both.
- Push tokens are stored per device and invalid tokens must be pruned automatically.
- Delivery attempts and provider responses should be logged for debugging and analytics.

## Couple Games

- Initial backend support can be limited to configuration, prompts, score submissions, or turn state if games are introduced.
- Do not over-design multiplayer game infrastructure until concrete game mechanics are defined.

## Primary API Surface

- `GET /v1/engagement/streak`
- `GET /v1/memories`
- `GET /v1/notifications/preferences`
- `PATCH /v1/notifications/preferences`
- `POST /v1/devices/push-token`

## Cross-References

- Frontend engagement behavior: `../frontend/06-retention-and-engagement.md`
