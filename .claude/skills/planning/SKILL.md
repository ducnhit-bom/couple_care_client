---
name: planning
description: Plan Flutter feature implementations, design widget architectures, create technical roadmaps with detailed phases for Flutter/Dart projects.
license: MIT
---

# Planning

Create detailed technical implementation plans through codebase analysis, solution design, and structured documentation.
**IMPORTANT** NEVER START IMPLEMTATION, UPDATE/CREATE ANY FILES, JUST PROPOSE THE PLAN

## Input

The planner receives one of:
- A research report path (`.claude/current-work/[folder-name]/research-report.md`) if research was executed
- Direct task context if research was skipped

## Core Principles

- **YAGNI**, **KISS**, **DRY** - every solution must honor these
- **Be honest, brutal, straight to the point, and concise**
- Sacrifice grammar for concision
- Token efficiency while maintaining quality

## Workflow

### 1. Understand Context
Load: `references/codebase-understanding.md`
**Skip if:** Provided with scout reports or sufficient context

- Read research report if provided, else trigger `researcher` subagent to do the research if necessary
- Analyze relevant codebase areas using Glob, Grep, Read
- Understand existing patterns and architecture

### 2. Solution Design
Load: `references/solution-design.md`

- Evaluate approaches, trade-offs
- Design architecture aligned with existing patterns
- Consider security, performance, edge cases

### 3. Plan Creation
Load: `references/plan-organization.md`

- Create structured implementation plan
- Break into phases with clear dependencies
- Include specific file paths and acceptance criteria

### 4. Output
Load: `references/output-standards.md`

- If input is `.claude/current-work/[folder-name]/research-report.md` -> Save plan to directory: `.claude/current-work/[folder-name]/plan.md`
- If no file path is provided, input is natural language -> ask if user want to create a new folder `AskUserQuestion` tool. If user say yes, Make `feature-slug-name` name, then create `.claude/current-work/[YYMMDD]-[feature-slug-name]/` folder in the project directory.
- Respond with plan file path and summary

## Rules

- **DO NOT** implement code - only create plans
- **MUST** save plan to `.claude/current-work/[folder-name]/plan.md` when working within a `current-work` context
- Include code snippets/pseudocode only when clarifying approach
- Provide multiple options with trade-offs when appropriate
- Use `AskUserQuestion` for unresolved questions before finalizing

## Task Integration

When spawned by `make` skill:
- Use TaskCreate to create tasks for each phase
- Set dependencies: Phase N+1 `blockedBy` Phase N
- Use TaskUpdate to mark progress

## Quality Standards

- Detailed enough for junior developers to implement
- Validate against existing codebase patterns
- Consider long-term maintainability
- Address security and performance concerns
- Research thoroughly when uncertain

**Remember:** Plan quality determines implementation success. Be comprehensive and consider all solution aspects. 
**IMPORTANT** NEVER START IMPLEMTATION, UPDATE/CREATE ANY FILES, JUST PROPOSE THE PLAN
