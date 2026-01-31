---
description: Check which files in a PR are owned by squad-program-architecture
argument-hint: [PR# | PR_URL]
allowed-tools: [Bash(git *), Bash(gh pr *), Bash(bin/codeownership *)]
---

## Context
- Current git branch: !`git branch --show-current`
- Arguments provided: $ARGUMENTS
- Target team: squad-program-architecture

## Your task

Check which files in a pull request are owned by squad-program-architecture.

**Steps:**

1. **Identify the PR**:
   - If PR number/URL provided in `$ARGUMENTS`, use that
   - Otherwise, get PR for current branch: `gh pr view --json number,title,url`
   - If no PR found, inform user and exit

2. **Get Changed Files**:
   - Fetch all changed files: `gh pr view <PR_NUMBER> --json files -q '.files[].path'`

3. **Check Ownership**:
   - For each file, run: `bin/codeownership for_file <filepath>`
   - Filter to files owned by "squad-program-architecture"
   - Note any unowned files separately

4. **Present Results**:
   ```
   PR #12345: <title>
   URL: <url>

   Files owned by squad-program-architecture:
     ✓ packs/program_architecture/app/models/program.rb
     ✓ packs/program_architecture/app/services/program_service.rb

   Statistics:
     Total files: 25
     Your team's files: 2 (8%)
     Other teams: 21 (84%)
     Unowned: 2 (8%)
   ```

**Example Usage:**
- `/my-pr-files` - Check current PR
- `/my-pr-files 12345` - Check specific PR
- `/my-pr-files https://github.com/betterup/betterup-monolith/pull/12345`
