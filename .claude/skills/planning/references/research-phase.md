# Research & Analysis Phase

**When to skip:** If provided with researcher reports, skip this phase.

## Core Activities

### Parallel Researcher Agents
- Spawn multiple `flutter-researcher` agents in parallel to investigate different approaches
- Wait for all researcher agents to report back before proceeding
- Each researcher investigates a specific aspect or approach

### Structured Analysis
- Break down complex Flutter architecture decisions systematically
- Evaluate state management, navigation, and DI choices with pros/cons
- Compare package options using pub.dev metrics (popularity, likes, pub points, maintenance)

### Flutter Documentation Research
- Research packages on pub.dev via WebSearch
- Check Flutter official docs (flutter.dev, api.flutter.dev, dart.dev)
- Review package changelogs and migration guides
- Read `.claude/docs/` project-specific documentation
- Check package examples and README for integration patterns

### GitHub Analysis
- Use `gh` command to read and analyze:
  - GitHub Actions logs
  - Pull requests
  - Issues and discussions
- Clone and analyze reference Flutter implementations when needed
- Use WebFetch to read pub.dev package pages for detailed API docs

### Debugger Delegation
- Delegate to debugger agent for root cause analysis
- Use Flutter DevTools findings for performance investigation
- Analyze `flutter analyze` output for code quality issues
- Review widget inspector findings for layout problems

## Best Practices

- Research breadth before depth
- Document findings for synthesis phase
- Identify multiple approaches for comparison
- Consider edge cases during research
- Note security and platform-specific implications early
- Prioritize packages with high pub points and active maintenance
