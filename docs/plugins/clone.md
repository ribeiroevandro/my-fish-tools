# Clone Plugin Documentation

Interactive git clone with optional directory navigation and editor opening.

## Overview

The clone plugin simplifies the workflow of cloning a repository, entering the directory, and opening it in your preferred editor. It auto-detects available editors on your system and provides interactive prompts via `gum`.

## Location

- `functions/clone.fish` - Main function
- `functions/__clone_known_editors.fish` - Editor mappings
- `functions/__clone_detect_editors.fish` - Dynamic editor detection
- `functions/__clone_validate_url.fish` - URL validation
- `functions/__clone_extract_repo_name.fish` - Repo name extraction
- `completions/clone.fish` - TAB completion for flags and editors

## Features

### Dynamic Editor Detection
Automatically discovers installed editors by scanning:
- **macOS**: `/Applications/*.app` for GUI editors
- **Linux**: `/usr/share/applications/*.desktop` files
- **Cross-platform**: CLI tools available in `$PATH`

Only editors with a working CLI command are listed. Currently recognized editors:
`code`, `cursor`, `subl`, `atom`, `zed`, `fleet`, `nova`, `idea`, `vim`, `nvim`, `emacs`, `nano`.

If a specified editor is not installed, shows an error and offers interactive selection of available editors.

### Auto-detect Repository Name
Extracts the folder name from the URL automatically (strips `.git` suffix).

### Existing Directory Handling
If the target directory already exists, offers to `git pull` instead of failing.

### Directory Navigation
Use `--enter` / `-C` to automatically `cd` into the cloned directory, or respond to the interactive prompt.

## Usage Examples

```fish
clone https://github.com/user/repo              # Clone with interactive prompts
clone git@github.com:user/repo.git my-folder     # Clone into custom folder
clone https://github.com/user/repo code          # Clone and open in VS Code
clone https://github.com/user/repo code my-custom-dir  # Clone, name folder, open in editor
clone https://github.com/user/repo -C cursor    # Clone, cd in, then prompt for editor
```

## Requirements

- **gum** (required) - Interactive UI for prompts and spinners
  - Install: `brew install gum`

## Exit Codes

| Code | Meaning | When |
|------|---------|------|
| `0` | Success | Clone completed or user cancelled |
| `1` | User error | Invalid URL, git operation failed |
| `2` | Parse error | Invalid arguments (argparse failure) |
| `127` | Missing dependency | `gum` not installed or no editors available |

## Helper Functions

### `__clone_known_editors`
Returns the mapping of recognized editors as `cli_cmd:app_name:desktop_name:display_name` entries.

### `__clone_detect_editors`
Dynamically scans the system for installed editors (macOS `/Applications`, Linux `.desktop` files, and `$PATH`).

### `__clone_validate_url`
Validates that a URL starts with `git@` or `https://`.

### `__clone_extract_repo_name`
Extracts the repository folder name from a URL by stripping the `.git` suffix.

## Known Limitations

- Editor detection from positional args relies on matching against a known list — a folder named `code` would be interpreted as the VS Code editor.
- The `cd` into directory modifies the caller's shell working directory (this is intentional).

## Testing

```bash
fish -n functions/clone.fish                     # Syntax check
fish -n completions/clone.fish                   # Syntax check completions
```

### Manual Testing
```fish
clone --help                                     # Show usage
clone https://github.com/user/repo               # Full interactive flow
clone https://github.com/user/repo -C            # Test --enter flag
clone invalid-url                                # Test URL validation
```
