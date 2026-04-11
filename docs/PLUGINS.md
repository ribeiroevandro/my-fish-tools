# My Fish Tools - Plugin Development Guide

This document describes the standards and best practices for creating plugins in my-fish-tools. For documentation of existing plugins, see [docs/plugins/index.md](plugins/index.md).

## Overview

Plugins are organized as collections of related Fish functions and completions that provide specific functionality. Each plugin follows a consistent structure and naming convention to ensure clarity and avoid naming conflicts.

## Plugin Documentation Structure

Plugin-specific documentation belongs in separate files within the `docs/plugins/` directory:

```
docs/
├── PLUGINS.md              # This file - development guide
├── PLUGIN_TEMPLATE.md      # Template for new plugins
└── plugins/
    ├── index.md            # Index of all plugins
    ├── runner.md           # Runner plugin documentation
    └── [future_plugin].md  # Future plugin docs
```

**For documentation of existing plugins, refer to:**
- [Runner Plugin](./plugins/runner.md) - Complete runner plugin documentation
- [Plugins Index](./plugins/index.md) - List of all available plugins

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

1. **Create plugin documentation** in `docs/plugins/[plugin_name].md`
   - Use [PLUGIN_TEMPLATE.md](./PLUGIN_TEMPLATE.md) as your starting point
   - Include overview, usage, requirements, exit codes, etc.
   - Provide troubleshooting section

2. **Update docs/plugins/index.md** 
   - Add your plugin to the index
   - Include quick summary and link to full documentation

3. **Update README.md** - Under "Contents" section:
```markdown
- **plugin_name** - Brief description of what it does
```

4. **Update CONTRIBUTING.md** - Add any plugin-specific guidelines

### Step 7: Update copilot-instructions.md

Add your plugin to the "Current Plugins" section:

```markdown
### Plugin Name
- **Description**: What it does
- **Files**: functions/plugin_name.fish, completions/plugin_name.fish
- **Documentation**: See [docs/plugins/plugin_name.md](../docs/plugins/plugin_name.md)
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

Follow [Git conventions](../.github/copilot-instructions.md#git-and-commit-conventions) and CONTRIBUTING.md guidelines. Reference the plugin documentation in your commit message.

---

## Using PLUGIN_TEMPLATE.md

When creating a new plugin, start with the [PLUGIN_TEMPLATE.md](./PLUGIN_TEMPLATE.md) in this directory:

1. Copy the template file to `docs/plugins/[your_plugin_name].md`
2. Replace all `[PLACEHOLDER]` sections with your plugin's information
3. Follow the structure to ensure consistency with other plugins
4. Reference the [runner plugin documentation](./plugins/runner.md) for a real-world example

The template includes all sections needed for comprehensive plugin documentation.

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
