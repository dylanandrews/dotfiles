---
name: create-pull-request
description: Create a draft pull request with an AI-generated description based on commits, diffs, and plan documents
allowed-tools: [Bash(~/.claude/skills/create-pull-request/gather-pr-context), Bash(~/.claude/skills/create-pull-request/create-draft-pr:*), Task, Read, Write]
---

## Overview

This skill creates draft pull requests by analyzing the current branch's changes, generating a comprehensive PR description via a subagent, and creating the PR immediately.

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
- User just wants to push changes without a PR
- Branch is main/master (cannot create PR from main)

## Workflow

### Step 0: Determine Target Repository

Before running any commands, determine the git root of the repository you're working in:

```bash
REPO_DIR=$(git rev-parse --show-toplevel)
```

Pass `-C "$REPO_DIR"` to all `~/.claude/skills/create-pull-request/` script invocations throughout this workflow. For any direct git commands, use `git -C "$REPO_DIR"`. For direct `gh` commands, prefix with `cd "$REPO_DIR" &&`.

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

### Step 2: Create the Draft PR and Start Monitoring

1. Generate a unique temp file path in the current directory: `.pr-body-<timestamp>-<random>.md` (e.g., `.pr-body-1736000000-abc123.md`)
2. Use the **Write tool** to write the PR body to that file (do NOT use Bash with redirects - this avoids zsh noclobber issues)
3. Call the wrapper script to create the PR:

```bash
~/.claude/skills/create-pull-request/create-draft-pr -C "$REPO_DIR" --title "<title>" --body-file "<temp_file>"
```

The script will:
1. Rebase on main and push
2. Create the draft PR
3. Add the review-me label
4. Open the PR in browser (unless in Codespaces)

4. **Immediately after the PR is created**, invoke monitoring to watch CI and feedback:

```
Use the Skill tool to invoke: platoon-harness:monitor-pr
```

When invoking `platoon-harness:monitor-pr`, the monitor skill will determine the repo directory itself via `git rev-parse --show-toplevel`. Ensure you are still working in the correct repository context when invoking it.

This schedules automatic checks every minute that fix CI failures and address reviewer feedback. The skill is NOT done until monitoring has been started.

## Subagent Prompt

Use this prompt when spawning the context-gathering subagent:

```
You are generating a pull request description. Run the context gathering script and create a PR description based on its output.

First, determine the target repository:
REPO_DIR=$(git rev-parse --show-toplevel)

Pass -C "$REPO_DIR" to all script invocations.

## Step 1: Gather Context

Run this command to get all the context you need:

```bash
~/.claude/skills/create-pull-request/gather-pr-context -C "$REPO_DIR"
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
<Testing checklist. Mark completed items with "- [x]".

**CRITICAL: Do NOT include anything that CI already covers.** Linting, type checks, unit tests, integration tests, builds, security scans, and any other automated checks that run in the CI pipeline must be excluded. Reviewers can see CI status themselves - listing these items adds noise and wastes their time. If you're unsure whether something runs in CI, err on the side of excluding it.

Organize remaining items into these categories as needed:

### Pre-Deploy

**Agent-verifiable** - Things Claude can test: running specific commands, e2e tests, triggering workflow runs, API verification with curl, log inspection, before/after comparisons, etc. Don't claim humans need to do things agents can do.

**Human-required** - Things that genuinely require a human: visual UI appearance, physical device testing, browser-specific behavior requiring manual interaction, actions requiring permissions/access Claude doesn't have, third-party systems Claude can't access.

### Post-Deploy

**Agent-verifiable** - Things Claude can verify after merge: production smoke tests via API, checking monitoring dashboards via CLI, verifying deployed artifacts, triggering and monitoring post-deploy workflows.

**Human-required** - Things requiring human verification after deploy: visual verification in production, testing on physical production devices, verifying integrations Claude can't access.

If all testing is covered by CI, just say "CI covers all required testing for this change.">

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

## Completion Checklist

This skill is NOT done until ALL of these are true:
- [ ] `create-draft-pr` script ran successfully
- [ ] `platoon-harness:monitor-pr` invoked to start background monitoring

If you see "ACTION REQUIRED: Invoke /_monitor-pr" in the script output and haven't done it yet, you are not finished (use `platoon-harness:monitor-pr` as the equivalent in this dotfiles environment).

## Important Notes

1. **Do not ask for approval** - generate the description and create the PR immediately
2. **The subagent handles all context gathering** - the main conversation only sees the PR description
3. **Use the scripts** - don't run git commands directly, use the provided scripts
4. **Write body with Write tool** - use a unique temp file path in the current directory like `.pr-body-<timestamp>-<random>.md` and the Write tool (not Bash redirects, which fail with zsh noclobber)
