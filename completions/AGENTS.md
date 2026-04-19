# AGENTS.md — Completions Module

Guidance for developing TAB completion files in the `completions/` directory.

---

## Overview

The `completions/` directory contains TAB completion definitions that enable intelligent argument suggestion and command exploration in the Fish shell.

**Why completions matter**:
- Discoverability — Users discover available options without reading docs
- Productivity — Faster typing with auto-completion
- Error prevention — Suggest valid options before execution
- Professional polish — Shows the project is production-ready

Every command should have completion support. This module makes my-fish-tools feel like a first-class Fish ecosystem member.

---

## File Structure

```
completions/
├── AGENTS.md (this file)
├── r.fish                    # Completions for 'r' command
└── clone.fish                # Completions for 'clone' command
```

**Pattern**:
- One completion file per command
- Named to match the command (e.g., `r.fish` for `r` command)
- Uses Fish `complete` built-in command

---

## Key Concepts

### 1. Completion Anatomy

Fish completions have these parts:

```fish
# Basic flag completion
complete -c r -f                         # -c: command name, -f: no file completion
complete -c r -s h -l help -d "Show help"  # -s: short flag, -l: long flag

# Option completion with arguments
complete -c r -n '__fish_is_nth_token 1' -a "build test" -d "Available scripts"

# Conditional completion
complete -c r -n '__fish_seen_subcommand_from build' -a "--watch" -d "Watch for changes"
```

