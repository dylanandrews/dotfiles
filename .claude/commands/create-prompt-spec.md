# Create Prompt Specification

This command creates a detailed implementation plan for a given feature or change request.

## Usage

```
/create_prompt_spec <spec_file_name> <implementation_prompt>
```

## Parameters

- `spec_file_name`: The name of the specification file (include .md extension)
- `implementation_prompt`: Detailed description of what needs to be implemented

## Output

Creates a file at `prompt_specs/{spec_file_name}` with a comprehensive implementation plan.

## Implementation Plan Structure

When creating the prompt specification file, break down the implementation into these sections:

### 1. High Level Objective

- Clear statement of what we're trying to achieve
- Business context and requirements
- Success criteria

### 2. Type Changes

- New types/interfaces that need to be created
- Existing types that need modification
- Database schema changes if applicable

### 3. Method Changes

- New methods/functions to implement
- Existing methods that need updates
- API endpoints or service changes

### 4. Test Changes

- Unit tests to add or modify
- Integration tests required
- Test data setup needs

### 5. Self Validation

- How to verify the implementation works
- Manual testing steps
- Performance considerations

### 6. README Clean

- Documentation updates needed
- Code comments to add
- Migration guides if applicable

## Workflow

1. Accept the file name and implementation prompt as command arguments
2. Create the specification file in markdown format
3. Use ultrathink to deeply analyze the requirements
4. Structure the plan according to the sections above
5. Provide actionable, specific guidance for each section
