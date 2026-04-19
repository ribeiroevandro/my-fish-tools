# AGENTS.md

Comprehensive guidance for AI assistants (Claude, Cursor, GitHub Copilot, Windsurf) when working with **my-fish-tools**.

**Symlinks:** `.github/copilot-instructions.md`, `CLAUDE.md`, `.cursorrules`, `.windsurfrules` all point to this file.

---

## Mentalidade de Engenharia

You are a **senior software engineer** working on this codebase. Not an assistant generating code — someone with experience who understands the system before making changes.

### Before Writing Code: Understand What Already Exists

**MANDATORY**: Before creating anything new, investigate the codebase:

1. **Read the existing plugins** — understand how Runner and Clone are structured
2. **Check Fish shell conventions** — Fish autoloading, function naming, variable scoping
3. **Review helpers pattern** — `__plugin_prefix_*` naming and separate autoload files
4. **Look at test examples** — how validation and error handling are done
5. **Check similar implementations** — TAB completion, argument parsing, error codes

```bash
# Before creating a new plugin:
Grep for similar patterns in existing plugins
Check how functions are structured in runner.fish and clone.fish
Look at helper organization in functions/__*

# Before adding helpers:
Verify each helper gets its own autoload file
Check naming convention: __plugin_name_helper_purpose
Review how helpers are called from main function
```

**Priority**: Reuse > Evolve existing > Create new

- **Reuse**: Does the pattern already exist? Use it.
- **Evolve**: Does existing code need adjustment? Modify it.
- **Create**: Nothing exists that solves it? Then create — but justify why existing doesn't work.

### Project Philosophy: Plugin-Based Architecture

This is a **plugin package**, not a monolithic application:

- **Each plugin is independent** — can be used standalone or together
- **Helpers are private** — use `__plugin_prefix_*` to signal internal implementation
- **Zero external dependencies** besides what's explicitly listed
- **TAB completion as first-class** — every command should have completion support
- **Self-contained documentation** — each plugin documents itself

### Error Handling: The Fish Way

Fish has its own patterns. Follow them:

```fish
# Always check dependencies early
type -q jq; or begin
    echo "Error: jq is required" >&2
    return 127
end

# Use proper exit codes
return 0      # Success
return 1      # User error (invalid input, file not found)
return 2      # Parse error (bad data format)
return 127    # Missing dependency
```

**Error messages go to stderr** (`>&2`), never stdout. Tools consuming stderr can distinguish errors from output.

### Code Style

Follow Fish conventions:

- **Local variables**: Always `set -l` — never `set` without scope
- **Variable names**: Use `snake_case` for variables, `CAPS_ONLY` for constants
- **Function descriptions**: Every function must have `--description "..."`
- **Comments**: Only explain non-obvious logic. Don't comment obvious code.
- **String quoting**: Use double quotes unless you have a reason for single quotes
- **Conditionals**: Prefer `begin...end` blocks, not semicolon chains

```fish
# GOOD
function my_func --description "Does something useful"
    set -l local_var "value"
    if test -z "$local_var"
        echo "Error: empty" >&2
        return 1
    end
    echo $local_var
end

# BAD
function my_func
    MY_VAR="value"  # Should be local
    if [ -z "$MY_VAR" ]; then  # Wrong syntax, not fish
        ...
    fi
end
```

---

## Plugin Development Pattern

Every plugin follows this structure:

```
functions/
├── plugin_name.fish                    # Main entry point
├── __plugin_name_helper1.fish          # Helper 1 (one file per helper)
├── __plugin_name_helper2.fish          # Helper 2
└── __plugin_name_helper3.fish          # Helper 3

completions/
└── plugin_name.fish                    # TAB completion

docs/plugins/
└── plugin_name.md                      # Documentation
```

### Main Function (plugin_name.fish)

```fish
function plugin_name --description "Brief description of what it does"
    # 1. Check dependencies first
    type -q required_tool; or begin
        echo "Error: required_tool not found" >&2
        return 127
    end

    # 2. Parse arguments
    argparse 'h/help' 'v/verbose' -- $argv
    or return 2

    # 3. Validate input
    if set -q _flag_help
        echo "Usage: plugin_name [options]"
        return 0
    end

    # 4. Call helpers and implement logic
    set -l result (__plugin_name_do_something)
    if test $status -ne 0
        return 1
    end

    # 5. Output results
    echo $result
end
```

