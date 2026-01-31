---
description: Update task documentation before context compaction or session end
argument-hint: Optional - directory name in parch-working-space/dylan_andrews/ (leave empty to list available tasks)
---

We're updating task documentation to ensure seamless continuation after context reset or session end.

## Instructions

### 1. Determine Target Task
- If $ARGUMENTS is provided: Use it as the directory name
- If $ARGUMENTS is empty: List all directories in `/Users/dylanandrews/Documents/betterup_repos/parch-working-space/dylan_andrews/` and ask user which to update

### 2. Locate Task Files
Navigate to: `/Users/dylanandrews/Documents/betterup_repos/parch-working-space/dylan_andrews/[directory-name]/`

Expected files:
- `[directory-name]-plan.md` - The strategic plan (usually unchanged during updates)
- `[directory-name]-context.md` - Current state and decisions
- `[directory-name]-tasks.md` - Task checklist and progress

### 3. Update [directory-name]-context.md

**Add/Update the following sections:**

```markdown
## Current Implementation State
[Describe where the implementation currently stands]
- What has been completed
- What is in progress
- What hasn't been started

## Key Decisions Made This Session
- [Decision] - [Rationale] - [Date]
- [Decision] - [Rationale] - [Date]

## Files Modified
- [file path] - [What changed and why]
- [file path] - [What changed and why]

## Recent Commits
- [commit hash] - [commit message]
- [commit hash] - [commit message]

## Blockers or Issues Discovered
- [Issue] - [Impact] - [Potential solutions]

## Next Immediate Steps
1. [Next action to take]
2. [Following action]
3. [And so on...]

## Session Notes
[Any additional context about complex problems solved, tricky bugs, integration points, testing approaches, performance optimizations, etc.]

Last Updated: YYYY-MM-DD
```

### 4. Update [directory-name]-tasks.md

**Update task statuses:**
- Change `- [ ]` to `- [✅]` for completed tasks
- Add `- [🚧]` prefix for in-progress tasks
- Add any newly discovered tasks
- Reorder priorities if needed
- Update progress tracking metrics

**Update Progress Tracking section:**
```markdown
## Progress Tracking
- Phases Completed: X/N
- Tasks Completed: X/N
- Commits Made: X/N
- Overall Progress: X%
- Last Updated: YYYY-MM-DD

## Recent Activity
- [Date] - Completed tasks X, Y, Z
- [Date] - Started task A, discovered need for task B
```

### 5. Optional: Update [directory-name]-plan.md

Only update the plan if:
- Scope has changed significantly
- New phases were added
- Risk assessment needs updating
- Timeline estimates changed

Otherwise, leave the plan unchanged.

### 6. Create Handoff Summary

At the end of your response, provide a concise handoff summary:

```markdown
## 🔄 Session Handoff Summary

**Task**: [directory-name]
**Status**: [Overall status description]
**Progress**: X% complete (Y/Z tasks done)

**What Just Happened**:
- [Key accomplishment 1]
- [Key accomplishment 2]

**Current State**:
- Last working on: [specific file and area]
- Any uncommitted changes: [yes/no - describe if yes]

**Next Up**:
1. [Immediate next action]
2. [Following action]

**Important Notes**:
- [Any critical context that would be hard to rediscover]
- [Temporary workarounds that need permanent fixes]
- [Commands to run on restart]

**Files Updated**:
- ✅ [directory-name]-context.md
- ✅ [directory-name]-tasks.md
- [✅/❌] [directory-name]-plan.md (if applicable)
```

## Quality Standards

- **Timestamps**: Always update "Last Updated" fields with current date
- **Specificity**: Be specific about file paths, line numbers, and exact state
- **Context**: Capture information that would be hard to rediscover from code alone
- **Git State**: Document commit history and any uncommitted work
- **Next Steps**: Make next actions crystal clear for future sessions
- **Atomic Progress**: Track which commits were made for which tasks

## Usage Examples

**With specific task:**
```
/update-plan migrate-user-authentication
```

**Without arguments (will list available tasks):**
```
/update-plan
```

## Additional Context

$ARGUMENTS

**Priority**: Focus on capturing information that enables seamless continuation, ensures no work is lost, and maintains clear progress tracking with atomic commits.
