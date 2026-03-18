# Stories Media And Storage

## Purpose

Defines backend support for photo and video stories, including upload flows, media processing, storage, and partner delivery.

## Story Types

- Photo stories are available to all eligible couples.
- Video stories are premium-only and require entitlement checks before upload finalization.

## Domain Responsibilities

- Create story records and media metadata.
- Validate entitlements and upload intent.
- Coordinate object storage uploads and derived asset generation.
- Trigger partner notifications and widget refresh signals.

## Upload Flow

- Client requests an upload intent from backend.
- Backend validates auth, couple state, entitlement, file type, and size limits.
- Backend returns a signed upload target.
- Client uploads media directly to object storage.
- Client confirms completion so backend can finalize the story record.

## Media Processing

- Generate thumbnails for photos and videos.
- Extract duration and codec metadata for video and audio validation.
- Normalize media where needed for predictable playback.
- Reject corrupted or unsupported uploads during finalization.

## Story Metadata

- Caption text.
- Optional background music reference.
- Author id and couple id.
- Media type and storage keys.
- Created timestamp and expiry policy if stories are ephemeral.

## Delivery Rules

- New stories should emit realtime events when the partner is connected.
- New stories should enqueue a push notification when the partner is not actively viewing the conversation surface.
- Widget refresh reads should favor processed thumbnails, not raw original assets.

## Storage Rules

- Store originals and derived assets separately.
- Use signed URLs for client downloads when assets are private.
- Run cleanup jobs for abandoned multipart uploads and deleted story assets.

## Primary API Surface

- `POST /v1/stories/upload-intent`
- `POST /v1/stories`
- `GET /v1/stories`
- `GET /v1/stories/{story_id}`
- `DELETE /v1/stories/{story_id}`

## Cross-References

- Frontend stories behavior: `../frontend/04-stories.md`
- Frontend widget behavior: `../frontend/07-widgets-ios-android.md`
