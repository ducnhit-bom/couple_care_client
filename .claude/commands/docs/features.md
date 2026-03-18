Analyze the Flutter project and generate documentation files for each feature under `.claude/docs/features/`.

---

## Steps

### Step 1 — Discover Features

1. Use Glob to scan for feature folders. Check these common patterns in order:
   - `lib/features/*/`
   - `lib/modules/*/`
   - `lib/pages/*/`
   - `lib/screens/*/`
   - If none found, inspect `lib/*/` and filter to folders that contain `.dart` files with widgets/screens (exclude `core/`, `common/`, `shared/`, `utils/`, `config/`, `generated/`, `l10n/`, `theme/`, `di/`, `app/`)
2. Collect the list of feature folder names and paths.
3. If no features found, inform the user and stop.

### Step 2 — Generate Feature Docs (Parallel)

**Spawn one subagent per discovered feature. Launch all subagents in parallel using the Agent tool.**

For each discovered feature, spawn a subagent like this:

```
Agent(subagent_type="soucter", prompt="Use `scout` skill to analyze the [feature-name] feature at [feature-path]. Then create `.claude/docs/features/[feature-name].md` following the doc template below:\n\n[paste Per-Feature Doc Content template]\n\nRules: under 80 lines, only document what exists, use actual class names and file paths, skip .g.dart/.freezed.dart files.", description="Document [feature-name] feature")
```

Each subagent must:

1. Use `scout` skill to discover and read all `.dart` files in the feature folder
2. Create `.claude/docs/features/[feature-name].md` with the content described below

### Per-Feature Doc Content

Each `.claude/docs/features/[feature-name].md` must follow this structure:

```markdown
---
name: [feature-name]
description: [1-line summary of what this feature does, so the agent knows when to reference it]
---

# [Feature Name]

## Overview
[2-3 sentences: what this feature does from a user perspective]

## Screens
| Screen | Class Name | File Path |
|--------|-----------|-----------|
| ... | ... | ... |

## State Management
| Unit | Type | File Path |
|------|------|-----------|
| [e.g. LoginCubit] | [Cubit/Bloc/Provider/...] | [path] |

List state classes and their possible states (e.g. Initial, Loading, Loaded, Error) if detectable.

## Models & Entities
| Model | File Path | Purpose |
|-------|-----------|---------|
| ... | ... | [1-line what it represents] |

## Dependencies
- **Repositories**: [list repository classes this feature depends on]
- **Services**: [list service classes if any]
- **Other features**: [list cross-feature dependencies if any]

## Navigation
- How to reach this feature (route name, path, or navigation call)
- Deep link support (if any)

## Key Business Logic
[Bullet list of the main business rules / flows in this feature. Keep it short — max 5 bullets.]
```

### Rules

- Keep each feature doc **under 80 lines** — concise and scannable
- Only document what actually exists in code, do not speculate
- Use actual class names and file paths from the project
- If a section has nothing to document (e.g. no models), write "None" and move on
- Skip auto-generated files (`.g.dart`, `.freezed.dart`)
- Each subagent must only write to its own feature file — no cross-writes
