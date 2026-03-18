# Messaging Realtime And Calls

## Purpose

Defines backend support for private couple messaging, voice notes, realtime sync, and video call signaling.

## Messaging Capabilities

- Text messages are available by default with a 100-character limit for non-premium users.
- Premium unlock removes the default short-text restriction.
- Voice messages are available by default up to 10 seconds.
- Premium unlock extends voice message duration up to 60 seconds.
- Video calls require premium access.

## Domain Responsibilities

- Persist conversations and message delivery state.
- Fan out realtime events for sent, delivered, seen, typing, and presence updates.
- Enforce message length and voice-duration entitlements.
- Coordinate lightweight signaling for call setup and teardown.

## Message Model

- Each message belongs to one couple conversation.
- Store sender id, message type, content metadata, created timestamp, and delivery state.
- Voice messages store media metadata and object storage references rather than binary payloads in PostgreSQL.

## Delivery States

- `sent`: stored durably by backend.
- `delivered`: pushed to at least one recipient session.
- `seen`: explicitly acknowledged by recipient client.

## Realtime Event Types

- New message.
- Message updated or deleted.
- Typing started or stopped.
- Delivery state changed.
- Presence changed.
- Call invite, accept, reject, cancel, and end.

## Call Signaling Rules

- Backend handles authentication, entitlement checks, and call session state.
- Media transport is client-side WebRTC using STUN or TURN infrastructure.
- Call signaling events should expire quickly if not accepted.
- Backend should prevent concurrent conflicting call sessions for the same couple.

## Anti-Abuse And Reliability

- Rate-limit message sends and call invite spam.
- Ensure websocket reconnect can replay missed events using last-known cursor or message fetch APIs.
- Keep durable history in PostgreSQL regardless of websocket connectivity.

## Primary API Surface

- `GET /v1/conversations/current`
- `GET /v1/messages`
- `POST /v1/messages`
- `POST /v1/messages/voice/upload-intent`
- `POST /v1/messages/{message_id}/seen`
- `POST /v1/calls/session`
- `POST /v1/calls/{session_id}/accept`
- `POST /v1/calls/{session_id}/reject`
- `POST /v1/calls/{session_id}/end`
- `WS /v1/realtime`

## Cross-References

- Frontend communication behavior: `../frontend/05-direct-messaging-and-calls.md`
