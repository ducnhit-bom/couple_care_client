---
name: test-plan
description: Use this skill to generate a comprehensive test plan for Flutter code. Analyzes implementation and produces structured test scenarios for the tester agent to execute.
---

You are creating a test plan for Flutter/Dart code. This skill produces a structured test plan — NOT actual test code.

## Core Responsibilities

**IMPORTANT**: Ensure token efficiency while maintaining quality.
**IMPORTANT**: Read `.claude/docs/test-writing/` files if they exist for project-specific test patterns.
**IMPORTANT**: Respect YAGNI, KISS, DRY principles — plan only necessary tests.

## RULES

- Output a test plan document, NOT test code
- Be specific with inputs and expected outputs
- Prioritize tests by criticality (must-have vs nice-to-have)
- If code is ambiguous, state assumptions clearly
- Flag areas that need clarification

## Execution Process

1. **Analyze Target Code**
   - Read the implementation report (from `.claude/current-work/[folder-name]/implementation-report.md` if provided, or from the caller's context)
   - Read all files listed in the implementation report
   - Identify functions, methods, classes, and widgets to test
   - Understand input/output contracts and expected behaviors
   - Identify dependencies and mock requirements

2. **Identify Test Scope**
   - Map public APIs that need testing
   - Identify critical paths vs edge cases
   - Determine which test types apply: unit, widget, integration
   - Check existing test coverage — avoid duplicating existing tests

3. **Generate Test Scenarios**
   For each code element, create scenarios in these categories:

   **Happy Path Tests:**
   - Normal expected input with valid data
   - Standard use cases that should work correctly
   - Single successful operation
   - Multiple sequential operations

   **Edge Case Tests:**
   - Empty inputs (empty strings, lists, maps)
   - Null values and optional parameters
   - Boundary values (min, max, zero, negative)
   - Very large inputs
   - Special characters and Unicode
   - Concurrent operations

   **Error Case Tests:**
   - Invalid input types
   - Malformed data
   - Network failures (for API calls)
   - Timeout scenarios
   - Exception handling verification
   - Validation failures

   **Boundary Tests:**
   - First/last item in collections
   - Index boundaries
   - Size limits

4. **Document Mock Requirements**
   - List all dependencies that need mocking
   - Specify mock behavior for each scenario
   - Note any test fixtures or sample data needed

## Report Output

If input is `.claude/current-work/[folder-name]/implementation-report.md` -> Save test plan to directory: `.claude/current-work/[folder-name]/test-plan.md`.
If no file path is provided, input is natural language -> report the output but no need to save to file.

## Output Format

```markdown
# Test Plan for [Component/Feature Name]

## Overview
[Brief description of what is being tested]

## Files to Test
[List of implementation files with their test file paths]

## Test Categories

### 1. Unit Tests
#### [Class/Method Name]
- **Happy Path:**
  - Test: [Description]
  - Input: [Sample input]
  - Expected: [Expected output]
- **Edge Cases:**
  - Test: [Description]
  - Input: [Sample input]
  - Expected: [Expected output]
- **Error Cases:**
  - Test: [Description]
  - Input: [Sample input]
  - Expected: [Expected behavior]

### 2. Widget Tests (if applicable)
#### [Widget Name]
- Test: [Description]
- Setup: [Widget tree setup]
- Action: [User interaction]
- Expected: [Expected UI state]

### 3. BLoC/State Tests (if applicable)
#### [BLoC/Notifier Name]
- Test: [Description]
- Initial State: [state]
- Event/Action: [trigger]
- Expected State: [result state]

### 4. Integration Tests (if applicable)
[Same structure as above]

## Mock Requirements
| Dependency | Mock Type | Behavior |
|------------|-----------|----------|
| [class] | [mock/stub/fake] | [description] |

## Test Data Requirements
- [Sample data sets needed]

## Priority
- **Must-have:** [critical test scenarios]
- **Nice-to-have:** [supplementary test scenarios]
```

**IMPORTANT**: Sacrifice grammar for concision.
**IMPORTANT**: Each test scenario must be specific enough for the tester agent to implement directly.
