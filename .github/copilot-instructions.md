# Copilot Instructions for my-fish-tools

This is a simple Fish shell package containing utilities for JavaScript/TypeScript projects.

## Project Structure

```
my-fish-tools/
├── .github/
│   └── copilot-instructions.md    # This file
├── docs/
│   └── PLUGINS.md                 # Plugin documentation and development guide
├── functions/                     # Fish functions
│   ├── r.fish                     # Runner: npm/yarn/pnpm/bun script executor
│   └── run.fish                   # Alias for r
├── completions/                   # TAB completions
│   └── r.fish                     # Completions for r and run commands
├── README.md                      # User documentation
├── CONTRIBUTING.md                # Development guidelines
└── .gitignore                     # Git ignore patterns
```

## Installation

Users can install via:
1. **Copy**: `cp functions/* ~/.config/fish/functions/`
2. **Symlink**: `ln -s $(pwd)/functions/* ~/.config/fish/functions/`
3. **Fisher**: `fisher install ribeiroevandro/my-fish-tools`

No custom installer needed - just mirror the ~/.config/fish structure.

## Development Guidelines

### Adding New Plugins or Features

When adding a new plugin or feature to my-fish-tools, follow this process:

#### 1. Documentation First (Recommended)
- Review [docs/PLUGINS.md](../docs/PLUGINS.md) for comprehensive guidelines
- Review [docs/plugins/runner.md](../docs/plugins/runner.md) as a real-world example
- Copy [docs/PLUGIN_TEMPLATE.md](../docs/PLUGIN_TEMPLATE.md) as your starting point
- Plan your plugin structure, naming conventions, and dependencies

#### 2. Create Plugin Files
- Main function: `functions/PLUGIN_NAME.fish`
- Helper functions: Use `__plugin_name_helper_name` naming pattern
- Completions (optional): `completions/PLUGIN_NAME.fish`

#### 3. Follow Naming Conventions
- **Main functions**: `function my_plugin --description "..."`
- **Helper functions**: `__my_plugin_helper_purpose` (double underscore prefix)
- **Files**: lowercase with underscores (e.g., `my_plugin.fish`)

#### 4. Code Guidelines
- **Dependency checks**: Verify required tools exist at function start
- **Error messages**: Send to stderr with `>&2`, be clear and actionable
- **Exit codes**: Use 0 (success), 1 (user error), 2 (parse error), 127 (missing dependency)
- **Variable scoping**: Always use `set -l` for local variables
- **Comments**: Only for non-obvious logic

#### 5. Add Completions (Optional)
- Create `completions/PLUGIN_NAME.fish`
- Use `type -q` guards for optional dependencies
- Return completion items one per line
- Include descriptions in `-d` flag

#### 6. Documentation Updates (Required)
Update these files when adding a new plugin:

**a) docs/plugins/[plugin_name].md**
- Create plugin-specific documentation using [PLUGIN_TEMPLATE.md](../docs/PLUGIN_TEMPLATE.md)
- Document purpose, location, features, usage, dependencies, exit codes, helpers
- Add troubleshooting section

**b) docs/plugins/index.md**
- Update the plugins index with your new plugin
- Add a brief summary and link

**c) README.md**
- Add entry to "Contents" section
- Update structure diagram if needed

#### 7. Testing
- Syntax check: `fish -n functions/plugin_name.fish`
- Manual test in Fish shell
- Test error paths (missing deps, invalid input)
- Verify TAB completion if added

#### 8. Commit Guidelines
- Follow conventional commits (see CONTRIBUTING.md)
- Reference the plugin documentation in commit message
- Include testing details in commit body if relevant

### Documentation Structure

Each plugin should have documentation following this structure:

```markdown
### Plugin Name

**Purpose**: One-sentence description of what it does.

**Location**:
- functions/plugin_name.fish - Main command
- completions/plugin_name.fish - (optional) TAB completions

**Features**:
- Feature 1
- Feature 2
- Feature 3

**Usage**:
\`\`\`fish
command arg1    # Description
command arg2    # Description
\`\`\`

**Dependencies**:
- tool1 (optional/required)
- tool2 (optional/required)

**Exit Codes**:
- 0 - Success
- 1 - User error
- 127 - Missing dependency

**Helper Functions**:
- __plugin_name_helper1
- __plugin_name_helper2
```

### Adding Functions

1. Create function file in `functions/`
2. Name files descriptively (e.g., `my_function.fish`)
3. Document with `--description` in function declaration
4. For helper functions: prefix with `__functionname_` (e.g., `__my_function_helper`)
   - This follows the project's convention of plugin-scoped helpers
   - Single underscore is not used in this project

### Adding Completions

1. Create completion file in `completions/` directory
2. Use same name as the command (e.g., `my_function.fish` for `my_function` command)
3. Use Fish completion syntax: `complete -c command ...`

### Function Guidelines