### Helpers (__plugin_name_*.fish)

Each helper in its own file. Must be small, focused, reusable:

```fish
function __plugin_name_validate_input --description "Validate input format"
    if not test -f $argv[1]
        return 1
    end
    return 0
end

function __plugin_name_parse_config --description "Parse config file"
    # Implementation
end
```

**Why separate files?** Fish autoloads them automatically. No need to source manually. Each helper is independently cacheable.

### TAB Completion (completions/plugin_name.fish)

Every command deserves completion:

```fish
# Main flags
complete -c plugin_name -f
complete -c plugin_name -s h -l help -d "Show usage"
complete -c plugin_name -s v -l verbose -d "Verbose output"

# Options with values
complete -c plugin_name -n '__fish_is_nth_token 1' \
    -a "option1 option2" -d "Available options"
```

---

## Current Plugins

### Runner Plugin (`r` / `run`)

Execute npm/yarn/pnpm/bun scripts interactively or directly.

**Purpose**: Quick access to project scripts without remembering the package manager.

**Files**:
- `functions/r.fish` — Main executor
- `functions/run.fish` — Thin wrapper (calls `r`)
- `functions/__runner_detect_runner.fish` — Auto-detect package manager from lockfiles
- `functions/__runner_list_scripts.fish` — Extract scripts from package.json
- `completions/r.fish` — TAB completion
- `docs/plugins/runner.md` — Full documentation

**Key Features**:
- Auto-detects `pnpm-lock.yaml` → `pnpm`, `yarn.lock` → `yarn`, `bun.lockb` → `bun`, else `npm`
- Interactive mode with `gum` (requires `gum`, `jq`)
- Direct execution (requires only `jq`)
- Argument forwarding (handles `yarn` not needing `--` separator)

**Dependencies**:
- `jq` (required) — JSON parsing
- `gum` (optional) — Interactive menu

**Anti-patterns**:
- Don't assume package manager — always detect from lockfile
- Don't fail if `gum` is missing and in non-interactive mode — that's OK
- Don't forward `--` to yarn — yarn interprets flags directly

### Clone Plugin (`clone`)

Interactive git clone with dynamic editor detection and optional auto-cd.

**Purpose**: Clone a repo, cd into it, and open in your editor in one command.

