# Add to Brag Doc

Takes the content provided and adds it as a bullet point to the top of the brag document under this week's date heading, with today's specific date included in the bullet point.

## Instructions

1. Get the current date in format "Week of YYYY-MM-DD" (using Monday of current week)
2. Get today's specific date in format "YYYY-MM-DD"
3. Read the existing brag doc at `/Users/dylanandrews/Dropbox/betterup_obsidian_vault/BetterUp/career/brag_doc.md`
4. Check if there's already a heading for this week at the top
5. If the heading exists, add the new bullet point under it with today's date
6. If the heading doesn't exist, create a new bold heading for this week at the very top
7. Add the provided content as a bullet point with today's date under the appropriate heading
8. Preserve all existing content below

The brag document should maintain this format:
```
**Week of YYYY-MM-DD**
* 2025-07-28: [new brag item]
* 2025-07-26: [existing brag items for this week]

**Week of YYYY-MM-DD**
* 2025-07-21: [previous week items...]
```

## Usage

`/add-to-brag Successfully implemented the Cortex Gold status fix and got great feedback from the team`

This will add "* 2025-07-28: Successfully implemented the Cortex Gold status fix and got great feedback from the team" under the current week's heading in the brag doc.