- Keep functions focused on single task
- Document external dependencies (gum, jq, etc.)
- Test with `fish -n filename.fish` for syntax
- Test in actual Fish environment
- Document in docs/plugins/ directory and README.md
- **Important**: This project uses `__` prefix for helpers (e.g., `__runner_list_scripts`), not single `_`

### Project-Specific Conventions

This project uses the **runner** plugin pattern where helper functions are prefixed with the plugin name:
- Format: `__pluginname_helper_name`
- Example: `__runner_list_scripts`, `__runner_detect_runner`
- This prevents naming conflicts when multiple plugins coexist

## Fish Shell Syntax Notes

- Functions: `function name; ...commands...; end`
- Conditionals: `if test -f file; ...commands...; end`
- Loops: `for item in list; ...commands...; end`
- Comments: `#`
- Variables: `set -l local_var`, `set -g global_var`
- Command substitution: `(command)`

## Dependencies

Declare any external dependencies in README.md and test files. Common ones:
- `gum` - Interactive UI
- `jq` - JSON parsing
- Standard Unix tools (grep, sed, etc.)

## Testing

```bash
fish -n functions/my_function.fish     # Syntax check
fish                                    # Enter Fish shell
source ~/.config/fish/config.fish       # Load functions
my_function --help                      # Test
```

## Related Files

- **README.md** - User-facing documentation with installation instructions and usage examples
- **docs/PLUGINS.md** - Plugin development guide and best practices
- **docs/PLUGIN_TEMPLATE.md** - Template for new plugin documentation
- **docs/plugins/index.md** - Index of all available plugins
- **docs/plugins/runner.md** - Runner plugin documentation (example)
- **CONTRIBUTING.md** - Developer guide for adding new functions and contributing

## Current Plugins

### Runner (`r` and `run`)
- **Description**: Quick executor for npm/yarn/pnpm/bun scripts
- **Files**: `functions/r.fish`, `functions/run.fish`, `completions/r.fish`
- **Documentation**: See [docs/plugins/runner.md](../docs/plugins/runner.md)
- **Features**:
  - Auto-detect package manager
  - Execute specific script: `r dev`
  - Interactive menu: `r` (requires gum)
  - TAB completions
  - Argument forwarding
- **Dependencies**: `gum` (optional for interactive), `jq` (required)

## Structure Philosophy

This package uses a flat, community-standard structure:
- **No nested plugin directories** - Functions go directly in `functions/`, not in subdirectories
- **No custom installer** - Simple copy/symlink installation mirrors ~/.config/fish/
- **Easy to extend** - Just add more files to functions/, completions/, or conf.d/
- **Compatible with Fisher** - Can be used with package managers (add fish.yml in future)
- **Compatible with Oh My Fish** - Follows OMF package structure
- **Easy to maintain** - Straightforward directory layout with clear file purposes

## Git and Commit Conventions

All commits must follow **Conventional Commits** strictly:

### Format
```
<type>[optional scope]: <description>
```

### Type Reference
- `feat` - New feature
- `fix` - Bug fix
- `docs` - Documentation changes
- `style` - Code style changes (formatting, semicolons, etc.)
- `refactor` - Code refactoring without changing functionality
- `perf` - Performance improvements
- `test` - Adding or updating tests
- `chore` - Maintenance tasks, dependencies
- `ci` - CI/CD configuration changes

### Scope
Use when applicable to indicate affected area (e.g., `core`, `runner`, `completions`, `docs`, `tooling`).

### Breaking Changes
- Use `!` after type/scope, e.g. `feat(core)!: ...`
- Include migration path or detailed explanation in commit body
- Example: `refactor(runner)!: migrate to new package manager detection`

### Description Guidelines
- Concise, imperative mood, present tense
- Start with a verb (Add, Remove, Update, Fix, etc.)
- No period at the end
- Keep commit header ≤ 72 characters

### Atomic Commits
- One logical task per commit
- Separate implementation from tests
- Separate refactors from behavior changes
- Each commit should be reviewable and logically complete

### Authorship Rule
**Never add `Co-Authored-By:` for Copilot, Cursor, or any LLM in commits or PR descriptions.**
- Only human collaborators should be credited as co-authors
- If generated by AI, the human author is responsible

### Commit Message Examples

**Feature:**
```
feat(runner): add bun package manager support
```

**Fix:**
```
fix(completions): handle scripts with special characters
```

**Documentation:**
```
docs: update plugin development guide
```

**Breaking Change:**
```
refactor(runner)!: change script execution API

BREAKING CHANGE: The `r` function now requires a package.json in the current directory.
Previously it would search parent directories. To maintain old behavior, use `r --search-parent`.
```

**Refactoring:**
```
refactor: simplify runner detection logic
```

**Multiple changes (when needed):**
Make separate commits rather than combining. For example:
1. `feat(runner): add new detection method`
2. `test(runner): add tests for new detection`
3. `refactor(runner): simplify old detection`