**Files**:
- `functions/clone.fish` — Main entry point
- `functions/__clone_known_editors.fish` — List of recognized editors
- `functions/__clone_detect_editors.fish` — Detect installed editors (macOS, Linux, PATH)
- `functions/__clone_validate_url.fish` — Validate URL format (git@ or https://)
- `functions/__clone_extract_repo_name.fish` — Extract folder name from URL
- `completions/clone.fish` — TAB completion
- `docs/plugins/clone.md` — Full documentation

**Key Features**:
- Dynamic editor detection (VS Code, Cursor, Sublime, Vim, Neovim, Emacs, etc.)
- Auto-extract repository name (strips `.git` suffix)
- Existing directory handling (offers `git pull` instead of error)
- Optional auto-cd with `-C` / `--enter` flag
- Argument flexibility (folder name OR editor can be in any order after URL)

**Dependencies**:
- `gum` (required) — Interactive UI

**Supported Editors**:
- GUI: code (VS Code), cursor, subl (Sublime), atom, zed, fleet, nova, idea (IntelliJ)
- CLI: vim, nvim, emacs, nano

**Anti-patterns**:
- Don't assume editor is installed — always validate before use
- Don't fail if no editors found — offer fallback
- Don't cd into directory without confirmation (unless `-C` flag)

---

## Business Domain: Fish Shell Plugins

**my-fish-tools** is a plugin collection for fish shell developers:

- **Purpose**: Common utilities for JavaScript/TypeScript projects
- **Users**: Fish shell users who develop with JS/TS
- **Scope**: Plugin-based, minimal dependencies, self-contained
- **Philosophy**: Do one thing, do it well

---

## Tech Stack

| Component | Technology |
|-----------|------------|
| Language | Fish 3.1.0+ |
| Package Manager | Fisher (recommended), Oh My Fish, Manual |
| Distribution | GitHub repository |
| Documentation | Markdown (GitHub-flavored) |
| Version Control | Git + Semantic Versioning |
| Releases | GitHub Releases + git tags |

---

## Commands

```bash
# Syntax validation
fish -n functions/plugin_name.fish              # Check single file
fish -n completions/plugin_name.fish            # Check completion file
fish -c "source functions/r.fish; r --help"   # Load and test manually

# Manual testing
fish                                    # Start interactive shell
source ~/.config/fish/config.fish      # Reload config
r                                       # Test runner plugin
r build                                 # Test runner with script
clone https://github.com/user/repo     # Test clone plugin

# Documentation
cat docs/plugins/runner.md              # Read plugin docs
cat README.md                           # Project overview
```

---

## Project Structure

```
my-fish-tools/
├── README.md                           # User-facing overview
├── CHANGELOG.md                        # Version history
├── AGENTS.md                           # This file (AI guidance)
├── LICENSE                             # MIT license
├── CONTRIBUTING.md                     # Contribution guidelines
│
├── functions/                          # Plugin implementations
│   ├── r.fish                          # Runner entry point
│   ├── run.fish                        # Runner alias
│   ├── __runner_detect_runner.fish    # Helper
│   ├── __runner_list_scripts.fish     # Helper
│   ├── clone.fish                      # Clone entry point
│   ├── __clone_known_editors.fish     # Helper
│   ├── __clone_detect_editors.fish    # Helper
│   ├── __clone_validate_url.fish      # Helper
│   └── __clone_extract_repo_name.fish # Helper
│
├── completions/                        # TAB completion
│   ├── r.fish                          # Runner completion
│   └── clone.fish                      # Clone completion
│
├── docs/                               # Documentation
│   ├── PLUGINS.md                      # Plugin development guide
│   ├── PLUGIN_TEMPLATE.md              # Template for new plugins
│   ├── RELEASE_PROCESS.md              # How to make releases
│   └── plugins/
│       ├── index.md                    # Plugin index
│       ├── runner.md                   # Runner docs
│       └── clone.md                    # Clone docs
│
└── .github/
    ├── copilot-instructions.md         # → symlink to AGENTS.md
    └── workflows/
        └── (future: CI/CD)
```

---

## Best Practices

### Before Adding a Plugin

1. **Does the functionality already exist?** — Check runner and clone
2. **Can it be a helper to existing plugins?** — Extend existing
3. **Is it truly independent?** — Should be usable alone
4. **Does it have clear scope?** — "Run scripts" ✓, "Utility collection" ✗

### Function Design

1. **Single responsibility** — Do one thing well
2. **Clear exit codes** — User knows if it succeeded or why it failed
3. **Idempotent when possible** — Multiple runs should be safe
4. **Validate early** — Check deps and arguments first
5. **Fail fast** — Don't continue if validation fails

### Helper Design

1. **One helper per file** — Even if small
2. **Private by naming** — `__plugin_name_*`
3. **Focused responsibility** — Extract, validate, detect, etc.
4. **Reusable** — Could be called from multiple places
5. **Well-described** — `--description` explains what it does

### Testing

1. **Syntax check**: `fish -n functions/plugin_name.fish`
2. **Load test**: `fish -c "source functions/plugin_name.fish; plugin_name --help"`
3. **Manual testing**: Test in interactive shell with real scenarios
4. **Edge cases**:
   - Missing dependencies
   - Invalid input
   - Empty results
   - Special characters in paths/URLs

### Documentation

1. **README** — Quick start for end users
2. **Plugin docs** — Detailed usage and examples
3. **Code comments** — Only non-obvious logic
4. **AGENTS.md** — Implementation guidance for AI assistants
5. **Function descriptions** — Every function has `--description`

---

## Anti-patterns

### DON'T

1. **Create functions without helpers** — Extract logic into helpers even if small
2. **Use single underscore for "private" functions** — Always double underscore
3. **Assume tools are installed** — Always check with `type -q`
4. **Skip error messages** — Always tell user what went wrong
5. **Ignore exit codes** — Use 0/1/2/127 correctly
6. **Mix scopes** — Local vars are `set -l`, never bare `set`
7. **Leave success silent** — Confirm to user what succeeded
8. **Fail without explanation** — User should know why

### DO

1. **Extract to helpers** — One file per helper, one helper per file
2. **Use double underscore** — `__plugin_name_helper`
3. **Check dependencies upfront** — `type -q tool; or return 127`
4. **Provide clear errors** — Error messages to stderr with context
5. **Use correct exit codes** — 0/1/2/127 per spec
6. **Scope variables properly** — `set -l` for local, always
7. **Confirm success** — Let user know what happened
8. **Explain failures** — Tell them why and next steps

---

## Versioning & Releases

This project follows **Semantic Versioning 2.0.0**:

- **MAJOR.MINOR.PATCH** (e.g., `v1.0.0`)
  - **MAJOR**: Breaking changes (incompatible API changes)
  - **MINOR**: New features, backwards compatible
  - **PATCH**: Bug fixes, backwards compatible

### Release Process

1. Update `CHANGELOG.md` with changes
2. Commit: `git commit -m "chore(release): prepare v1.x.x"`
3. Create tag: `git tag -a v1.x.x -m "Release v1.x.x: ..."`
4. Push tag: `git push origin v1.x.x`
5. Create GitHub Release with release notes

**See**: `docs/RELEASE_PROCESS.md` for detailed instructions.

---

## Commit Conventions

All commits follow **Conventional Commits**:

```
<type>[optional scope]: <description>

[optional body]
```

**Types**:
- `feat` → MINOR version (new plugin/feature)
- `fix` → PATCH version (bug fix)
- `docs` → No version change
- `refactor` → No version change
- `perf` → PATCH version (performance improvement)
- `test` → No version change
- `chore` → No version change
- `ci` → No version change

**Scope** (optional): `runner`, `clone`, `completions`, `docs`, `core`

**Examples**:
```
feat(runner): add support for pnpm scripts
fix(clone): handle URLs with special characters
docs(readme): update installation instructions
refactor(core): extract helper into separate file
chore(deps): update fish compatibility
```

---

## Dependencies

### Required

Nothing — each plugin declares its own dependencies:

- **Runner**: `jq` (required), `gum` (optional)
- **Clone**: `gum` (required)

### Development

- **Fish 3.1.0+** — For testing
- **Git** — For cloning and development

### Optional

- **pre-commit** — Git hooks for linting (future)
- **GitHub CLI** (`gh`) — For creating releases

---

## Downlinks

Related documentation:

- [Plugin Development Guide](docs/PLUGINS.md) — How to create new plugins
- [Plugin Template](docs/PLUGIN_TEMPLATE.md) — Template for new plugin docs
- [Release Process](docs/RELEASE_PROCESS.md) — How to make releases
- [Contributing Guidelines](CONTRIBUTING.md) — How to contribute
- [Changelog](CHANGELOG.md) — Version history

---

## Security Considerations

### Input Validation

All user input must be validated:

- **URLs**: Check format (git@ or https://)
- **Paths**: Verify file exists before using
- **Filenames**: Handle special characters
- **Arguments**: Use `argparse` for parsing flags

### Error Handling

- **Never expose internals** — Don't show stack traces to users
- **Clear error messages** — Tell them what went wrong, not implementation details
- **Security-first** — Validate before executing

### No External Execution Risks

- Fish functions don't execute arbitrary code — only configured tools
- Command injection risks are low because we use structured argument parsing
- Always quote variables when expanding them

---

## Performance Considerations

### Startup Performance

- **Lazy loading** — Fish autoloads helpers on demand
- **No startup tax** — Functions only run when called
- **Fast helpers** — Helpers should complete in < 100ms

### Query Performance

- **Git is fast** — Clone operations use native git
- **File parsing is fast** — JSON parsing with `jq` is milliseconds
- **No loops** — Avoid iterating in shell, use native tools (jq, etc.)

---

## Future Roadmap

### v1.1.0 (Next Minor)

- [ ] New plugin: File utilities (search, rename, organize)
- [ ] Enhanced error messages with suggestions
- [ ] Additional editor detection (VSCod Insiders, etc.)

### v2.0.0 (Future Major)

- [ ] Possible breaking changes to plugin architecture
- [ ] CLI framework for easier plugin creation
- [ ] Built-in testing utilities

---

## Questions?

Refer to:
- [README.md](README.md) — Project overview
- [docs/PLUGINS.md](docs/PLUGINS.md) — Plugin development
- [CONTRIBUTING.md](CONTRIBUTING.md) — Contribution process
- [docs/RELEASE_PROCESS.md](docs/RELEASE_PROCESS.md) — Release process

For AI assistants: This file documents the system. Read it before making changes. When in doubt, ask for clarification or consult the existing code.
