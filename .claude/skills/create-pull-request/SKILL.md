---
name: create-pull-request
description: Create a draft pull request with an AI-generated description based on commits, diffs, and plan documents
allowed-tools: [Bash, Task, Read, Write]
---

## Overview

This skill creates draft pull requests by analyzing the current branch's changes and generating a comprehensive PR description. It uses a subagent to gather context without polluting the main conversation, and supports iterative refinement of the PR description before creation.

## When to use this skill

Use this skill when the user:

1. **Wants to create a PR for current changes**
   - "Create a PR for this"
   - "Let's open a pull request"
   - "Draft a PR"

2. **Has finished implementing a feature/fix**
   - "I'm done with this feature, create a PR"
   - "Ready to submit this for review"

3. **Explicitly invokes the skill**
   - "/create-pull-request"

## When NOT to use this skill

- User is still actively making changes
- User wants to create a PR in a different repository
- User just wants to push changes without a PR
- Branch is main/master (cannot create PR from main)

## Workflow

### Step 1: Spawn Context Gathering Subagent

Use the Task tool to spawn a subagent that gathers context and generates the PR description. This keeps the heavy context (full diff, all commits) out of the main conversation.

The subagent should:
1. Run `~/.claude/skills/create-pull-request/gather-pr-context` to get all context
2. Analyze the output and generate a PR description
3. Return the title and description

```
Use the Task tool with:
- subagent_type: "general-purpose"
- prompt: See "Subagent Prompt" section below
```

The subagent will return:
- The generated PR description
- The PR title
- Its agent ID (for potential resume if changes needed)

### Step 2: Present PR Description for Review

Show the user the generated PR description and ask for approval:

```
Here's the draft PR description:

**Title**: [title from subagent]

---
[PR description from subagent]
---

Would you like me to create the PR with this description, or would you like to make any changes?
```

### Step 3: Handle User Feedback

**If user approves**: Proceed to Step 4.

**If user requests changes**: Resume the subagent with the feedback:
```
Use the Task tool with:
- resume: [agent_id from Step 1]
- prompt: "The user requested the following changes to the PR description: [user's feedback]. Please update the PR description accordingly and return the revised version."
```

Then return to Step 2 with the updated description.

### Step 4: Create the Draft PR

Once approved:
1. Generate a unique temp file path: `/tmp/pr-body-<timestamp>-<random>.md` (e.g., `/tmp/pr-body-1736000000-abc123.md`)
2. Use the **Write tool** to write the approved PR body to that file (do NOT use Bash with redirects - this avoids zsh noclobber issues)
3. Call the wrapper script to create the PR:

```bash
~/.claude/skills/create-pull-request/create-draft-pr --title "<approved_title>" --body-file "<temp_file>"
```

The script will:
1. Rebase on main and push
2. Create the draft PR
3. Add the review-me label
4. Open the PR in browser (unless in Codespaces)

## Subagent Prompt

Use this prompt when spawning the context-gathering subagent:

```
You are generating a pull request description. Run the context gathering script and create a PR description based on its output.

## Step 1: Gather Context

Run this command to get all the context you need:

```bash
~/.claude/skills/create-pull-request/gather-pr-context
```

This will output:
- BRANCH: Current branch name
- TICKET: Extracted ticket number (if any)
- TITLE: Suggested title derived from branch name
- COMMITS: All commits on this branch
- DIFF: Full code diff
- PLAN DOCUMENTS: Any matching plan files

## Step 2: Generate PR Description

Based on the context, generate a PR description with these sections:

## Purpose
<1-2 sentence summary of what this PR does>

## Why
<Motivation for this change. What problem are we solving? Include markdown links to relevant artifacts (failed CI builds, Slack threads, previous PRs) if found in plan documents or commits.>

## Approach
<Implementation approach and rationale. What alternatives were considered? Key design decisions. Pull from plan documents if available.>

## Context
<Information reviewers need that ISN'T obvious from reading the diff. Examples: external constraints, why a non-obvious approach was taken, related systems affected, legacy code quirks. Do NOT restate what the code does - reviewers can see that. If there's nothing non-obvious to add, omit this section entirely.>

## Guidance
Any concerns?
<NOTE: Only add more here if there's something truly critical or unusual that reviewers must pay attention to. The bar is HIGH - routine implementation details, edge cases, and formatting choices do NOT qualify. Default to just "Any concerns?" and move on.>

## AI Tools Used
Claude Code

## Tasks
<Checklist of post-merge tasks if any, e.g., config changes, secret updates. Use "- [ ] Task" format. If none, omit this section.>

## Testing
<Checklist of manual/integration testing. Mark completed items with "- [x]". Do not include automated tests that run in CI.>

## Artifacts
<If a ticket number was extracted, include a link in this format:>
- [TICKET-123](https://betterup.atlassian.net/browse/TICKET-123)
<If no ticket number, omit this section entirely.>

## Step 3: Return the Result

Return your response in this exact format:

TITLE: <PR title - use the suggested title from the script, cleaned up if needed>

DESCRIPTION:
<the full PR description in markdown>
```

## Important Notes

1. **Always show the PR description to the user before creating** - never create a PR without explicit approval
2. **The subagent handles all context gathering** - the main conversation only sees the PR description
3. **Resume the subagent for changes** - don't regenerate from scratch, resume to preserve context
4. **Use the scripts** - don't run git commands directly, use the provided scripts
5. **Write body with Write tool** - use a unique temp file path like `/tmp/pr-body-<timestamp>-<random>.md` and the Write tool (not Bash redirects, which fail with zsh noclobber)
