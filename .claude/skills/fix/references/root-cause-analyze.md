# Root Cause Analysis Guide

Follow this file as the operational guide for root cause analysis during bug fixing.

## Phase 1: Symptom Collection

1. **Capture the exact error** — copy the full error message, stack trace, and exception type.
2. **Identify the trigger** — what user action, API call, or state transition causes the bug?
3. **Determine scope** — single screen, feature-wide, or app-wide? One platform or all?
4. **Check frequency** — always reproducible, intermittent, or environment-specific?

**Output:** Symptom summary with error, trigger, scope, frequency.

## Phase 2: Stack Trace Dissection

1. **Read the stack trace bottom-up** — find the first frame in project code (not framework/package code).
2. **Identify the crash point** — exact file, line, and method where the error surfaces.
3. **Trace the call chain** — follow the stack trace upward to understand the execution path.
4. **Flag framework boundaries** — note where project code hands off to Flutter/Dart framework or third-party packages.

## Phase 3: Data Flow Tracing

Trace the data from its **origin** to the **crash point**. This is the most critical phase.
**Adding debugPrint()** - Add debug print to the flow, check the expected log vs reality log. Compare the missing log part.

### 3.1 Identify the Data Origin

- **API response** — check the raw JSON, missing/null fields, unexpected types
- **Local storage** — check saved data format, migration issues, corrupted state
- **User input** — check edge cases: empty strings, special characters, extreme values
- **State management** — check state initialization, update order, race conditions
- **Navigation arguments** — check route parameters, null arguments, type mismatches

### 3.2 Trace Through Layers

Follow the data through each architectural layer:

```
Origin → Repository → Use Case/BLoC → ViewModel/State → Widget
```

At **each layer boundary**, verify:
- Is the data transformed correctly?
- Are null/empty cases handled?
- Is the type preserved or cast safely?
- Are async operations awaited properly?
- Are errors caught and propagated correctly?

### 3.3 Identify the Break Point

The root cause is where the data **first becomes incorrect** — not where the error surfaces.

Common break point locations:
- **Serialization/Deserialization** — JSON parsing, `fromJson`/`toJson` methods
- **State transitions** — BLoC events, Riverpod notifiers, ChangeNotifier updates
- **Async gaps** — `await` chains, `Future.then()`, stream subscriptions
- **Platform boundaries** — method channels, FFI, web interop
- **Dependency injection** — wrong instance, missing registration, scope issues

## Phase 4: Hypothesis Formation

1. **Form a single hypothesis** — "The bug occurs because [X] at [file:line] causes [Y]"
2. **Validate with evidence** — read the code at the suspected break point
3. **Check counter-evidence** — are there cases where this code works correctly? Why?
4. **Confirm or reject** — if rejected, return to Phase 3 with new trace path

**NOTE** If the bug is not from the project's dart logic, but comes from setting up library, android, ios specific, use `research` skill with bug fixing flag.

### Hypothesis Validation Checklist

- [ ] Can you explain WHY the bug happens, not just WHERE?
- [ ] Does your hypothesis explain ALL symptoms (not just the primary error)?
- [ ] Does your hypothesis explain why the bug doesn't occur in other scenarios?
- [ ] Is the root cause in project code (not framework/package code)?
- [ ] If the root cause is in a dependency, is there a workaround or version fix?

## Phase 5: Fix Scoping

After confirming the root cause:

1. **Identify the minimal fix** — what is the smallest change that resolves the root cause?
2. **Check ripple effects** — does the fix change behavior for other callers/consumers?
3. **List affected files** — only files that MUST change to fix the root cause.
4. **Reject scope creep** — if a "better" fix requires refactoring, note it but don't do it.

## Anti-Patterns (Do NOT Do These)

- **Symptom masking** — wrapping in try-catch without fixing the actual cause
- **Shotgun debugging** — changing multiple things hoping one works
- **Blame the framework** — assuming Flutter/Dart has a bug before checking your code
- **Over-fixing** — adding defensive code everywhere "just in case"
- **Skipping reproduction** — guessing the root cause without tracing the data flow
- **Ignoring the stack trace** — jumping to conclusions without reading the full trace

## Output Format

After completing root cause analysis, document findings:

```markdown
### Root Cause Analysis

**Symptom:** [Error message / observable behavior]
**Trigger:** [User action or system event that causes the bug]
**Crash Point:** [file:line where error surfaces]
**Root Cause:** [file:line where data first becomes incorrect]
**Explanation:** [1-2 sentences: WHY the bug happens]
**Fix Scope:** [List of files that need to change]
**Confidence:** [high/medium/low — low means more investigation needed]
```
