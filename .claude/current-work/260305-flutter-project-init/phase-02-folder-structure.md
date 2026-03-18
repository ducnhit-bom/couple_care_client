# Phase 2: Folder Structure & Linting

## Context
- Research report: [research-report.md](./research-report.md)
- Priority: P1 | Status: Pending

## Overview

Create feature-first Clean Architecture folder structure and configure linting rules.

## Implementation Steps

### 1. Create Directory Structure

Run from project root `/Users/baonguyen/Desktop/training/devops/cc`:

```bash
# Core directories
mkdir -p lib/core/config
mkdir -p lib/core/constants
mkdir -p lib/core/errors
mkdir -p lib/core/network
mkdir -p lib/core/providers
mkdir -p lib/core/utils
mkdir -p lib/core/extensions

# Feature template (auth as first feature)
mkdir -p lib/features/auth/data/datasources
mkdir -p lib/features/auth/data/models
mkdir -p lib/features/auth/data/repositories
mkdir -p lib/features/auth/domain/entities
mkdir -p lib/features/auth/domain/usecases
mkdir -p lib/features/auth/presentation/providers
mkdir -p lib/features/auth/presentation/pages
mkdir -p lib/features/auth/presentation/widgets

# Shared presentation
mkdir -p lib/shared/widgets
mkdir -p lib/shared/theme

# Router
mkdir -p lib/router
```

### 2. Create .gitkeep Files

Add `.gitkeep` in every empty directory so they are tracked by git. Example:

```bash
find lib -type d -empty -exec touch {}/.gitkeep \;
```

### 3. Final Structure

```
lib/
├── core/
│   ├── config/
│   │   ├── environment.dart
│   │   └── app_config.dart
│   ├── constants/
│   │   └── api_constants.dart
│   ├── errors/
│   │   ├── failures.dart
│   │   ├── exceptions.dart
│   │   └── error_handler.dart
│   ├── network/
│   │   ├── dio_client.dart
│   │   ├── api_interceptor.dart
│   │   └── auth_interceptor.dart
│   ├── providers/
│   │   └── core_providers.dart
│   ├── utils/
│   │   └── logger.dart
│   └── extensions/
│       └── .gitkeep
├── features/
│   └── auth/
│       ├── data/
│       │   ├── datasources/
│       │   ├── models/
│       │   └── repositories/
│       ├── domain/
│       │   ├── entities/
│       │   └── usecases/
│       └── presentation/
│           ├── providers/
│           ├── pages/
│           └── widgets/
├── shared/
│   ├── widgets/
│   └── theme/
│       └── app_theme.dart
├── router/
│   └── app_router.dart
└── main.dart
```

### 4. Configure analysis_options.yaml

**File:** `/Users/baonguyen/Desktop/training/devops/cc/analysis_options.yaml` (modify)

```yaml
include: package:flutter_lints/flutter.yaml

analyzer:
  errors:
    invalid_annotation_target: ignore
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"

linter:
  rules:
    - always_declare_return_types
    - annotate_overrides
    - avoid_empty_else
    - avoid_print
    - avoid_relative_lib_imports
    - avoid_returning_null_for_future
    - cancel_subscriptions
    - close_sinks
    - constant_identifier_names
    - prefer_const_constructors
    - prefer_const_declarations
    - prefer_final_fields
    - prefer_final_locals
    - require_trailing_commas
    - sort_child_properties_last
    - unnecessary_await_in_return
    - unnecessary_const
    - unnecessary_new
    - use_key_in_widget_constructors
```

## Related Code Files
| Action | File |
|--------|------|
| modify | `/Users/baonguyen/Desktop/training/devops/cc/analysis_options.yaml` |
| create | All directories listed above |

## Success Criteria
- All directories exist
- `flutter analyze` runs without configuration errors
- Generated files (*.g.dart, *.freezed.dart) excluded from analysis
