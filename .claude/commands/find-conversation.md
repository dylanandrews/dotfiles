---
description: "Find a previous Claude conversation by description"
argument-hint: "description of what you were working on"
allowed-tools: ["Read", "LS", "Bash(*)"]
---

I need to help you find a previous Claude conversation based on your description: "$ARGUMENTS"

Let me search through your Claude conversation history in ~/.claude/projects/ and find conversations that semantically match your description. Note the conversation files are .jsonl format.

Here's what I'll do:
1. Scan through all your Claude conversations related to the repo you specify. If no repo is specified, you should default to looking in the directory related to the monolith, which is this ~/.claude/projects/-Users-dylanandrews-Documents-betterup-repos-betterup-monolith
2. Read and analyze the conversation content. Use ripgrep when it makes sense.
3. Find the conversations that best match what you described
4. Provide you with the exact resume command to reconnect to that conversation

For each match I find, I'll give you:
- The conversation ID
- A summary of what the conversation was about
- Why it matches your search
- The exact command: `claude --resume <conversation-id>`

Let me start searching now...