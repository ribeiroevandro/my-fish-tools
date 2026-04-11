# Copilot Instructions for my-fish-tools

This is a simple Fish shell package containing utilities for JavaScript/TypeScript projects.

## Project Structure

```
my-fish-tools/
├── .github/
│   └── copilot-instructions.md    # This file
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

### Adding New Functions

1. Create function file in `functions/` directory
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
- Document in README.md
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
- **CONTRIBUTING.md** - Developer guide for adding new functions and contributing

## Current Plugins

### Runner (`r` and `run`)
- **Description**: Quick executor for npm/yarn/pnpm/bun scripts
- **Files**: `functions/r.fish`, `functions/run.fish`, `completions/r.fish`
- **Features**:
  - Auto-detect package manager
  - Execute specific script: `r dev`
  - Interactive menu: `r` (requires gum)
  - TAB completions
- **Dependencies**: `gum`, `jq`

## Structure Philosophy

This package uses a flat, community-standard structure:
- **No nested plugin directories** - Functions go directly in `functions/`, not in subdirectories
- **No custom installer** - Simple copy/symlink installation mirrors ~/.config/fish/
- **Easy to extend** - Just add more files to functions/, completions/, or conf.d/
- **Compatible with Fisher** - Can be used with package managers (add fish.yml in future)
- **Compatible with Oh My Fish** - Follows OMF package structure
- **Easy to maintain** - Straightforward directory layout with clear file purposes
