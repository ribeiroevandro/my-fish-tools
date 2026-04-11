# My Fish Tools - Plugin Documentation

This document describes the plugins included in my-fish-tools and how to add new ones.

## Overview

Plugins are organized as collections of related Fish functions and completions that provide specific functionality. Each plugin follows a consistent structure and naming convention to ensure clarity and avoid naming conflicts.

## Current Plugins

### Runner Plugin (`r` / `run`)

**Purpose**: Quick executor for npm/yarn/pnpm/bun scripts with interactive selection and TAB completion.

**Location**:
- `functions/r.fish` - Main runner function with script execution logic
- `functions/run.fish` - Convenience alias for `r`
- `completions/r.fish` - TAB completion handler

**Features**:
- **Auto-detection**: Detects the project's package manager (npm, yarn, pnpm, or bun) based on lockfiles
- **Interactive mode**: `r` - Opens a gum-powered menu to select from available scripts
- **Direct execution**: `r dev` - Runs a specific script without interactive selection
- **Argument forwarding**: `r test -- --watch` - Passes additional arguments to the script
- **TAB completion**: Press TAB after `r` to see available scripts
- **Non-interactive fallback**: Works without gum when running scripts directly (e.g., `r dev`)

**Usage**:
```fish
r                    # Interactive menu (requires gum)
r dev                # Run "dev" script
r build              # Run "build" script
r test -- --watch    # Pass arguments to script
run lint             # Alias for r lint
```

**Dependencies**:
- **jq** - For parsing package.json (required for all modes)
- **gum** - For interactive mode (optional, only needed for menu selection)

**Exit Codes**:
- `0` - Success
- `1` - User error (missing script, no package.json, no scripts)
- `2` - Parse error (invalid package.json)
- `127` - Missing dependency (jq, gum, or package manager)

**Helper Functions**:
- `__runner_list_scripts` - Extracts script names from package.json with error handling
- `__runner_detect_runner` - Detects package manager from lockfiles

---

## Adding New Plugins

### Step 1: Plan Your Plugin

Before writing code, define:
- **Name**: Short, lowercase, single word (e.g., "git", "docker", "test")
- **Purpose**: What problem does it solve?
- **Commands**: List of main functions
- **Dependencies**: External tools required
- **Files needed**: Functions and completions

### Step 2: Create Plugin Files

Create files in the appropriate directories:

```
functions/
├── PLUGIN_NAME.fish        # Main function(s)
├── PLUGIN_NAME_helper.fish # (optional) Helper functions
└── ...

completions/
└── PLUGIN_NAME.fish        # TAB completions (if applicable)
```

**File naming rules**:
- Use lowercase with underscores
- Main function file: `PLUGIN_NAME.fish`
- Helper file: `PLUGIN_NAME_helper.fish` or split into multiple files
- Completion file: `PLUGIN_NAME.fish` (same as main command)

### Step 3: Function Naming Convention

Follow the project's naming convention to avoid conflicts:

**Main functions**:
```fish
function my_plugin --description "Plugin description"
    ...
end
```

**Helper functions**:
```fish
function __my_plugin_helper_name
    ...
end
```

Pattern: `__<plugin_name>_<helper_purpose>`

Examples:
- `__runner_list_scripts` - Helper in runner plugin
- `__myutil_parse_config` - Helper in myutil plugin
- `__git_format_branch` - Helper in git plugin

### Step 4: Write Function Code

Structure your function with:

1. **Dependencies check** at the start:
```fish
type -q jq; or begin
    echo "Error: jq is required"
    return 127
end
```

2. **Input validation**:
```fish
test -f package.json; or begin
    echo "package.json not found"
    return 1
end
```

3. **Clear error messages** to stderr:
```fish
echo "Error: Description of what went wrong" >&2
```

4. **Proper exit codes**:
   - `0` - Success
   - `1` - User error
   - `2` - Parse/data error
   - `127` - Missing dependency

5. **Local variable scoping**:
```fish
set -l local_var "value"   # Always use -l for local scope
```

6. **Inline comments** for complex logic only:
```fish
# Check if jq succeeded before proceeding
if test $status -ne 0
    return 2
end
```

