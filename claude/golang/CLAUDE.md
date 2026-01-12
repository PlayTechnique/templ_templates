## Testing Approach

This project uses **strict TDD** (Test-Driven Development):

1. **Write tests first** — before implementing any feature or fix
2. **Use Go's stdlib `testing` package** — no external testing frameworks (no testify, gomega, etc.)
3. **Red-Green-Refactor cycle** — write a failing test, make it pass, then refactor
4. **Prefer dependency injection to mocks** - mocks are hard to consistently get correct

## Git Commit Practices

1. **Separate commits for each feature** — each logical change gets its own commit
2. **Interface changes first** — when adding methods to interfaces, commit the interface change separately from the feature that uses it
3. **Atomic commits** — each commit should pass tests independently

## Interface & Mock Maintenance

When modifying interfaces (e.g., `Prompter` in `cmd/prompter.go`):

1. **Update all mock implementations** — search for structs implementing the interface and add the new method
2. **Check test files** — mocks often live in `*_test.go` files (e.g., `mockPrompter` in `select_test.go`, `mockPrompterInCreate` in `create_test.go`)
3. **Use compile-time checks** — ensure `var _ Interface = (*mockType)(nil)` assertions exist to catch missing methods
