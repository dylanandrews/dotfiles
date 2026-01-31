# Save Learning

Captures learnings from the current conversation and saves them as a structured markdown document.

## Instructions

1. **Determine the topic**: If the user specifies a topic or filename, use that. Otherwise, analyze the conversation to determine the primary topic/theme.

2. **Generate filename**: Create a filename in the format `YYYY-MM-DD-topic-slug.md` (e.g., `2025-12-22-multitrack-migrations.md`). Use lowercase, hyphens for spaces, keep it concise.

3. **Extract learnings**: Review the conversation and identify:
   - Key technical discoveries
   - Problem-solving approaches that worked
   - Gotchas or pitfalls encountered
   - Useful patterns or techniques
   - Commands or code snippets worth remembering

4. **Create the document** at `/Users/dylanandrews/Documents/betterup_repos/parch-working-space/dylan_andrews/learnings/` with this structure:

```markdown
# [Topic Title]

**Date**: YYYY-MM-DD
**Context**: [Brief 1-2 sentence description of what prompted this work]

## Summary

[2-3 sentence overview of the key takeaways]

## Key Learnings

### [Learning 1 Title]

[Explanation of what was learned]

### [Learning 2 Title]

[Explanation of what was learned]

[... additional learnings as needed]

## Code Examples

[Include relevant code snippets if applicable, with explanations]

## Gotchas & Pitfalls

[List any surprising behaviors, common mistakes, or things to watch out for]

## Related Resources

[Links to relevant documentation, PRs, tickets, or files if applicable]
```

5. **Confirm**: Share the filepath and a brief summary of what was captured.

## Usage

Default (auto-generates topic from conversation):
```
/save-learning
```

With specific topic:
```
/save-learning multitrack user tracks migration patterns
```

With specific filename:
```
/save-learning filename:rbac-permission-gotchas.md
```
