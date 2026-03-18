# Codebase Understanding Phase

**When to skip:** If provided with scout reports, skip this phase.

## Core Activities

### Parallel Scout Agents
- Use `/scout` command to search the codebase for files needed to complete the task
- Each scout locates files needed for specific task aspects
- Wait for all scout agents to report back before analysis
- Efficient for finding relevant code across large codebases

### Essential Documentation Review
ALWAYS read `DOCS.MD` files in these folder `.claude/docs/rules/rules/project-architecture/`, `.claude/docs/rules/dependency-injection/`, `.claude/docs/rules/api-calling/`, `.claude/docs/rules/local-storage/`, `.claude/docs/rules/state-management/`, `.claude/docs/rules/ui-crafting/`, `.claude/docs/rules/utilities/`. Read the detail of the rule whenever the task is necessary 

### Flutter Project Analysis
- Review `pubspec.yaml`: dependencies, SDK constraints, assets, fonts, scripts
- Check `analysis_options.yaml` for lint rules and custom lint packages
- Review `build.yaml` for code generation config (build_runner, freezed, json_serializable)
- Check flavor/environment setup (`--dart-define`, `.env` with `flutter_dotenv`, `--flavor`)
- Review `l10n.yaml` for localization configuration
- Analyze platform directories: `android/build.gradle`, `ios/Podfile`, `web/index.html`, `macos/`, `linux/`, `windows/`
- Check CI/CD config (Fastlane, Codemagic, GitHub Actions workflows)
- Review `devtools_options.yaml` if present

### Project Structure Analysis
- Identify architecture pattern (Clean Architecture, MVC, MVVM, feature-first, layer-first)
- Map `lib/` directory structure and module boundaries
- Identify code generation usage (freezed, json_serializable, auto_route, injectable, mockito)
- Check for monorepo setup (melos, very_good_cli)
- Review test structure (`test/`, `integration_test/`, `test_driver/`)
- Identify flavor/build variant configuration

### Pattern Recognition
- Study existing patterns in codebase
- Identify conventions and architectural decisions
- Note consistency in implementation approaches
- Understand error handling patterns
- Identify state management patterns used per feature

### Integration Planning
- Identify how new features integrate with existing architecture
- Map dependencies between components
- Understand data flow and state management
- Consider backward compatibility with existing features

## Best Practices

- Start with `.claude/docs/rules/` and `pubspec.yaml` before diving into code
- Use scouts for targeted file discovery
- Document patterns found for consistency
- Note any inconsistencies or technical debt
- Consider impact on existing features
