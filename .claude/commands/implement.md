# Implement Feature from Prompt Spec

This command implements a feature based on a detailed prompt specification file created by the create_prompt_spec command.

## Usage

```
/implement <prompt_spec_file_path>
```

## Parameters

- `prompt_spec_file_path`: Path to the prompt specification markdown file (e.g., `prompt_specs/accountability-partner.md`)

## Implementation Process

1. **Read and analyze the prompt specification file** to understand:
   - High Level Objective and success criteria
   - All required type changes (database schemas, models, interfaces)
   - Method changes (API endpoints, services, components)
   - Test requirements and coverage expectations
   - Self-validation steps and performance criteria

2. **Use subtasks extensively** via the Task tool to break down complex work:
   - Database migration creation and execution
   - Model/service implementation
   - API endpoint development
   - Frontend component creation
   - Test suite development
   - Integration testing

3. **Follow the repository's coding standards** as defined in CLAUDE.md:
   - Run tests after each major change
   - Use `bin/rubocop` for Ruby code style
   - Use `bin/packwerk check` for Ruby dependencies
   - Ensure all tests pass before considering implementation complete

4. **Implement using Test-Driven Development (TDD)**:
   - Write failing tests first based on the spec's Test Changes section
   - Implement minimum code to make tests pass
   - Refactor and improve code quality
   - Re-iterate this cycle for each component:
     - Database/schema changes with migration tests
     - Backend models and services with unit tests
     - API endpoints and controllers with request specs
     - Frontend components with component tests
     * Integration tests to verify end-to-end functionality
   - Documentation updates

5. **Validate implementation** according to the spec's self-validation section:
   - Manual testing checklist completion
   - Performance benchmarking
   - Integration testing
   - Code review preparation

## Output

- Complete implementation of the feature as specified
- All tests passing
- Code meeting repository standards
- Documentation updates as outlined in the spec's README Clean section

## TDD Implementation Cycle

For each feature component, follow this strict TDD cycle:

1. **Red**: Write a failing test that defines the desired behavior
2. **Green**: Write the minimum code necessary to make the test pass
3. **Refactor**: Improve code quality while keeping tests green
4. **Repeat**: Continue until all spec requirements are implemented

### Test Failure Re-iteration Process

- When tests fail during implementation:
  1. Analyze the failure reason carefully
  2. Determine if the test needs adjustment or implementation needs fixing
  3. Make targeted changes to address the specific failure
  4. Run tests again and repeat until green
  5. Never move to the next component until current tests pass

## Best Practices

- Use the Task tool for complex subtasks that require deep analysis
- Always start with failing tests before writing any implementation code
- Run test suite after every small change to catch regressions early
- Follow existing patterns and conventions in the codebase
- Use `bin/rspec path/to/file_spec.rb:line_number` for focused test runs
- Document decisions and trade-offs made during implementation
