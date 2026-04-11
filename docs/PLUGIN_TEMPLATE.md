# Plugin Documentation Template

This is a template for documenting new plugins in my-fish-tools. Copy this file and customize it for your plugin.

## Instructions

1. Copy this template to `docs/plugins/<plugin_name>.md`
2. Replace placeholders (marked with `[PLACEHOLDER]`)
3. Ensure all sections are filled out completely
4. Remove any placeholder comments
5. Keep the same structure for consistency

---

# [PLUGIN_NAME] Plugin Documentation

[One-line description of what the plugin does.]

## Overview

[2-3 sentences explaining the plugin's purpose and main functionality. What problem does it solve? Who would use it?]

## Location

[List the files that make up this plugin]

- `functions/[plugin_name].fish` - Main plugin function(s)
- `functions/[plugin_name]_helper.fish` - (optional) Helper functions
- `completions/[plugin_name].fish` - (optional) TAB completion

## Features

### [Feature Name 1]
[Description of what this feature does]

### [Feature Name 2]
[Description of what this feature does]

### [Feature Name 3]
[Description of what this feature does]

## Usage Examples

### Basic Usage
```fish
[command] [args]    # What this does
```

### Intermediate Usage
```fish
[command] [options] [args]    # What this does
```

### Advanced Usage
```fish
[command] --advanced-option    # What this does
```

## Requirements

### Always Required
- **[Tool Name]** - [What it's used for]
  - Check: `[tool] --version`
  - Install: `[installation command]`

### Optional
- **[Tool Name]** - [What it's used for, and when it's optional]
  - Check: `[tool] --version`
  - Install: `[installation command]`

### Project Requirements
- [Any specific project structure or files needed]

## Exit Codes

| Code | Meaning | When |
|------|---------|------|
| `0` | Success | [Description] |
| `1` | User error | [Description] |
| `2` | Parse error | [Description] |
| `127` | Missing dependency | [Description] |

## Helper Functions

### `__[plugin_name]_[helper_name]`
[One-line description of what this helper does]

**Usage:** [When and how this helper is used]

**Returns:** [What this function returns]

**Exit codes:**
- `0` - Success
- [Other codes] - [Meanings]

---

## Implementation Details

### [Major Component 1]
[Explanation of how this component works, why these decisions were made]

### [Major Component 2]
[Explanation of how this component works, why these decisions were made]

### Special Handling
[Any special cases, edge cases, or non-obvious behavior]

Example:
```fish
# Explain why this special handling is needed
if condition
    # Do something special
end
```

## Troubleshooting

### Error Message 1
```
Full error message here
```
**Cause:** [What causes this error]  
**Solution:** [How to fix it]

### Error Message 2
```
Full error message here
```
**Cause:** [What causes this error]  
**Solution:** [How to fix it]

### Common Issues

**Issue:** [Description]  
**Solution:** [How to fix it]

---

## Testing

### Syntax Check
```bash
fish -n functions/[plugin_name].fish
```

### Manual Testing
```bash
fish
source ~/.config/fish/config.fish

# Test basic functionality
[test_command_1]

# Test with options
[test_command_2]

# Test error handling
[test_command_3]
```

### Edge Cases to Test
- [Edge case 1 - describe what to test]
- [Edge case 2 - describe what to test]
- [Edge case 3 - describe what to test]
- [Boundary condition 1 - describe what to test]
- [Boundary condition 2 - describe what to test]

## Performance Considerations

[If applicable, document any performance characteristics or optimization opportunities]

## Known Limitations

[Document any known limitations or planned improvements]

## Related Documentation

- [docs/PLUGINS.md](../PLUGINS.md) - Plugin development guide and best practices
- [functions/[plugin_name].fish](../../functions/[plugin_name].fish) - Implementation
- [completions/[plugin_name].fish](../../completions/[plugin_name].fish) - Completions
- [README.md](../../README.md) - User-facing documentation

---

## Maintenance Notes

[Any notes for future maintainers about this plugin's implementation or design decisions]

### Related Plugins
[Links to any related or dependent plugins]

### Version History
- `v1.0` - Initial release [date]

---

## Template Notes

This template follows the documentation standards defined in [docs/PLUGINS.md](../PLUGINS.md). When in doubt about structure or style, refer to the [runner plugin documentation](./runner.md) as a concrete example.
