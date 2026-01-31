---
description: Log the current Claude Code session to your Obsidian vault with session ID and resume command
allowed-tools:
  - Read(/Users/dylanandrews/Library/CloudStorage/Dropbox/betterup_obsidian_vault/**)
  - Edit(/Users/dylanandrews/Library/CloudStorage/Dropbox/betterup_obsidian_vault/**)
  - Bash(pwd:*)
  - Bash(date:*)
---

You are logging the current Claude Code session to the user's Obsidian vault.

## Usage
- `/log-session <session-id>` - Logs session with auto-generated description
- `/log-session <session-id> description text here` - Logs session with custom description

## Step 1: Parse Arguments

User provided arguments: `$ARGUMENTS`

The arguments should be in the format: `<session-id> [optional description]`

1. Extract the **first word/token** from `$ARGUMENTS` - this is the session ID
2. If there are **additional words** after the session ID, use them as the description
3. If **only the session ID** was provided, you'll need to generate a description in the next step

**Important**: If no arguments were provided at all, inform the user they need to provide at least a session ID.

## Step 2: Get Current Context

Get the current date and project path:
- Today's date in YYYY-MM-DD format
- Current working directory (project path)

## Step 3: Determine Description

**If the user provided a description** (words after the session ID), use that as the description.

**If only the session ID was provided**, analyze the current conversation you're having with the user right now and generate a concise 1-2 sentence summary of what was accomplished or discussed in this session. Focus on the main task or outcome. You have full context of the conversation, so just summarize it naturally.

## Step 4: Format and Append to File

The target file is: `/Users/dylanandrews/Library/CloudStorage/Dropbox/betterup_obsidian_vault/BetterUp/dev/claude_code_sessions.md`

Format the entry as:
```
- **[TODAY]**: [Description]
  - Session: `[SESSION_ID]`
  - Resume: `cd [PROJECT_PATH] && claude --resume [SESSION_ID]`
```

Use the Edit tool to append this formatted entry to the end of the claude_code_sessions.md file.

## Step 5: Confirm Success

After appending, confirm to the user:
- The session has been logged
- Show the session ID
- Show the resume command they can use
- Provide a clickable link to the file

## Important Notes

- If the session ID cannot be determined from `/status`, inform the user
- If the target Obsidian file doesn't exist, create it with an appropriate header first
- Make sure to preserve existing content when appending
- The description should be concise and actionable