**Key flags**:
- `-c COMMAND` — Which command (required)
- `-s SHORT` — Short flag (e.g., `-h`)
- `-l LONG` — Long flag (e.g., `--help`)
- `-f` — No file completion (used for commands that don't take files)
- `-a OPTIONS` — Available arguments/choices
- `-d DESCRIPTION` — Helpful tooltip
- `-n CONDITION` — Only show if condition is true

### 2. Conditions

**Common conditions**:

```fish
# First argument (subcommand position)
-n '__fish_is_nth_token 1'

# Has seen certain subcommand
-n '__fish_seen_subcommand_from build test'

# No subcommand seen yet
-n 'not __fish_seen_subcommand_from'

# Always (default if no -n)
# (no -n flag means show always)
```

### 3. Description Format

Descriptions appear in the completion menu:

```fish
complete -c r -a "build" -d "Build the project"
                          ↑
                    Shows in menu
```

Keep descriptions:
- Short (1 line max)
- Actionable (tell what the option does)
- Consistent with other completions

### 4. File Completions

Some commands DO take files:

```fish
# Runner probably doesn't take files (scripts are in package.json)
complete -c r -f   # No file completion

# But if a command worked with files:
complete -c my_cmd  # Allow file completion by default
# OR explicitly:
complete -c my_cmd -F  # Accept files
```

---

## Common Patterns

### Pattern 1: Simple Flags

```fish
# Command with help flag
complete -c r -f
complete -c r -s h -l help -d "Show usage information"
complete -c r -s v -l verbose -d "Verbose output"
```

### Pattern 2: Subcommands

```fish
# Runner lists available scripts as completions
complete -c r -f
complete -c r -n '__fish_is_nth_token 1' \
    -a "build test deploy" \
    -d "Available scripts from package.json"
```

### Pattern 3: Dynamic Completions

```fish
# List git repositories (for clone)
complete -c clone -f
complete -c clone -n '__fish_is_nth_token 1' \
    -a "(__list_recent_repos)" \
    -d "Recent repositories"
```

### Pattern 4: Flag Arguments

```fish
# Command with options that take values
complete -c my_cmd -f
complete -c my_cmd -s o -l output -d "Output file" -r  # -r means requires argument
complete -c my_cmd -s f -l format \
    -a "json yaml csv" \
    -d "Output format"
```

### Pattern 5: Conditional Flags

```fish
# Some flags only available after certain subcommand
complete -c r -f
complete -c r -n 'not __fish_seen_subcommand_from' \
    -a "build test" \
    -d "Available scripts"

complete -c r -n '__fish_seen_subcommand_from build' \
    -s w -l watch \
    -d "Watch for changes"
```

---

## Real Examples

### Runner (`r`) Completions

```fish
# Basic setup
complete -c r -f  # No file completion (scripts come from package.json)

# Main help
complete -c r -s h -l help -d "Show usage"

# Verbose flag
complete -c r -s v -l verbose -d "Verbose output"

# Script names as first argument
# (In real use, this would dynamically read package.json)
complete -c r -n '__fish_is_nth_token 1' \
    -a "build test deploy start" \
    -d "Available npm scripts"
```

### Clone (`clone`) Completions

```fish
# Basic setup
complete -c clone -f  # No file completion

# Help flag
complete -c clone -s h -l help -d "Show usage"

# Directory option
complete -c clone -s d -l directory \
    -d "Clone into specific directory" \
    -r

# Enter option (cd into directory)
complete -c clone -s C -l enter \
    -d "cd into directory after cloning"

# Editor selection
complete -c clone -s e -l editor \
    -a "code cursor subl vim nvim" \
    -d "Open in editor after cloning"
```

---

## Development Checklist

### Creating a New Completion File

- [ ] File named `command_name.fish` (matches actual command)
- [ ] First line: `complete -c COMMAND -f` (disable file completion if appropriate)
- [ ] Help flag: `-s h -l help -d "Show usage"`
- [ ] All flags documented with descriptions
- [ ] Subcommands listed with `-a`
- [ ] Conditional logic for complex commands
- [ ] Tested in interactive shell: `complete -c mycommand` shows results
- [ ] File placed in `completions/` directory

### Testing Completions

```bash
# Load completions in current shell
source completions/r.fish

# Test in Fish shell
r <TAB>        # See available scripts
r -<TAB>       # See available flags
clone <TAB>    # See clone options
clone --<TAB>  # See long flags

# Verify completion loads on startup
fish
r <TAB>        # Should show completions (no manual source needed)
```

### Editor Integration

Most Fish-aware editors show completions automatically:
- VS Code with Fish extension
- Cursor IDE with completion support
- Vim with Fish plugin

Manual testing in `fish` shell is the most reliable verification.

---

## Naming Guidelines

### Command Naming
- Match the actual command name exactly
- Example: `r.fish` for `r` command
- Example: `clone.fish` for `clone` command

### Description Naming
- Start with capital letter
- Be concise (< 60 chars ideally)
- Action-oriented (what does it do?)
- Examples:
  - ✅ "Show usage information"
  - ✅ "Build the project"
  - ✅ "Open in editor"
  - ❌ "helps" (too vague)
  - ❌ "build option" (unclear)

---

## Anti-patterns

### DON'T

1. **Use file completion when not needed**
   ```fish
   # BAD: Runner doesn't take files
   complete -c r
   
   # GOOD: Explicitly disable
   complete -c r -f
   ```

2. **Leave flags undocumented**
   ```fish
   # BAD
   complete -c r -s v
   
   # GOOD
   complete -c r -s v -d "Verbose output"
   ```

3. **Forget short AND long flags**
   ```fish
   # BAD: Only short
   complete -c r -s h
   
   # GOOD: Both
   complete -c r -s h -l help -d "Show help"
   ```

4. **Hardcode dynamic values**
   ```fish
   # BAD: Static list (becomes outdated)
   complete -c r -a "build test"
   
   # GOOD: Dynamically read from package.json
   complete -c r -a "(__runner_list_scripts)" -d "Available scripts"
   ```

5. **Ignore conditions**
   ```fish
   # BAD: Watches flag shows even for wrong command
   complete -c r -a "--watch"
   
   # GOOD: Only after build subcommand
   complete -c r -n '__fish_seen_subcommand_from build' \
       -a "--watch" -d "Watch for changes"
   ```

### DO

1. **Disable file completion explicitly** when not needed
2. **Document every flag** with description
3. **Use both short and long** flag versions
4. **Use dynamic completion** for values that change (scripts, files, etc.)
5. **Leverage conditions** for complex command structures

---

## Performance Notes

### Autoload Mechanism

Completion files are **automatically loaded** by Fish:
- No need to `source` manually
- Fish scans `~/.config/fish/completions/` on startup
- Custom completions take effect immediately

### Expensive Operations

Avoid expensive operations in completions (they run every time user presses TAB):

```fish
# BAD: Runs git every time user completes
complete -c clone -a "(git log --oneline | head -10)"

# BETTER: Cache or make it fast
complete -c clone -a "(__get_cached_repos)"
```

---

## Future Enhancements

- [ ] Dynamic script completion for runner (read package.json)
- [ ] Recent repository cache for clone
- [ ] Interactive editor detection and completion
- [ ] Advanced argument parsing for complex flags
- [ ] Bash-style completion fallback (if needed)

---

## Downlinks

- [Root AGENTS.md](../AGENTS.md) — Main project guidance
- [functions/AGENTS.md](../functions/AGENTS.md) — Function development guidance
- [docs/PLUGINS.md](../docs/PLUGINS.md) — Plugin development guide
- [docs/plugins/runner.md](../docs/plugins/runner.md) — Runner plugin docs
- [docs/plugins/clone.md](../docs/plugins/clone.md) — Clone plugin docs

---

## Questions?

Refer to:
- Fish official documentation: `man fish` → completions section
- Existing completions: `r.fish`, `clone.fish` — Real working examples
- Root [AGENTS.md](../AGENTS.md) — High-level project guidance

For AI assistants: Read this file before creating or modifying completions. Understand Fish's completion system. When adding new commands, create corresponding completion files immediately. Test completions interactively before committing.
