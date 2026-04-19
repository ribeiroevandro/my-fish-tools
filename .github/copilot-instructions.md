# Copilot Instructions for my-fish-tools

Fish shell plugin package providing utilities for JavaScript/TypeScript projects. Installable via Fisher, Oh My Fish, or manual copy/symlink.

## Testing

```bash
fish -n functions/plugin_name.fish              # Syntax check a single file
fish -c "source functions/r.fish; r --help"     # Load and test manually
```

No automated test suite exists. Validate changes with syntax checks and manual testing in a Fish shell, including error paths (missing deps, invalid input).

## Architecture

The repo mirrors `~/.config/fish/` layout — a flat structure with no nested plugin directories:

- `functions/` — One `.fish` file per function, including helpers. Helpers use the `__plugin_prefix` naming convention and each gets its own autoload file (e.g., `__clone_detect_editors.fish`). See `clone` plugin for reference.
- `completions/` — TAB completion files, named to match their command.
- `conf.d/` — Fish configuration snippets loaded at shell startup.
- `docs/plugins/` — Per-plugin documentation. Use [docs/PLUGIN_TEMPLATE.md](../docs/PLUGIN_TEMPLATE.md) for new plugins.

### Current Plugins

- **Runner** (`r`, `run`): Executes npm/yarn/pnpm/bun scripts. Auto-detects package manager from lockfile. Interactive mode uses `gum`; `jq` is always required. `run` is a thin wrapper calling `r`.
  - Files: `r.fish`, `run.fish`, `__runner_detect_runner.fish`, `__runner_list_scripts.fish`
  
- **Clone** (`clone`): Interactive git clone with optional editor opening. Uses `gum` for UI. Messages are in Portuguese.
  - Files: `clone.fish`, `__clone_known_editors.fish`, `__clone_detect_editors.fish`, `__clone_validate_url.fish`, `__clone_extract_repo_name.fish`

## Key Conventions

### Function & Naming Patterns

- Helper functions use **double underscore + plugin prefix**: `__runner_detect_runner`, `__runner_list_scripts`. Never single underscore.
- All local variables must use `set -l`.
- Every function declaration needs `--description`: `function r --description "Run a script in the current project"`.
- Use `argparse` for flag parsing (see `clone.fish`).

### Error Handling

- Check dependencies at function start with `type -q tool` or `command -q tool`.
- Error messages go to stderr (`>&2`).
- Exit codes: `0` success, `1` user error, `2` parse error, `127` missing dependency.

### Adding a New Plugin

1. Create `functions/plugin_name.fish` with the main function
2. Create separate `functions/__plugin_name_helper.fish` files for each helper
2. Optionally add `completions/plugin_name.fish`
3. Create `docs/plugins/plugin_name.md` from the template
4. Update `docs/plugins/index.md` and `README.md`

See [docs/PLUGINS.md](../docs/PLUGINS.md) for the full development guide.

## Commit Conventions

All commits must follow **Conventional Commits** strictly:

- **Format:** `<type>[optional scope]: <description>`
- **Types:** `feat` (MINOR), `fix` (PATCH), `docs`, `style`, `refactor`, `perf`, `test`, `chore`, `ci`
- **Scope:** describes the affected area (e.g., `runner`, `clone`, `completions`, `docs`, `core`, `tooling`).
- **Breaking changes:** add `!` after type/scope (e.g., `feat(auth)!: remove old login API`). Explain migration path in commit body.
- **Description:** concise, imperative, present tense (`add`, `fix`, `refactor`). Max 72 characters.
- **One task per commit:** separate feature implementation from tests, refactoring from behavior changes, dependency updates isolated.
- **No AI/LLM co-authors:** never add `Co-Authored-By:` for Copilot, Cursor, or any LLM in commits or PRs. Ownership stays with the human engineer.

### Generating Commit Messages

When generating a commit message from a diff or list of changes:

1. Analyze the changes and generate **only** the commit message — no explanations.
2. Output: `<type>[scope]: <description>`
3. For breaking changes, include `!` in the header and explain migration in the body.
4. If changes span multiple logical types, suggest splitting into separate commits.

**Examples:** `feat(auth): add OAuth2 login support` · `fix(api): handle null user responses` · `refactor(db)!: migrate to PostgreSQL schema v2`

### Pull Requests

```bash
gh pr create --title "feat(runner): add feature" --body "Description" --assignee @me
gh pr merge <number> --squash --delete-branch   # Always squash merge
```

### Planning & Issues

After creating or updating a plan in `docs/plan/`, always create GitHub Issues to track implementation:

1. Create one issue per phase/workstream defined in the plan
2. Include a link back to the relevant plan section
3. Add dependency references between issues (`Depende de: #N`)
4. Assign labels (`enhancement`, `documentation`, `bug`) and assignee
5. Use Conventional Commits type as issue title prefix (e.g., `feat(core):`, `test(core):`, `docs(core):`)

```bash
gh issue create --title "feat(scope): description" --label "enhancement" --assignee @me --body "..."
```
