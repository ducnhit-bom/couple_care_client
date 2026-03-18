Analyze the Flutter project and generate all documentation files under `.claude/docs/rules/rules`.

**Spawn 8 subagents in parallel, one per step below. Each subagent is responsible for its own analysis and file creation. Do not run them sequentially — launch all 8 at the same time.**

---

## Subagent 1 — Project Architecture

Analyze the project's architecture and folder structure then create project-architecture. Follow this Instruction:
1. Use Glob to find all .dart files
2. Identify the architectural pattern:
   * Clean Architecture (data/domain/presentation layers)
   * Feature-first organization
   * Layer-first organization
   * MVVM, MVC, or other patterns
3. Create `.claude/docs/rules/project-architecture/DOCS.md` with:
   1. Actual layer structure project is using
   2. Actual code flow from UI layer to data layer
   Keep the `DOCS.md` short and concise, only write 3 points mentioned. No other detail needed.

Pattern of DOCS.md file:
```
---
name: project-architecture
description: Reference this document when creating new features, or understanding the project's layer organization and data flow patterns.
---
# Detail information
```

---

## Subagent 2 — Dependency Injection

Analyze how the project manages dependency injection (DI):
1. Use Glob to find related `.dart` files
2. Inspect `pubspec.yaml` for DI-related packages (examples):
   - `get_it`, `injectable`, `riverpod`, `provider`, `flutter_bloc`, `kiwi`, `get`
3. Locate the DI setup entry points (examples):
   - `main.dart`, `app.dart`, `bootstrap.dart`, `locator.dart`, `di.dart`, `injection.dart`
4. Detect DI style:
   - Service Locator (e.g., `GetIt`)
   - Code generation DI (e.g., `injectable`)
   - Provider-based DI (e.g., `Provider`, `Riverpod`)
5. Identify patterns:
   - Module registration structure (core vs feature)
   - Singletons vs factories
   - Environment-based registration (dev/prod)
6. Create `.claude/docs/rules/dependency-injection/DOCS.md` with:
   1. Detected DI library + style
   2. Where registration happens (file paths)
   3. How a new service/repository should be registered (short steps)
   4. Common conventions found (naming, scopes)

Keep the `DOCS.md` short and concise, describing the DI approach used in the project. Only write 4 points mentioned.
```
---
name: dependency-injection
description: Reference this document when creating new cubit, repository, service, or understanding how dependencies are wired in the project.
---
# Detail information
```

---

## Subagent 3 — API Calling

Analyze how the project communicates with APIs:
1. Use Glob to find related `.dart` files that handle calling back-end server. Also inspect `pubspec.yaml` for networking packages (examples): `dio`, `http`, `retrofit`, `chopper`, `graphql`, `json_annotation`, `freezed`
2. Create `.claude/docs/rules/api-calling/DOCS.md`. In `.claude/docs/rules/api-calling` folder create `.claude/docs/rules/api-calling/references/` folder with 2 files:
   - `api_setup.md`: Describe API client setup, includes:
     - Base URL configuration, Interceptors/middleware (auth, logging, retry), Timeout configuration
     - Token storage usage, refresh token flow presence.
   - `api_workflow.md`: Describe API handling patterns from view to actual API calling:
     - Repository pattern for remote data
     - Data sources / Service (e.g., `RemoteDataSource`)
     - How data from API is mapping to Dart object
     - Error handling strategy (exceptions, Either/Result, failure models)

   The `api-calling/DOCS.md` file guides agent to read the correct reference file based on the problem being solved.

Keep all 3 files short and concise, aligned to the project's current API style.
```
---
name: api-calling
description: Reference this document when implementing API calls, creating new endpoints, handling network errors, or working with remote data sources.
---
# Detail information
```

---

## Subagent 4 — Local Storage

Analyze how the project stores data locally:
1. Use Glob to find related `.dart` files that handle local persistence. Also inspect `pubspec.yaml` for storage packages (examples):
   `shared_preferences`, `hive`, `hive_ce`, `isar`, `sqflite`, `drift`, `flutter_secure_storage`, `hydrated_bloc`
