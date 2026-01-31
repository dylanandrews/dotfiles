---
description: Create a comprehensive strategic plan with structured task breakdown
argument-hint: Describe what you need planned (e.g., "implement new feature", "refactor system component")
---

You are an elite strategic planning specialist. Create a comprehensive, actionable plan for: $ARGUMENTS

## Instructions

1. **Analyze the request** and determine the scope of planning needed
2. **Examine relevant files** in the codebase to understand current state
3. **Create a structured plan** with:
   - Executive Summary
   - Current State Analysis
   - Proposed Future State
   - Implementation Phases (broken into sections)
   - Detailed Tasks (actionable items with clear acceptance criteria)
   - Risk Assessment and Mitigation Strategies
   - Success Metrics
   - Required Resources and Dependencies
   - Timeline Estimates

4. **Task Breakdown Structure**:
   - Each major section represents a phase or component
   - Number and prioritize tasks within sections
   - Include clear acceptance criteria for each task
   - Specify dependencies between tasks
   - Estimate effort levels (S/M/L/XL)
   - **IMPORTANT**: Design tasks to be commit-sized - each task should result in an atomic commit

5. **Create task management structure**:
   - Parse the first word/phrase from $ARGUMENTS as the directory name or if a ticket is given make it [BUAPP-103412-name-of-task]
   - Create directory: `/Users/dylanandrews/Documents/betterup_repos/parch-working-space/dylan_andrews/[directory-name]/`
   - Generate three files:
     - `[directory-name]-plan.md` - The comprehensive plan
     - `[directory-name]-context.md` - Key files, decisions, dependencies
     - `[directory-name]-tasks.md` - Checklist format for tracking progress
   - Include "Last Updated: YYYY-MM-DD" in each file

## File Templates

### [directory-name]-plan.md
```markdown
# [Task Name] - Strategic Plan

Last Updated: YYYY-MM-DD

## Executive Summary
[High-level overview and goals]

## Current State Analysis
[Understanding of existing system/code based on codebase examination]

## Proposed Future State
[Vision of the end result]

## Implementation Phases

### Phase 1: [Phase Name]
**Tasks:**
1. [Task description] - [Acceptance criteria] - Effort: [S/M/L/XL] - Commit: [Brief commit message]
   Dependencies: [None or list of task numbers]
2. [Task description] - [Acceptance criteria] - Effort: [S/M/L/XL] - Commit: [Brief commit message]
   Dependencies: [None or list]

### Phase 2: [Phase Name]
**Tasks:**
[Continue pattern...]

## Implementation Guidelines
- **Atomic Commits**: Each task should result in a single, atomic commit
- Each commit should be self-contained and independently reviewable
- Run tests before each commit to ensure nothing breaks
- Commit messages should follow the pattern shown in each task
- If a task is too large for one commit, break it into smaller sub-tasks

## Risk Assessment
[Potential issues and mitigation strategies]

## Success Metrics
[How to measure completion and success]

## Resources & Dependencies
[Required tools, access, files, external dependencies]

## Timeline Estimates
[Rough duration projections for each phase]
```

### [directory-name]-context.md
```markdown
# [Task Name] - Context

Last Updated: YYYY-MM-DD

## Key Files
- [file path] - [purpose and relevance]

## Key Decisions
- [Decision] - [Rationale and implications]

## Dependencies
- [Dependency] - [Why needed and how it affects implementation]

## Notes
[Additional context, learnings, or considerations that don't fit elsewhere]
```

### [directory-name]-tasks.md
```markdown
# [Task Name] - Task Checklist

Last Updated: YYYY-MM-DD

## Phase 1: [Phase Name]
- [ ] Task 1: [Brief description] → Commit
- [ ] Task 2: [Brief description] → Commit

## Phase 2: [Phase Name]
- [ ] Task 1: [Brief description] → Commit
- [ ] Task 2: [Brief description] → Commit

[Continue pattern for all phases...]

---

## Progress Tracking
- Phases Completed: 0/N
- Tasks Completed: 0/N
- Commits Made: 0/N
- Overall Progress: 0%

## Commit Guidelines
- Each checked task should have a corresponding commit
- Commits should be atomic and independently reviewable
- Run tests before committing
- Follow conventional commit message format from plan
```

## Quality Standards
- Plans must be self-contained with all necessary context
- Use clear, actionable language
- Include specific technical details where relevant
- Consider both technical and business perspectives
- Account for potential risks and edge cases
- Base analysis on actual codebase examination, not assumptions
- **Each task must be sized for a single atomic commit**

## Usage Example

If user runs: `/plan-task migrate-user-authentication`

You should:
1. Extract "migrate-user-authentication" as the directory name
2. Create directory at: `/Users/dylanandrews/Documents/betterup_repos/parch-working-space/dylan_andrews/migrate-user-authentication/`
3. Generate:
   - `migrate-user-authentication-plan.md`
   - `migrate-user-authentication-context.md`
   - `migrate-user-authentication-tasks.md`

**Note**: This command is ideal to use AFTER exiting plan mode when you have a clear vision of what needs to be done. It creates persistent task structure that survives context resets. Tasks are designed to map 1:1 with atomic commits for clean git history.
