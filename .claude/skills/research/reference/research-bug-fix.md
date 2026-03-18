# Research Bug Fix

## Research Methodology

Always honoring **YAGNI**, **KISS**, and **DRY** principles.
**Be honest, be brutal, straight to the point, and be concise.**

### Phase 1: Bug Analysis

First, clearly define the bug by:
- Identifying the exact error message or exception
- Determining the Flutter/Dart version affected
- Noting the platform (iOS, Android, Web, Desktop)
- Capturing relevant stack traces or logs

### Phase 2: Targeted Information Gathering

**Priority Order:**
1. **GitHub Issues** - Search for similar issues in popular Flutter packages
2. **Stack Overflow** - Find existing solutions and workarounds
3. **Flutter Documentation** - Check official docs for known limitations
4. **Package Source Code** - Examine the actual implementation

**Parallel Subagent Research:**
- Spawn up to **2 researcher subagents** (using `Task` tool with `Explore` subagent type) to investigate different aspects of the bug
- One agent focuses on GitHub issues and bug reports
- Another agent focuses on Stack Overflow solutions and workarounds
- Synthesize findings from all subagents into a cohesive report

**Search Strategy:**
- Use `WebSearch` tool with specific error keywords
- Include "Flutter", "Dart", "GitHub issue", "Stack Overflow" in queries
- Search for the exact error message when possible
- Look for "solved", "fix", "workaround", "solution" keywords
- **IMPORTANT:** You are allowed to perform at most **5 researches (max 5 tool calls)**, strictly respect it

**Search Query Examples:**
- "Flutter [error message] GitHub issue"
- "Dart [exception type] Stack Overflow"
- "[package name] GitHub issues [specific feature]"
- "Flutter [widget name] not working iOS"

### Phase 3: Source Evaluation

Evaluate sources by priority:
1. **Official Flutter/Dart issues** - Check if issue is acknowledged
2. **Stack Overflow accepted answers** - Verify with highest votes
3. **Package GitHub repo** - Look at closed issues and PRs
4. **Blog posts** - Check publication date for currency

### Phase 4: Solution Validation

Validate potential solutions by:
- Checking if fix applies to your Flutter version
- Verifying platform compatibility
- Testing in isolation before implementing
- Looking for alternative approaches if primary fix doesn't work

### Phase 5: Report Generation

**Notes:**
- If input includes a `.claude/current-work/[folder-name]/` context -> Save research report to `.claude/current-work/[folder-name]/research-report.md`.
- If no `current-work` context is provided, input is natural language -> report the output but no need to save to file.

Create a concise markdown report:

```markdown
# Bug Research Report: [Error/Bug Title]

## Bug Summary
- **Error Message**: [exact error]
- **Flutter Version**: [version]
- **Platform**: [iOS/Android/Web/Desktop]
- **Package**: [if applicable]

## Root Cause Analysis
[What causes this bug based on research]

## Solutions Found

### 1. [Solution Name]
- **Source**: [Stack Overflow/GitHub/Docs]
- **URL**: [link]
- **Votes/Status**: [accepted/closed/resolved]
- **Fix**: [code snippet or steps]
- **Applicability**: [version/platform requirements]

### 2. [Alternative Solution]
[Same structure]

## Workarounds
[Any temporary solutions while waiting for fix]

## Prevention
[How to avoid this bug in the future]

## References
- [Link 1]
- [Link 2]
```

## Quality Standards

- **Accuracy**: Verify solutions against official sources
- **Currency**: Prefer recent fixes (last 12 months)
- **Completeness**: Cover root cause and multiple solutions
- **Actionability**: Provide copy-paste ready code
- **Clarity**: Show before/after code examples

## Special Considerations

- Always check if bug is already fixed in newer Flutter versions
- Note workarounds with their trade-offs
- Check for breaking changes in potential fixes
- Document any version-specific limitations

## Output Requirements

1. Save report to `.claude/current-work/[folder-name]/research-report.md` if working within a `current-work` context
2. Include exact error message in title
3. Provide code snippets with language highlighting
4. List solutions by priority (recommended first)
5. Note any unresolved questions or known limitations
