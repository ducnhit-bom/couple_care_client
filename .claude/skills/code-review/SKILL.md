---
name: code-review
description: Review Flutter/Dart code with 4 priority principles: logic bugs, widget build failures, pattern consistency, duplication/dead code. Use before PRs and task completion.
---

# Flutter Code Review - Priority-Driven

Follow **YAGNI**, **KISS**, **DRY** always. Technical correctness over social comfort.
Apply these 4 principles in order when reviewing code. Be honest, brutal, and concise.

## The 4 Principles (Priority Order)

### 1. Logic Bugs (HIGHEST PRIORITY)

**Focus:** Edge cases that produce incorrect behavior. Pay special attention to functions called from multiple locations — a single bug amplifies across all call sites.

**What to check:**
- A function/code is NOT ready for Production, a MISSING work flow
- Editing a function being reused across multiple files and flow — a bug here is high blast radius
- Logic edge cases (missed conditions, empty list)
- Type casting and narrowing losses
- Collection operations (index out of bounds, concurrent modification)
- Async/await race conditions
- Error handling paths — what happens when things fail?

**Questions to ask:**
- "What happens if input is null/empty?"
- "What happens if this API call fails?"
- "Is this function used elsewhere? Does a change here break other call sites?"
- "Are all branches of this condition handled?"

---

### 2. Widget Build Failures

**Focus:** Catch UI breakages in `build()` methods before runtime.

**What to check:**

| Issue | Detection |
|-------|-----------|
| Unbounded size | `Flexible`, `Expanded`, `FlexibleSpaceBar` missing parent constraints |
| Infinite size | `ListView`, `Column` with unbounded height |
| Layout overflow | `Row`/`Column` children without `Flexible`, text too wide for container |
| Conflicting constraints | Parent `Expanded` + child fixed size, `IntrinsicHeight` with incompatible children |
| Invalid constraint propagation | Using `MediaQuery`/`Theme` before `build()` completes |
| Missing `const` | Static widgets that could be const (performance) |

**Pattern:**
```
build() {
  // Check: Any expensive operation here?
  // Check: Any widget without size constraints?
  // Check: Any child that might overflow?
  // Check: Using context before it's ready?
}
```

---

### 3. Pattern Consistency

**Focus:** New code must align with the file's established architecture.

**What to check:**

| Aspect | Look For |
|--------|----------|
| State management | Same approach as existing code (BLoC/Riverpod/Provider/SetState) |
| Repository usage | Same instantiation pattern, dependency injection style |
| Service integration | Same error handling, same return type patterns |
| Error handling | Consistent try/catch, Result types, exception handling |
| Naming | Follows file conventions (camelCase, PascalCase, prefixes) |
| Imports | Same organization (packages first, relative second) |

**Process:**
1. Read the top of the file to understand existing patterns
2. Check state management approach matches
3. Check repository/service instantiation matches
4. Check error handling style matches
5. Flag any inconsistencies

---

### 4. Duplication & Dead Code

**Focus:** Consolidate repeated logic, remove unused code.

**What to check:**

**Duplication:**
- Same logic in 2+ places → should be shared utility
- Copy-pasted code with minor changes → consolidate
- Similar validation repeated → single validator

**Dead code:**
- Functions never called → remove
- Imports never used → remove
- Variables assigned but never read → remove
- `// TODO` older than 30 days → investigate or remove
- Old commented code → remove

**Commands to verify:**
```bash
# Find unused functions
flutter analyze --no-fatal-warnings | grep -i "unused"

# Find duplicate code (manual inspection)
grep -r "similar pattern" lib/
```

---

## Review Protocol

### Step 1: Gather Context
```bash
# Get changed files
git diff --name-only HEAD~1

# Run Flutter analysis
flutter analyze
flutter test
```

### Step 2: Apply The 4 Principles

For each changed file:

1. **Logic Bugs** — Trace through the code flow, find edge cases
2. **Widget Build** — If it's a widget, analyze build() method
3. **Pattern Consistency** — Compare to existing code in same file
4. **Duplication** — Search for repeated patterns, unused items

### Step 3: Report Findings

Format:
```
## Code Review: {files changed}

### 1. Logic Bugs (Priority)
- {issue} - {severity} - {fix suggestion}

### 2. Widget Build Failures
- {issue} - {severity} - {fix suggestion}

### 3. Pattern Consistency
- {issue} - {severity} - {fix suggestion}

### 4. Duplication & Dead Code
- {issue} - {severity} - {fix suggestion}

### Verification
- flutter analyze: {result}
- flutter test: {result}
```

---

## Severity Levels

| Severity | Meaning |
|----------|---------|
| Critical | Bug will definitely cause wrong behavior or crash |
| High | Likely to cause issues in production |
| Medium | Technical debt, minor correctness issue |
| Low | Style, optimization, or minor improvement |

---

## Bottom Line

1. **Logic bugs first** — especially in functions used multiple times
2. **Widget build second** — catch UI issues before runtime
3. **Pattern consistency third** — prevent technical debt
4. **Duplication last** — clean up after the above
