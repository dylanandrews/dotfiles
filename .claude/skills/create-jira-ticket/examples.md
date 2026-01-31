# Create JIRA Ticket Skill - Examples

## Example 1: Simple ticket creation

**User**: "Create a JIRA ticket for fixing the flaky login test"

**Assistant**: "I'll create a ticket for that."

*Runs*: `jira-create -s 'Fix flaky login test' -d 'The login test is intermittently failing in CI. Investigate and fix the root cause.'`

*Output*: "Created https://betterup.atlassian.net/browse/BUAPP-XXX"

## Example 2: Bug ticket

**User**: "File a bug for the broken password reset flow"

**Assistant**: "I'll create a bug ticket for that."

*Runs*: `jira-create -s 'Password reset flow broken' -d 'Users are unable to complete the password reset process.' -t Bug`

## Example 3: With user-provided details

**User**: "Create a ticket: Summary is 'Add dark mode support', description is 'Implement dark mode toggle in user settings'"

**Assistant**: "Creating the ticket with your details."

*Runs*: `jira-create -s 'Add dark mode support' -d 'Implement dark mode toggle in user settings'`

## Example 4: Spike/investigation ticket

**User**: "Make a spike ticket to investigate the memory leak"

**Assistant**: "I'll create a Spike ticket for the investigation."

*Runs*: `jira-create -s 'Investigate memory leak in worker processes' -d 'Memory usage is growing over time in Sidekiq workers. Investigate root cause and potential fixes.' -t Spike`

## Example 5: Different project

**User**: "Create a ticket in the AIPE project for the AI feature"

**Assistant**: "I'll create it in the AIPE project."

*Runs*: `jira-create -s 'Add AI-powered suggestions' -d 'Implement AI suggestions in the dashboard.' -p AIPE`

## Counter-Examples (Don't Use Skill)

### Discussing potential work

**User**: "We might need a ticket for this eventually"

**Assistant**: *Does NOT create ticket* - waits for explicit request

### Viewing tickets

**User**: "Show me ticket BUAPP-123"

**Assistant**: *Does NOT use this skill* - uses `acli jira workitem view BUAPP-123` instead

### Searching tickets

**User**: "Find tickets about authentication"

**Assistant**: *Does NOT use this skill* - uses `acli jira workitem search` instead