### Step 5: Add TAB Completion (Optional)

If your plugin has commands that benefit from completion, create `completions/PLUGIN_NAME.fish`:

```fish
function __plugin_name_complete_items
    # Validate dependencies
    type -q gum; or return 1
    
    # Return completion items
    echo "item1"
    echo "item2"
end

# Main completion for plugin_name command
complete -c plugin_name -f -a "(__plugin_name_complete_items)" -d "Description"
```

**Completion best practices**:
- Guard with dependency checks (`type -q`)
- Return items one per line
- Include descriptions in `-d` flag
- Use `-f` flag to suppress filename completion if not needed

### Step 6: Document Your Plugin

1. **Add to README.md** - Under "Contents" section:
```markdown
- **plugin_name** - Brief description of what it does
```

2. **Add to PLUGINS.md** - Create a section like:
```markdown
### Plugin Name

**Purpose**: Clear one-sentence description.

**Location**: List of files

**Features**: Bulleted list of capabilities

**Usage**: Code examples

**Dependencies**: List of required/optional tools

**Exit Codes**: Table of exit codes

**Helper Functions**: List if any
```

3. **Update CONTRIBUTING.md** - Add any plugin-specific guidelines

### Step 7: Update copilot-instructions.md

Add your plugin to the "Current Plugins" section:

```markdown
### Plugin Name
- **Description**: What it does
- **Files**: functions/plugin_name.fish, completions/plugin_name.fish
- **Features**: List of capabilities
- **Dependencies**: Tools required
```

### Step 8: Testing

1. **Syntax check**:
```bash
fish -n functions/plugin_name.fish
```

2. **Manual testing**:
```bash
fish
source ~/.config/fish/config.fish
plugin_name --help
```

3. **Edge cases**:
   - Missing dependencies
   - Invalid input
   - Empty results
   - Error conditions

### Step 9: Commit and Create PR

Follow CONTRIBUTING.md guidelines for commits. Reference the plugin documentation in your commit message.

---

## Plugin Structure Example

Here's the complete structure for a new plugin:

```
functions/
├── new_plugin.fish           # Main command
├── new_plugin_helper.fish    # Helper functions
└── new_plugin_utils.fish     # (optional) Utility functions

completions/
└── new_plugin.fish           # TAB completions
```

**new_plugin.fish**:
```fish
function new_plugin --description "Description"
    # Dependency checks
    type -q jq; or begin
        echo "Error: jq is required" >&2
        return 127
    end
    
    # Main logic
    echo "Hello from new_plugin"
end
```

**new_plugin_helper.fish**:
```fish
function __new_plugin_get_data
    jq '.key' input.json
end
```

**completions/new_plugin.fish**:
```fish
complete -c new_plugin -f -n "__fish_seen_subcommand_from option1" \
    -a "value1" -d "Description"
```

---

## Best Practices

### Code Quality
- Keep functions focused on a single task
- Use meaningful variable and function names
- Add comments only where logic is non-obvious
- Test error paths, not just happy paths

### Error Handling
- Check dependencies early, with clear error messages
- Use appropriate exit codes
- Never silently fail
- Provide actionable error messages

### Performance
- Prefer built-in Fish features over external commands
- Cache results if recomputing is expensive
- Avoid unnecessary subshells
- Profile with `time` if optimization needed

### Compatibility
- Support Fish 3.1.0 and later
- Test on multiple platforms (macOS, Linux)
- Don't assume specific PATH order
- Handle missing dependencies gracefully

### Documentation
- Document dependencies clearly
- Provide usage examples
- Document exit codes
- Explain non-obvious behavior

---

## Maintenance

When updating an existing plugin:

1. **Update version** in git tag if releasing
2. **Update PLUGINS.md** with new features/changes
3. **Update README.md** if user-facing changes
4. **Update CONTRIBUTING.md** if conventions change
5. **Test thoroughly** before merging
6. **Note breaking changes** prominently in commit

---

## Questions?

For more information:
- See [CONTRIBUTING.md](../CONTRIBUTING.md) for development guidelines
- See [README.md](../README.md) for installation and usage
- Check existing plugins for examples
