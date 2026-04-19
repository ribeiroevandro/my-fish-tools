# My Fish Tools - Plugins Index

Central directory for documentation of all plugins in the my-fish-tools package.

## Available Plugins

### [Runner](./runner.md) - `r` / `run`

Quick executor for npm/yarn/pnpm/bun scripts with interactive selection and TAB completion.

**Features:**

- Auto-detect package manager (npm, yarn, pnpm, bun)
- Interactive script selection with gum
- Direct script execution (non-interactive)
- TAB completion support
- Argument forwarding to scripts

**Quick Start:**

```fish
r                    # Interactive menu of scripts
r dev                # Run specific script
r test -- --watch    # Pass arguments to script
```

**Dependencies:**

- `jq` (required)
- `gum` (optional, for interactive mode)

**Files:**

- `functions/r.fish`
- `functions/run.fish`
- `functions/__runner_detect_runner.fish`
- `functions/__runner_list_scripts.fish`
- `completions/r.fish`

**Documentation:** [Runner Plugin Details](./runner.md)

---

### [Clone](./clone.md) - `clone`

Interactive git clone with optional directory navigation and editor opening.

**Features:**

- Interactive editor selection from detected editors
- Auto-extract repository name from URL
- Existing directory handling (offers git pull)
- Optional auto-cd into cloned directory

**Quick Start:**

```fish
clone https://github.com/user/repo              # Interactive prompts
clone git@github.com:user/repo.git -C code       # Clone, cd in, open VS Code
```

**Dependencies:**

- `gum` (required)

**Files:**

- `functions/clone.fish`
- `functions/__clone_known_editors.fish`
- `functions/__clone_detect_editors.fish`
- `functions/__clone_validate_url.fish`
- `functions/__clone_extract_repo_name.fish`
- `completions/clone.fish`

**Documentation:** [Clone Plugin Details](./clone.md)

---

## Adding New Plugins

When you create a new plugin:

1. **Create plugin files** in `functions/` and `completions/`
2. **Create documentation** in `docs/plugins/PLUGINNAME.md`
3. **Update this index** by adding a new section
4. **Update docs/PLUGINS.md** with best practices used

### Documentation Template

Create a new markdown file following this structure:

```markdown
# Plugin Name Documentation

One-line description.

## Overview

Detailed overview of what the plugin does.

## Location

List of files in the repository.

## Features

### Feature 1

Description

### Feature 2

Description

## Usage Examples

Code examples showing how to use the plugin.

## Requirements

Dependencies and requirements.

## Exit Codes

Table of exit codes.

## Helper Functions

Internal helper functions used by the plugin.

## Implementation Details

Technical details about how it works.

## Troubleshooting

Common issues and solutions.

## Testing

How to test the plugin.

## Related Files

Links to related documentation.
```

---

## Plugin Organization

```
functions/           # Plugin implementations
├── r.fish
├── run.fish
└── future_plugin.fish

completions/         # TAB completions
├── r.fish
└── future_plugin.fish

docs/
├── PLUGINS.md       # Plugin development guide
└── plugins/
    ├── index.md     # This file
    ├── runner.md    # Runner plugin docs
    └── future_plugin.md
```

## Navigation

**For Users:**

- [Runner Plugin](./runner.md) - How to use the runner plugin

**For Developers:**

- [docs/PLUGINS.md](../PLUGINS.md) - Plugin development guide
- [CONTRIBUTING.md](../../CONTRIBUTING.md) - Contribution guidelines
- [.github/copilot-instructions.md](../../.github/copilot-instructions.md) - Development conventions

---

## Plugin Development Checklist

When adding a new plugin, refer to these documents in order:

1. ✅ Read [docs/PLUGINS.md](../PLUGINS.md) - Understand plugin standards
2. ✅ Create plugin files in `functions/` and `completions/`
3. ✅ Create documentation in `docs/plugins/<name>.md`
4. ✅ Update this index
5. ✅ Follow conventions in [.github/copilot-instructions.md](../../.github/copilot-instructions.md)
6. ✅ Test following plugin documentation
7. ✅ Update [README.md](../../README.md) if user-facing changes
8. ✅ Commit following [Git conventions](../../.github/copilot-instructions.md#git-and-commit-conventions)
9. ✅ Create PR for review

---

## Questions?

Refer to:

- [Plugin Development Guide](../PLUGINS.md) - How to create plugins
- [Runner Plugin](./runner.md) - Real-world example
- [Contributing Guidelines](../../CONTRIBUTING.md) - How to contribute
