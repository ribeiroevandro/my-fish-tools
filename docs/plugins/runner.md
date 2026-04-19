# Runner Plugin Documentation

Quick executor for npm/yarn/pnpm/bun scripts with interactive selection.

## Overview

The runner plugin (`r` and `run`) simplifies running package manager scripts in JavaScript/TypeScript projects. It provides an interactive menu for script selection or direct script execution from the command line.

## Location

- `functions/r.fish` - Main runner function
- `functions/__runner_list_scripts.fish` - Script extraction from package.json
- `functions/__runner_detect_runner.fish` - Package manager detection
- `functions/run.fish` - Convenience alias for `r`
- `completions/r.fish` - TAB completion handler

## Features

### Auto-detection

Automatically detects your project's package manager by checking for lockfiles:

- `pnpm-lock.yaml` → uses `pnpm`
- `yarn.lock` → uses `yarn`
- `bun.lockb` → uses `bun`
- Default → uses `npm`

### Interactive Mode

Opens an interactive menu to select from available scripts in package.json:

```fish
r   # Opens menu to select a script
```

- Requires: `gum`, `jq`
- Select a script from the list
- Press `q` or `Ctrl+C` to cancel without running anything

### Direct Execution

Run a specific script directly without opening the menu:

```fish
r dev                  # Run "dev" script
r build                # Run "build" script
r test                 # Run "test" script
run lint               # Using the 'run' alias
```

- Requires: `jq` only (gum not needed)
- Useful for scripting and CI/CD
- Script must exist in package.json

## Usage Examples

### Basic Usage

```fish
# Open interactive menu to choose a script
r

# Run a specific script directly
r dev
r build
r test
r lint

# Using the 'run' alias
run dev
run lint
```

### With Arguments

To pass arguments to a script, use `--` as a separator:

```fish
r test -- --watch
r build -- --minify --source-map
```

Special handling for different package managers:

- **npm, pnpm, bun**: Require `--` separator
  - Example: `r test -- --watch` → `npm run test -- --watch`
- **yarn**: Does not require `--` separator
  - Example: `r test --watch` → `yarn run test --watch`

### In Scripts and CI/CD

```bash
#!/bin/bash
# Run a specific script without interactive mode
fish -c "r build"
fish -c "r test -- --coverage"
```

## Requirements

### Always Required

- **jq** - For parsing package.json
  - Check: `jq --version`
  - Install: `brew install jq` (macOS) or `sudo apt install jq` (Linux)

### Optional (for interactive mode only)

- **gum** - For interactive script selection (only needed when running `r` without arguments)
  - Check: `gum --version`
  - Install: `brew install gum` (macOS) or `sudo apt install gum` (Linux)

### Project Requirements

- `package.json` in current directory with `scripts` section
- Corresponding package manager installed (npm, yarn, pnpm, or bun)

## Exit Codes

| Code  | Meaning            | When                                                        |
| ----- | ------------------ | ----------------------------------------------------------- |
| `0`   | Success            | Script executed successfully, or user cancelled selection   |
| `1`   | User error         | Missing script, no package.json, no scripts in package.json |
| `2`   | Parse error        | Invalid/corrupted package.json                              |
| `127` | Missing dependency | jq, gum, or package manager not installed                   |

## Helper Functions

### `__runner_list_scripts`

Extracts available scripts from package.json with comprehensive error handling.

**Usage:** Internal helper, called by main `r` function

**Returns:** Script names (one per line), empty if no scripts found

**Exit codes:**

- `0` - Success
- `1` - package.json not found
- `2` - JSON parse error

### `__runner_detect_runner`

Detects which package manager to use based on lockfiles in current directory.

**Usage:** Internal helper, called by main `r` function

**Returns:** Runner name (npm, yarn, pnpm, or bun)

**Order of detection:**

1. Check `pnpm-lock.yaml` → `pnpm`
2. Check `yarn.lock` → `yarn`
3. Check `bun.lockb` → `bun`
4. Default → `npm`

## Implementation Details

### Non-Interactive vs Interactive Paths

**Non-interactive path** (`r <script>`):

- Parses package.json for specific script
- Validates script exists
- Executes with package manager
- No gum needed
- Fast execution
- Used in scripts, CI/CD, automation

**Interactive path** (`r` with no args):

- Gets all available scripts from package.json
- Uses gum to display menu
- User selects from list
- Executes selected script
- Requires gum
- Better UX for exploring available scripts

### Argument Forwarding Logic

```fish
if test "$runner" = yarn
    # Yarn doesn't require -- separator
    $runner run $script_name $argv[2..-1]
else
    # npm, pnpm, bun require -- separator
    $runner run $script_name -- $argv[2..-1]
end
```

This special handling is necessary because:

- **Yarn** interprets flags directly: `yarn run test --watch`
- **npm/pnpm/bun** need separator: `npm run test -- --watch`

### Error Handling

The runner includes comprehensive error handling:

1. **Dependency checking** - Early validation that jq (and gum if interactive) are available
2. **File validation** - Ensures package.json exists before processing
3. **JSON parsing** - Checks jq exit code, returns error if JSON is invalid
4. **Script validation** - Verifies script exists in package.json before execution
5. **Gum cancellation** - Treats user cancellation (Ctrl+C) as clean exit, not error

## Troubleshooting

### Error: "jq is required"

```
Error: jq is required. Install it with your system package manager.
```

**Solution:** Install jq

- macOS: `brew install jq`
- Linux: `sudo apt install jq`
- Other: See https://stedolan.github.io/jq/download/

### Error: "Failed to parse package.json"

```
Error: Failed to parse package.json
```

**Cause:** Your package.json has syntax errors (invalid JSON)  
**Solution:** Validate JSON with: `jq . package.json`

### Error: "Script 'X' not found"

```
Script 'X' not found
```

**Cause:** Script name doesn't exist in package.json  
**Solution:** Check available scripts with: `r` (interactive mode) or `jq .scripts package.json`

### No scripts appear in interactive menu

```
No scripts found in package.json
```

**Cause:** Your package.json has no `scripts` section  
**Solution:** Add scripts to package.json:

```json
{
  "scripts": {
    "dev": "next dev",
    "build": "next build"
  }
}
```

### "detected package runner is not installed"

```
Error: detected package runner 'yarn' is not installed or not in PATH
```

**Cause:** The lockfile indicates a package manager that isn't installed  
**Solution:** Install the detected package manager or remove the lockfile

## Testing

### Basic Syntax Check

```bash
fish -n functions/r.fish
```

### Manual Testing

```bash
fish
source ~/.config/fish/config.fish

# Test non-interactive
r build

# Test interactive
r

# Test with arguments
r test -- --watch

# Test error cases
r nonexistent    # Should show script not found
```

### Edge Cases to Test

- Project with no package.json
- package.json with no scripts section
- Invalid package.json (broken JSON)
- Missing jq
- Missing gum (for interactive mode)
- Missing detected package manager
- Script name with special characters
- Very large number of scripts

## Related Files

- [docs/PLUGINS.md](../PLUGINS.md) - Plugin development guide and best practices
- [functions/r.fish](../../functions/r.fish) - Main implementation
- [completions/r.fish](../../completions/r.fish) - TAB completion implementation
- [README.md](../../README.md) - User-facing documentation
