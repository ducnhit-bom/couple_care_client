# Signal Detection And Routing

Detect intent signals from natural language and flags, then decide which steps to run or skip.

## Detection Algorithm

```
FUNCTION detectSignals(input):
  signals = {
    verify: false,      # add human review gates
    code: false,        # skip research + plan
    noTest: false       # skip testing
  }

  # Explicit flags
  IF input contains "--verify": signals.verify = true
  IF input contains "--code": signals.code = true
  IF input contains "--no-test": signals.noTest = true

  # Plan path implies code signal
  IF input matches path pattern (.claude/current-work/*, plan.md, phase-*.md):
    signals.code = true

  # Keywords (fallback when flags are not present)
  keywords = lowercase(input)
  IF keywords contains ["verify", "manual review", "human review"]:
    signals.verify = true
  IF keywords contains ["no test", "skip test", "without test"]:
    signals.noTest = true

  RETURN signals
```

## Signal Behaviors

| Signal | Effect |
|--------|--------|
| `--verify` | Require human approval at review gates |
| `--code` | Skip Research step and Plan step |
| `--no-test` | Skip Testing step |

Signals are composable and can be used together.

## Step Selection

Base workflow: `Research (optional) -> Plan -> Implement -> Testing -> Finalize`

Apply signals:
1. If `code=true`, skip `Research` and `Plan`.
2. If `noTest=true`, skip `Testing`.
3. If `verify=true`, keep human review gates enabled for executed steps.
4. If `verify=false`, run without human review gates.

## Examples

```
"/make implement user auth"
→ Signals: none
→ Runs: research(optional), plan, implement, test

"/make implement auth --verify"
→ Signals: verify
→ Runs: research(optional), plan, implement, test + human review gates

"/make ./path-to-plan --code --no-test"
→ Signals: code + no-test
→ Skips: research, plan, testing
→ Runs: implement, finalize
```
