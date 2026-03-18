# Plan Creation & Organization

## Directory Structure

### Plan Location

**Important:**
- DO NOT create plans or reports in USER home directory.
- ALWAYS create plans or reports in the PROJECT's `.claude/current-work/` directory when working within a `current-work` context.

**Path convention:** `.claude/current-work/[YYMMDD]-[feature-slug]/`

**Example:** `.claude/current-work/260301-product-catalog/` or `.claude/current-work/260215-auth-refactor/`

### File Organization

```
.claude/current-work/[YYMMDD]-[feature-slug]/
├── research-report.md
├── plan.md
├── phase-01-models-entities.md
├── phase-02-data-layer.md
├── ...
├── implementation-report.md
├── code-review-report.md
├── test-plan.md
└── test-report.md
```

### Active Plan State Tracking

Check if a plan already exists for the current feature:
1. Look for existing plan directories in `.claude/current-work/` matching the feature slug
2. If found → ask "Continue with existing plan? [Y/n]"
3. If not found → create new plan directory

### Overview Plan (plan.md)

**IMPORTANT:** All plan.md files MUST include YAML frontmatter. See `output-standards.md` for schema.

**Example plan.md structure:**
```markdown
---
title: "Offline-First Product Catalog"
description: "Add product catalog with BLoC state management and offline caching"
status: pending
priority: P1
effort: 8h
branch: feat/product-catalog
tags: [feature, bloc, repository, offline]
created: 2025-12-16
---

# Offline-First Product Catalog

## Overview

Brief description of what this plan accomplishes.

## Phases

| # | Phase | Status | Effort | Link |
|---|-------|--------|--------|------|
| 1 | Models & Entities | Pending | 1h | [phase-01](./phase-01-models-entities.md) |
| 2 | Data Layer | Pending | 2h | [phase-02](./phase-02-data-layer.md) |
| 3 | Business Logic | Pending | 2h | [phase-03](./phase-03-business-logic.md) |
| 4 | Screens & Widgets | Pending | 2h | [phase-04](./phase-04-screens-widgets.md) |
| 5 | Navigation & Routing | Pending | 30m | [phase-05](./phase-05-navigation-routing.md) |
| 6 | Testing | Pending | 30m | [phase-06](./phase-06-testing.md) |

## Dependencies

- List key dependencies here
```

**Guidelines:**
- Keep generic and under 80 lines
- List each phase with status/progress
- Link to detailed phase files
- Key dependencies

### Phase Files (phase-XX-name.md)
Each phase file should contain:

**Context Links**
- Links to related reports, files, documentation

**Overview**
- Priority
- Current status
- Brief description

**Key Insights**
- Important findings from research
- Critical considerations

**Requirements**
- Functional requirements
- Non-functional requirements

**Architecture**
- System design
- Component interactions
- Data flow

**Related Code Files**
- List of files to modify
- List of files to create
- List of files to delete

**Implementation Steps**
- Detailed, numbered steps
- Specific instructions

**Todo List**
- Checkbox list for tracking

**Success Criteria**
- Definition of done
- Validation methods

**Risk Assessment**
- Potential issues
- Mitigation strategies

**Security Considerations**
- Secure storage
- Data protection

**Next Steps**
- Dependencies
- Follow-up tasks
