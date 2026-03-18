# Unified Workflow Steps

Follow this file as the operational workflow for `make`, aligned with `SKILL.md`.

## Step 0: Intent Detection & Setup

1. Parse input using `signal-routing.md`.
2. Detect signals: `verify`, `code`, `no-test`.
3. Build step plan from signals:
   - `code`: skip Research and Plan.
   - `no-test`: skip Testing.
   - `verify`: enable human review gates on executed steps.
4. Initialize task tracking with Task tools (`TaskCreate`, `TaskUpdate`, `TaskGet`, `TaskList`).
5. Log routing decision and execution intent.
6. **MUST** Make a `feature-slug-name` name, then create `.claude/current-work/[YYMMDD]-[feature-slug-name]/` folder in the project directory. This folder is used to save research, plan files.
Remember the `[YYMMDD]-[feature-slug-name]` as the `folder-name` for the rest of your session.

**Output:** `✓ Step 0: Signals [verify=?, code=?, no-test=?] - [routing reason]`

## Step 1: Research (Optional)

- If `code=true`, skip Step 1 entirely.
- Research is optional in all modes.
- Run research when requirements are unclear, dependencies are unknown, architecture impact is high, or risk is medium/high like adding a whole new feature.
- Skip research when the task is a small scoped change with clear acceptance criteria and known files.
- **IMPORTANT** Use `research` skill to execute this step
- Research has **no agent reviewer** in any mode.
- If research is skipped, continue directly to Step 2 and log why it was skipped.
- Keep reports ≤150 lines
- **MUST** If report is created, save it to `.claude/current-work/[folder-name]/research-report.md`

### Verify Gate (Human only, if `verify=true`)

- Present research summary to user for approval before planning.
- Non-verify modes continue automatically.
- Use `AskUserQuestion` to ask: "Proceed to planning?" / "Request more research" / "Abort"

**Output:** `✓ Step 1: Research [executed|skipped] - [reason/report]`

## Step 2: Plan + Plan Review

1. **MUST** spawn `planner` agent to produce/update implementation plan. Pass the **research report content** (or its file path) to `planner` agent if research was executed; otherwise provide direct task context. Tell `planner` to save plan to `.claude/current-work/[folder-name]/plan.md`.
2. Wait for plan completion.
3. **MUST** spawn `plan-reviewer` agent to review the plan.
4. If `plan-reviewer` reports critical issues, update plan.
5. **MUST** If plan is created or used, save the final version to `.claude/current-work/[folder-name]/plan.md`

### Verify Gate (Human only, if `verify=true`)

- After plan-reviewer passes, request user approval to proceed.
- Non-verify modes continue automatically.
- Present plan overview with phases
- Use `AskUserQuestion` to ask: "Validate the plan or approve plan to start implementation?" - "Validate" / "Approve" / "Abort" / "Other" ("Request revisions")

**Output:** `✓ Step 2: Plan reviewed - plan-reviewer [pass/fail]`

If `code=true`, skip Step 2 entirely.

## Step 3: Implement + Code Review

1. **MUST** Pass `.claude/current-work/[folder-name]/plan.md` to the `coder` subagent. Tell `coder` to save implementation report to `.claude/current-work/[folder-name]/implementation-report.md`.
2. Wait for coding to complete.
3. **MUST** spawn `code-reviewer` agent. Tell `code-reviewer` to save review report to `.claude/current-work/[folder-name]/code-review-report.md`.
4. If `code-reviewer` reports critical issues, send fixes back to `coder`, then re-run `code-reviewer` until criticals are resolved or workflow is aborted.
5. Don't bypass, asume code just to pass the review, if criticals issue can't be fixed after 3 review cycle, use `AskUserQuestion` to inform the user. 
6. Verify `implementation-report.md` is saved.

### Verify Gate (Human only, if `verify=true`)

- After code-reviewer passes, request user approval to proceed.
- Non-verify modes continue automatically.
- Present implementation summary (files changed, key changes)
- Use `AskUserQuestion` to ask: "Proceed to testing?" / "Request implementation changes" / "Abort"

**Output:** `✓ Step 3: Code reviewed - code-reviewer [pass/fail]`

## Step 4: Test

Note: skip if `no-test=true` or the project doesn't contain any test (don't count the default flutter test).

1. **MUST** spawn `test-planner` agent. Pass `.claude/current-work/[folder-name]/implementation-report.md` path and tell it to save test plan to `.claude/current-work/[folder-name]/test-plan.md`.
2. **MUST** spawn `tester` agent to run tests. Pass both `.claude/current-work/[folder-name]/test-plan.md` and `.claude/current-work/[folder-name]/implementation-report.md` paths. Tell it to save test report to `.claude/current-work/[folder-name]/test-report.md`.
3. Wait for testing to complete.
4. If all tests passed, continue to next step.
5. If any failures: enter the **debug-retest loop**:
   a. **MUST** spawn `debugger` subagent to fix failing code.
   b. After fix, update `implementation-report` and reference the debug report file.
   c. **MUST** re-run `tester` agent with the updated implementation report and existing test plan.
   d. If tests still fail, repeat from (a). Max 3 iterations before escalating to user (with use `AskUserQuestion` tool)
   e. If all tests pass, exit loop and continue to next step.

- **Forbidden:** commented tests, changed assertions, skipping subagent delegation

### Verify Gate (Human only, if `verify=true`)

- After tests pass, request user approval to proceed.
- Non-verify modes continue automatically.

**Output:** `✓ Step 4: Tests executed - [pass/fail]`

## Step 5: Finalize

**MUST** spawn all finalization agents:

1. `project-manager`
2. `docs-manager`

Then:

1. Mark related tasks complete with `TaskUpdate`.
2. Ensure status/reporting is complete.
3. **MUST** Delete the `.claude/current-work/[folder-name]/` directory after all finalization agents complete successfully.

**Output:** `✓ Step 5: Finalized - project-manager/docs-manager/git-manager complete, current-work cleaned`

## Critical Review Loop Rule

- If any reviewer (`plan-reviewer`, `code-reviewer`) reports critical issues:
  - Return to the corresponding phase.
  - Apply fixes.
  - Re-run the reviewer.
- Never finalize with unresolved critical issues.

## Signal Behavior Summary

- `verify`: Agent reviews required + human approval at review gates.
- `code`: Skip research and plan phases.
- `no-test`: Skip testing.
- Signals can be combined; all enabled skips apply.

## Enforcement Rules

- **MUST** use Task tools to spawn and track subagents.
- Never complete a phase without required agent review.
- Research phase does not require an agent reviewer.
- If workflow ends with zero Task tool calls, it is incomplete.
- Follow output format: `✓ Step [N]: [Brief status] - [Key metrics]`.
