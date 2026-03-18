---
name: make
description: ALWAYS activate this skill before implementing EVERY feature, plan, or fix.
---

# make - Smart Feature Implementation

End-to-end implementation with automatic workflow detection.

**Principles:** YAGNI, KISS, DRY | Token efficiency | Concise reports

## Usage

```
/make <natural language task OR plan path>
```

**Optional flags (composable signals):**
- `--verify`: Require human review gates
- `--code`: Skip research and plan steps
- `--no-test`: Skip testing step

**Example:**
```
/make "Add user authentication to the app"
/make "Code plan in ./path-to-plan --no-test"
```

## MUST DO EVERYTIME - Smart Intent Detection

See `references/signal-routing.md` for detection logic.

**IMPORTANT:** If no signals are provided, the skill runs the default workflow (no human review gates, no skipped steps).

| Input Pattern | Detected Signal | Behavior |
|---------------|-----------------|----------|
| No signals | none | Run default step selection |
| `--verify` or "manual/human review" | verify | Add human review gates |
| `--code` or path to `plan.md` / `phase-*.md` | code | Skip research and plan |
| `--no-test` or "skip test" | no-test | Skip testing step |

Signals control step skipping. `code` can skip both Research and Plan; `no-test` can skip Testing.

| Signals | Research | Plan | Testing | Human Review Gates |
|------|----------|------|---------|--------------------|
| none | Optional | ✓ | ✓ | No |
| verify | Optional | ✓ | ✓ | Yes |
| code | ✗ | ✗ | ✓ | No |
| no-test | Optional | ✓ | ✗ | No |
| code + no-test | ✗ | ✗ | ✗ | No |
| code + verify | ✗ | ✗ | ✓ | Yes |
| verify + no-test | Optional | ✓ | ✗ | Yes |
| code + verify + no-test | ✗ | ✗ | ✗ | Yes |


**With `--verify`:** Stops at `[Review]` gates for human approval before each major step.
**Claude Tasks:** Utilize all these tools `TaskCreate`, `TaskUpdate`, `TaskGet` and `TaskList` during implementation step.

## Workflow (MANDATORY)

1. Input Detection by reading `references/signal-routing.md`.
2. Resolve signals (`verify`, `code`, `no-test`) and apply step selection:
   - `code`: skip Research and Plan
   - `no-test`: skip Testing
   - `verify`: enable human review gates on executed steps
3. Research (Optional): Run only if not skipped by `code` and if research is needed. Research review (by human) only when `verify` is enabled.
4. Plan & Plan review: If not skipped by `code`, **MUST** spawn `planner`, then `plan-reviewer`.
5. Implement: **MUST** spawn `coder`, then `code-reviewer`.
6. Testing: If not skipped by `no-test`, **MUST** spawn `test-planner` and `tester` agents.
7. Finalize: **MUST** spawn all 3 `project-manager`, `docs-manager`, `git-manager` agents.

**IMPORTANT** Read `references/workflow-steps.md` - Detailed step definitions for all modes
**IMPORTANT** Everytime reviewer point out a critical issue. Go back and update the plan/code/test.

## Agent Review Policy (All Modes)

- Agent review is required in **all modes**, including `verify`.
- **Research step (optional):** No agent reviewer required. (Only human review when `verify` is enabled)
- **Plan step:** MUST run `plan-reviewer`. (SKIP if plan already provided or has `code` signal)
- **Implement step:** MUST run `code-reviewer`.
- **Test step (when enabled):** No reviewer agent is required.
- Human review gates in `verify` are additional checkpoints and do not replace reviewer agents.
- Detailed review behavior and reviewer interaction rules are defined in each reviewer skill's `SKILL.md`.

## Blocking Gates (Verify Mode Only)

Human review required at these checkpoints (only with `--verify`):
- **Post-Research:** Review findings before planning
- **Post-Plan:** Approve plan before implementation
- **Post-Implementation:** Approve code before testing
- **Post-Testing:** 100% pass + approve before finalize

## Step Output Format

```
✓ Step [N]: [Brief status] - [Key metrics]
```

**CRITICAL ENFORCEMENT:**
- **MUST** use Task tool to spawn subagents
- Never complete phase Plan/Implement without Agent/Human review
- If workflow ends with 0 Task tool calls, it is INCOMPLETE
- Pattern: `Task(subagent_type="[type]", prompt="[task]", description="[brief]")`

## References

- `references/signal-routing.md` - Signal detection and step routing
- `references/workflow-steps.md` - Detailed step definitions for all modes