2. Create `.claude/docs/rules/local-storage/DOCS.md`. In `.claude/docs/rules/local-storage` folder create `.claude/docs/rules/local-storage/references/` folder with 2 files:
   - `storage_setup.md`: Describe local storage setup, includes:
     - Which local storage library is used (based on project usage)
     - Initialization/configuration location (e.g., `main.dart`, `bootstrap.dart`, `storage.dart`, `db.dart`)
     - Database/box/schema setup (adapters, migrations, table definitions if any)
     - Sensitive storage handling if any (e.g., tokens/credentials in secure storage)
     - Any environment config if any (dev/prod separation, encryption)
   - `storage_workflow.md`: Describe local storage handling patterns from app usage to actual read/write:
     - Where local storage is called from (Repository / DataSource / Service layer)
     - Cache strategy (write-through, read-through, fallback to remote, TTL if exists)
     - How data is mapped to dart object
     - Key naming conventions / box naming conventions / table naming conventions
     - Error handling strategy (exceptions, Result/Either, failure models)

   The `local-storage/DOCS.md` file guides agent to read the correct reference file based on the problem being solved.

Keep all 3 files short and aligned to the project's current Local Storage style.
```
---
name: local-storage
description: *insert suitable description so the agent knows when to use this document*
---
# Detail information
```

---

## Subagent 5 — State Management

Analyze how the project manages UI and business state:
1. Use Glob to find state, view model (cubit, bloc, provider, …), use case `.dart` files
2. Inspect `pubspec.yaml` for state management packages (examples):
   - `flutter_bloc`, `bloc`, `riverpod`, `provider`, `mobx`, `get`, `stacked`
3. Create `.claude/docs/rules/state-management/DOCS.md`. In `.claude/docs/rules/state-management` folder create `.claude/docs/rules/state-management/references/` folder with these files:
   - `state_format.md`: Describe a typical state file in the project:
     - How the state file is named
     - What is the structure of the state file
     - How the state file is set up for different states (Initial, Loading, …)
   - `view_model_format.md` (rename to `cubit_format.md` or `provider_format.md` as appropriate):
     - How the view model file is named
     - How the repositories or other properties are passed to the initialize function of the view model
     - What is the structure of the file, what the structure of a function in view model
   - `use_case.md`, `event.md`, or other files if necessary.

   The `state-management/DOCS.md` file:
   1. Guides agent to read the correct reference file based on the problem being solved.
   2. Describes how the view communicates with the view model, how view model communicates with repository or service.

Keep all files short and aligned to the project's current state management style.
```
---
name: state-management
description: Reference this document when creating or modifying cubits, states, or understanding how UI communicates with business logic in this Flutter project.
---
# Detail information
```

---

## Subagent 6 — UI Crafting

