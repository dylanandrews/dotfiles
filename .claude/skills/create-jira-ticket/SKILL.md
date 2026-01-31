---
name: create-jira-ticket
description: Create JIRA tickets using the jira-create CLI tool with sensible defaults for the Program Architecture team
allowed-tools: [Bash]
---

## Overview

This skill creates JIRA tickets using the `jira-create` CLI tool. It supports both interactive and headless modes, with defaults configured for the Program Architecture team.

## When to use this skill

Use this skill when the user:

1. **Explicitly asks to create a JIRA ticket**
   - "Create a JIRA ticket for this bug"
   - "Make a ticket for this work"
   - "File a JIRA for this issue"

2. **Wants to track work discovered during development**
   - "This needs a ticket"
   - "We should track this separately"

3. **Asks to create multiple tickets**
   - "Create tickets for each of these issues"

## When NOT to use this skill

- User is just discussing potential work (not ready to create ticket)
- User wants to view or search existing tickets (use `acli jira workitem` directly)
- User wants to edit an existing ticket

## Defaults

The `jira-create` tool has these defaults:
- **Project**: BUAPP
- **Type**: Task
- **Assignee**: dylan.andrews@betterup.co
- **Team**: Program Architecture Squad

## How to use

### Headless mode (recommended for automation)

```bash
jira-create -s 'Ticket summary here' -d 'Description here'
```

### Available options

| Flag | Description |
|------|-------------|
| `-s, --summary` | Ticket summary (required for headless) |
| `-d, --description` | Ticket description |
| `-p, --project` | Project key (default: BUAPP) |
| `-t, --type` | Issue type: Bug, Task, Story, Spike, Epic (default: Task) |
| `-a, --assignee` | Assignee email (default: dylan.andrews@betterup.co) |
| `--team` | Team name |
| `--team-id` | Team ID (for custom teams) |
| `--dry-run` | Preview payload without creating |

### Interactive mode

Run without arguments to use the TUI:

```bash
jira-create
```

## Important notes

1. Always confirm the summary and description with the user before creating
2. Use `--dry-run` first if unsure about the payload
3. The script outputs the created ticket URL on success
