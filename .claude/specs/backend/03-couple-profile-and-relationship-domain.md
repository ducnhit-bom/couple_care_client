# Couple Profile And Relationship Domain

## Purpose

Defines backend ownership for couple identity, personalization metadata, and relationship lifecycle controls.

## Domain Responsibilities

- Store user profile basics used inside the couple space.
- Store couple-level settings such as anniversary date and shared theme preferences.
- Enforce break mode, blocking, archival, and destructive deletion workflows.

## Core Data Owned By This Domain

- User display name and avatar metadata.
- Partner nickname values.
- Couple record linking two users.
- Anniversary date and derived relationship duration inputs.
- Shared theme or presentation preferences when they are persisted server-side.

## Break Mode

- Break mode is a relationship state that temporarily hides shared content from normal client views.
- Archive memories during break mode is a premium capability.
- When break mode is enabled, backend should mark relevant content as hidden from default reads without deleting the underlying records.
- Break mode changes must emit events so timelines, widgets, notifications, and messaging surfaces react consistently.

## Delete Everything

- This is a destructive workflow and must require strong user confirmation.
- Backend should soft-delete first where possible, then run asynchronous hard-delete or retention workflows for media.
- Deletion jobs must cover messages, stories, media references, memory artifacts, and couple-scoped preferences.

## Block Partner

- Blocking is a premium capability.
- Blocking must disable messaging, calling, pairing actions, and most shared updates between the two accounts.
- Existing data remains preserved unless a destructive delete flow is triggered separately.

## Read And Write Rules

- Each partner can update their own profile attributes.
- Couple-scoped settings should use optimistic concurrency or last-write-wins rules defined at the API level.
- Sensitive lifecycle actions must be auditable.

## Primary API Surface

- `GET /v1/me`
- `PATCH /v1/me/profile`
- `GET /v1/couple`
- `PATCH /v1/couple`
- `POST /v1/couple/break`
- `POST /v1/couple/block`
- `POST /v1/couple/delete-all`

## Cross-References

- Frontend profile and relationship behavior: `../frontend/02-couple-profile-and-relationship-management.md`