Analyze how the project builds widgets and screens:
1. Use Glob to find view, screen, widget `.dart` files
2. Create `.claude/docs/rules/ui-crafting/DOCS.md`. In `.claude/docs/rules/ui-crafting` folder, create `.claude/docs/rules/ui-crafting/references/` folder with these files:
   1. `theme.md`: Describe how a widget uses font, color and text styles:
      - Focus on how the actual Text widget is styled for text, what is put after textStyles property, how they add color for text, how the widget picks styles for text. Just describe shortly how the actual Text Widget is used.
      - How a background or a button is colored. Just describe shortly how to add a color to a widget exactly like the current code is writing.
      - Is there any pattern for spacing? Does all screens widget follow the same px number for padding? Describe shortly what are most common spacing numbers being used and how the actual widget is using.
   2. `navigation.md`: Describe the navigation system the project uses:
      - Check `pubspec.yaml` files to see if the project uses any navigation package
      - Analyze how the navigation system is written shortly but concisely from real widget:
        - How the navigation system is set up
        - How a screen navigates to another
   3. `translation.md`: Describe how the project supports multi-language (skip if project doesn't support multi-language):
      - Find translation files location (examples): `arb/` files like `intl_en.arb`, `assets/translations/*.json`, generated localization output folder
      - Analyze how translation key is used in actual widget:
        - What is written in `Text(...)` when it is translated? Examples: `S.of(context).title`, `context.tr('key')`, `'key'.tr()`
        - How parameters are passed into translated text (if any)
      - Keep it short, only describe how translation is used in real code.
   4. `assets.md`: Describe how the project loads and uses images/assets:
      - Check pubspec.yaml for asset setup: assets section, fonts, svg/lottie assets, packages like: `flutter_svg`, `cached_network_image`, `lottie`, `rive`
      - Analyze asset usage in real widget: how they load local assets (`Image.asset`, `SvgPicture.asset`, etc.), how they load remote images, where asset path constants are stored (e.g., `AppImages`, `Assets`, `R`)
      - Keep it short and describe only how the current project is doing it.
   5. `form.md`: Describe how the project builds forms and handles input (if any):
      - Analyze how real widgets handle: validation messages, submit flow (button → validate → call action), focus handling (next/done/unfocus), error state display
      - Keep it short and describe only how the current project is doing it. (skip if project doesn't have)
   6. `common_widget.md`: Describe how the project creates and reuses shared UI components:
      - Use Glob to find shared widget folders (examples): `common/`, `shared/`, `widgets/`, `components/`, `ui/`
      - Identify most common reusable components: Buttons, TextField/Input, Dialog, BottomSheet, Loading, Error view, Empty state
      - Just write their class name and 1 line to describe when to use the component.

   The `ui-crafting/DOCS.md` file guides agent to read the correct reference file based on the problem being solved. Use `const` for widget creation if possible.

Keep all files short and aligned to the project's current UI handling style.
```
---
name: ui-crafting
description: Guide for building UI components, screens, and widgets. Reference when creating new screens, styling widgets, handling navigation, adding translations, loading assets, building forms, or reusing common components.
---
# Detail information
```

---

## Subagent 7 — Utilities

Analyze how the project creates and reuses common non-UI helper logic (utilities, extensions, constants):
1. Use Glob to find related `.dart` files that contain reusable logic such as:
   - Utility classes / helpers: `StringUtils`, `DateUtils`, `Validator`, `Formatter`
   - Extensions: `extension StringX on String`, `BuildContext` extensions
   - Mixins / helpers for repeated logic that is pure Dart (no relation to UI or Flutter)
2. Create `.claude/docs/rules/utilities/DOCS.md`. In `.claude/docs/rules/utilities` folder, create `.claude/docs/rules/utilities/references/` folder where for each type (String, Date, …) create a `.md` file:
   - In that file, write the utility class name and list of function names with 1 line describing what each function does.

   The `utilities/DOCS.md` file guides agent to read the correct reference file based on the problem being solved.

Keep all files short and concise, aligned to the project's current utilities files.
```
---
name: utilities
description: Reference when working with utilities/helpers or need to check existing utility functions before creating new ones
---
# Detail information
```

---

## Subagent 8 — Test Writing

Analyze the project's testing approach and create a short agent document for writing tests that match the current project style.
**Skip this step entirely if no tests exist in the project (or project only contains default Flutter test).**

1. Inspect `pubspec.yaml` for test libraries and tools (examples):
   `flutter_test`, `test`, `mocktail`, `mockito`, `bloc_test`, `integration_test`, `golden_toolkit`, `flutter_driver`
2. Use Glob to locate test folders and conventions:
   - `test/`, `integration_test/`
   - naming patterns: `_test.dart`
   - folder structure mirrors `lib/` or feature-based grouping
3. Detect testing types being used:
   - Unit tests (utils, usecases, repository, services)
   - Widget tests (widgets, screens, UI behavior)
   - Integration tests / E2E flows
   - Golden tests (snapshots)
4. Identify common patterns used in real tests:
   - Mocking approach (mocktail/mockito/fakes)
   - Setup/teardown usage
   - Test helpers (e.g., `pumpApp`, `pumpWidgetWithDependencies`, `mockNavigator`, `fakeApi`)
   - Bloc/Riverpod testing patterns (if used)
5. Create `.claude/docs/rules/test-writing/DOCS.md` describing how to write tests following current project patterns:
   - Folder structure and naming rules
   - How a test of a widget, a repository, a view_model, … is written in the project
   - How to mock dependencies (DI + mocks)
   - Common assertion style and naming conventions
   - How to test error/loading/success states

Keep the file short and concise, aligned to the project's current testing style.
```
---
name: test-writing
description: *insert description to help agent know when to read this*
---
# Detail information
```
