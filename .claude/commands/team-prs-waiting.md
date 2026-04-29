---
description: List open PRs waiting on me (dylanandrews) for review, grouped by Agent OS teammates vs. other authors, excluding already-approved PRs and bots
allowed-tools: [Bash]
---

## Your task

Find open PRs in the BetterUp GitHub org where:
1. *I (dylanandrews) am a requested reviewer*, AND
2. *No reviewer has approved the PR yet* (skip already-approved PRs — those don't need me), AND
3. The author is *not a bot* (skip Renovate, Dependabot, github-actions[bot], etc.)

Then list them concisely, *grouped into two sections*: Agent OS teammates first, then everyone else. Do NOT post to Slack — this is a personal summary.

### Agent OS team (excluding me)

Use this table only for *labeling/grouping* (and for the GitHub-username → first-name mapping). PRs from authors *not* in this table are still included — they go in the "Other" section.

| Name | GitHub Username |
|---|---|
| Andrii Skaliuk | askaliukbetterup |
| Brian John | f1sherman |
| Chris Friedrich | linedotstar |
| Daniel Seider | decider |
| Jordan Hochenbaum | jhochenbaum |
| Matthew Drouhard | drouhard |

### Steps

1. Run:

   gh search prs --owner=BetterUp --state=open --review-requested=dylanandrews --sort=created --limit=50 --json=number,title,author,repository,createdAt,url

2. *Drop bots*: filter out any PR whose `author.is_bot` is true, or whose `author.login` ends in `[bot]` (belt and suspenders — `is_bot` should catch them all, but the suffix check is a fallback).

3. For each remaining PR, fetch reviewDecision AND reviewRequests so we can drop both already-approved PRs and PRs where I was only requested via a team:

   gh pr view <number> --repo <owner/repo> --json reviewDecision,reviewRequests

   Run these in parallel (one Bash call per PR is fine — they're independent).

4. Filter:
   - *Drop if already approved*: reviewDecision == "APPROVED" (someone already approved, not waiting on me).
   - *Drop if I'm only requested via a team*: gh search prs --review-requested=dylanandrews matches both individual and team-membership requests. Keep only PRs where reviewRequests contains an entry with __typename == "User" and login == "dylanandrews". If the only matching entry is a Team (e.g. Agent OS team), drop it — those don't need me specifically.

5. *Tag each remaining PR* as either `agent_os` (author.login is in the team table) or `other` (author.login is anyone else).

6. Compute age from createdAt (use that as a stand-in for review-request time — gh search prs doesn't expose review-request timestamps, and PR creation time is the practical floor for how long it's been sitting).

7. If results is non-empty, print two grouped sections (Agent OS first). Within each section, sort oldest first. Use Xh for under 24h, Xd for 24h+.

   *Format each PR line as a markdown link* — title is the clickable target, URL is the link destination. This makes the title cmd-clickable in Claude Code's TUI (which renders markdown) and the bare URL inside the parens is also cmd-clickable in any terminal that auto-links URLs.

   Format:

   PRs waiting on me (dylanandrews) — N open (A Agent OS, B other)

   Agent OS team
   • [<Title>](<url>) by <FirstName> (<repo> #<num>) — <Xh>/<Xd> open

   Other
   • [<Title>](<url>) by <login> (<repo> #<num>) — <Xh>/<Xd> open

   - For Agent OS authors, use the first-name mapping from the table.
   - For Other authors, use their GitHub login as-is (no mapping available).
   - *Omit a section header entirely if its group is empty* (don't print "Agent OS team" with nothing under it). The header counts always show both numbers, even when one is zero.
   - Do NOT escape the title text — even if it contains characters like `[`, `(`, or backticks. The markdown renderer handles them fine, and escaping makes the output uglier in plain-text terminals.

8. If no matches at all, print just: No PRs waiting on me right now.

### Guidelines

- Do not edit any files, do not post to Slack, do not create messages.
- If gh is unauthenticated or fails, print the error and stop — don't try to recover.
- Use the GitHub username → first-name mapping from the team table for Agent OS authors only.
