# AGENTS.md — Functions Module

Guidance for developing plugins, main functions, and helpers in the `functions/` directory.

---

## Overview

The `functions/` directory contains all executable plugins for my-fish-tools:

- **Main functions** — User-facing commands like `r`, `clone`
- **Helpers** — Private functions that support main functions, using `__plugin_name_*` naming

This module is the **core implementation** of the project. All logic, validation, and business rules live here.

---

## File Structure

```
functions/
├── AGENTS.md (this file)
├── r.fish                             # Main: Runner entry point
├── run.fish                           # Main: Runner alias (thin wrapper)
├── __runner_detect_runner.fish        # Helper: Auto-detect package manager
├── __runner_list_scripts.fish         # Helper: Extract scripts from package.json
├── clone.fish                         # Main: Clone entry point
├── __clone_known_editors.fish         # Helper: List known editors
├── __clone_detect_editors.fish        # Helper: Detect installed editors
├── __clone_validate_url.fish          # Helper: Validate git URL format
└── __clone_extract_repo_name.fish     # Helper: Extract repo folder name
```

**Pattern**:
- **One main function per plugin** — `plugin_name.fish`
- **One helper per file** — `__plugin_name_purpose.fish`
- **No nested directories** — All files flat in `functions/`

---

## Key Concepts

### 1. Function Naming

**Main functions** (user-facing):
```fish
function r --description "Run a script in the current project"
    # Implementation
end
```

**Helper functions** (private):
```fish
function __runner_detect_runner --description "Auto-detect package manager"
    # Implementation
end
```

**Rules**:
- Main: lowercase, no underscores (e.g., `r`, `clone`)
- Helpers: double underscore prefix, plugin name, descriptive suffix (e.g., `__runner_detect_runner`)
- Never use single underscore — signals private in Fish but can collide

### 2. Helper Pattern

Each helper should:
- Be in its own autoload file (Fish autoloads automatically on first call)
- Have a single responsibility (one purpose per helper)
- Be called from main function or other helpers
- Return proper exit codes (0/1/2/127)

```fish
# Good: focused helper
function __runner_detect_runner
    # Only detect package manager
    set -l lockfile (find . -maxdepth 1 -type f -name "pnpm-lock.yaml" -o -name "yarn.lock" -o -name "bun.lockb")
    echo $lockfile
end

# Bad: too many responsibilities
function __runner_do_everything
    # Detect, list, execute, validate, retry... NO!
end
```

### 3. Error Handling

All functions must validate inputs and dependencies:

```fish
function r --description "Run a script"
    # 1. Check dependencies FIRST
    type -q jq; or begin
        echo "Error: jq is required for runner plugin" >&2
        return 127
    end

    # 2. Parse and validate arguments
    argparse 'h/help' 'v/verbose' -- $argv
    or return 2

    if set -q _flag_help
        echo "Usage: r [--verbose] [script]"
        return 0
    end

    # 3. Call helpers and check status
    set -l scripts (__runner_list_scripts)
    if test $status -ne 0
        echo "Error: could not read package.json" >&2
        return 1
    end

    # 4. Continue with logic...
end
```

**Exit codes**:
- `0` — Success
- `1` — User error (file not found, invalid input, etc.)
- `2` — Parse error (bad argument format)
- `127` — Missing dependency

### 4. Variable Scoping

**Always use `set -l`** for local variables:

```fish
# GOOD: explicitly local
function my_func
    set -l result "something"
    set -l count 5
    echo $result
end

# BAD: no scope specified (becomes global!)
function my_func
    set result "something"
    set count 5
    echo $result
end
```

Exceptions:
- `set -g` — Global (rarely needed, document why)
- `set -U` — Universal (persist across sessions, rare)
- `set -e` — Erase variable

### 5. Functions & Helpers: Interaction Pattern

```
┌─ Main Function (r.fish)
├─ Parse arguments
├─ Check dependencies
├─ Validate input
├─ Call helpers
│  ├─ __runner_detect_runner
│  ├─ __runner_list_scripts
│  └─ [more helpers]
├─ Process results
└─ Output and exit
```

**Never call main function from helper.** Helpers only call other helpers.

---

## Function Development Checklist

### When Creating a New Main Function

- [ ] Name is lowercase, descriptive, no underscores (e.g., `mycommand`)
- [ ] Includes `--description "..."` with clear purpose
- [ ] Checks all dependencies upfront with `type -q`
- [ ] Uses `argparse` for flag parsing
- [ ] Validates user input before processing
- [ ] Calls helpers for focused tasks
- [ ] Returns proper exit codes (0/1/2/127)
- [ ] Error messages go to stderr (`>&2`)
- [ ] Main logic documented with comments only where non-obvious
- [ ] Tested with `fish -n functions/mycommand.fish`

### When Creating a New Helper

- [ ] Name is `__pluginname_purpose` (double underscore)
- [ ] Includes `--description "..."` (briefly describes what it does)
- [ ] Single responsibility (one purpose)
- [ ] All local variables use `set -l`
- [ ] Returns proper exit codes
- [ ] Tested independently: `source functions/__pluginname_purpose.fish; __pluginname_purpose arg1 arg2`
- [ ] In its own file (one helper per file)

---

## Common Patterns

### Detecting Package Manager

```fish
function __runner_detect_runner --description "Auto-detect package manager from lockfile"
    if test -f pnpm-lock.yaml
        echo pnpm
    else if test -f yarn.lock
        echo yarn
    else if test -f bun.lockb
        echo bun
    else
        echo npm
    end
end
```

### Parsing JSON with jq

```fish
function __runner_list_scripts --description "Extract scripts from package.json"
    type -q jq; or return 127
    
    if not test -f package.json
        return 1
    end
    
    jq -r '.scripts | keys[]' package.json 2>/dev/null
    or return 1
end
```

### Interactive Menu with gum

```fish
function clone --description "Clone repository interactively"
    type -q gum; or begin
        echo "Error: gum is required" >&2
        return 127
    end
    
    set -l url (gum input --placeholder "Repository URL")
    or return 1
    
    set -l choice (gum choose "Open in editor" "Just clone" "Cancel")
    or return 1
end
```

### Argument Validation

```fish
function my_plugin --description "Does something"
    if test (count $argv) -eq 0
        echo "Error: at least one argument required" >&2
        return 1
    end
    
    set -l first_arg $argv[1]
    if not test -f "$first_arg"
        echo "Error: file '$first_arg' not found" >&2
        return 1
    end
end
```

---

## Testing

### Syntax Check (Quick)
```bash
fish -n functions/myplugin.fish
fish -n functions/__myplugin_helper.fish
```

### Load Test (Verify it runs)
```bash
fish -c "source functions/myplugin.fish; myplugin --help"
fish -c "source functions/__myplugin_helper.fish; __myplugin_helper arg"
```

### Manual Testing (Real scenarios)
```bash
fish              # Start interactive shell
r                # Test runner with no args
r build          # Test runner with script
clone --help     # Test clone with help flag
clone URL        # Test full clone flow
```

### Edge Cases to Test
- [ ] Missing dependencies (jq, gum) — should return 127
- [ ] Invalid arguments — should return 2 or 1
- [ ] Missing files/directories — should return 1
- [ ] Empty input — should handle gracefully
- [ ] Special characters in paths — should work
- [ ] Non-existent commands — should give clear error

---

## Anti-patterns (for this module)

### DON'T

1. **Use single underscore** — `_my_helper` is wrong
   ```fish
   # BAD
   function _runner_helper
   end
   
   # GOOD
   function __runner_helper
   end
   ```

2. **Use global variables** — `set result` without `-l`
   ```fish
   # BAD
   function my_func
       set result "value"  # Global!
   end
   
   # GOOD
   function my_func
       set -l result "value"  # Local
   end
   ```

3. **Skip error checking** — Don't assume tools exist
   ```fish
   # BAD
   function my_func
       jq '.name' file.json  # What if jq missing? What if file missing?
   end
   
   # GOOD
   function my_func
       type -q jq; or return 127
       test -f file.json; or return 1
       jq '.name' file.json
   end
   ```

4. **Call main function from helper** — Breaks separation
   ```fish
   # BAD
   function __helper_stuff
       r build  # NO! Helper shouldn't call main
   end
   
   # GOOD
   function __helper_stuff
       # Do one focused task, let caller decide next steps
   end
   ```

5. **Mix multiple responsibilities** — One file, one helper
   ```fish
   # BAD
   function __runner_do_everything
       # Detect, list, validate, execute... too much!
   end
   
   # GOOD
   function __runner_detect_runner
       # Just detect package manager
   end
   
   function __runner_list_scripts
       # Just list scripts
   end
   ```

6. **Forget documentation** — Every function needs description
   ```fish
   # BAD
   function my_func
       # No description! What does it do?
   end
   
   # GOOD
   function my_func --description "Extract username from email"
       # Now it's clear
   end
   ```

7. **Ignore exit codes** — Caller needs to know success/failure
   ```fish
   # BAD
   function my_func
       some_command
       echo "Done"  # Caller can't tell if it succeeded!
   end
   
   # GOOD
   function my_func
       some_command; or return 1
       echo "Done"
       return 0  # Clear success
   end
   ```

### DO

1. **Use double underscore** for helpers
2. **Always use `set -l`** for local variables
3. **Check dependencies upfront** with `type -q`
4. **Call helpers** for focused tasks
5. **One helper per file** — separate autoload files
6. **Include `--description`** for every function
7. **Check exit codes** from helpers: `command; or return $status`

---

## Performance Considerations

### Keep Functions Fast

- Avoid loops in Fish — use native tools (jq, grep, etc.)
- Cache results in helpers when appropriate
- Don't run external commands unnecessarily

```fish
# BAD: N calls to jq
for item in $list
    set name (jq ".name" $item)
    echo $name
end

# GOOD: Single jq call
jq '.[] | .name' $file
```

### Lazy Loading with Autoload

Fish automatically loads helpers on first call. This means:
- No startup cost (helpers only loaded when used)
- No need to `source` helpers manually
- Faster command startup

---

## File Naming Guidelines

### Main Functions
- lowercase, no underscores
- Examples: `r`, `clone`, `build`, `deploy`
- One main entry point per plugin

### Helpers
- `__pluginname_purpose.fish`
- Examples: `__runner_detect_runner.fish`, `__clone_validate_url.fish`
- One helper per file
- One responsibility per helper

### Aliases/Wrappers
- Thin wrapper calling main function
- Example: `run.fish` → calls `r`
- Keep wrapper minimal

---

## Downlinks

- [Root AGENTS.md](../AGENTS.md) — Main project guidance
- [completions/AGENTS.md](../completions/AGENTS.md) — TAB completion guidance
- [docs/PLUGINS.md](../docs/PLUGINS.md) — Plugin development guide
- [docs/plugins/runner.md](../docs/plugins/runner.md) — Runner plugin docs
- [docs/plugins/clone.md](../docs/plugins/clone.md) — Clone plugin docs

---

## Questions?

Refer to:
- Existing plugins: `r.fish`, `clone.fish` — Real examples to follow
- Existing helpers: `__runner_*.fish`, `__clone_*.fish` — Implementation patterns
- Root [AGENTS.md](../AGENTS.md) — High-level project guidance
- [CONTRIBUTING.md](../CONTRIBUTING.md) — Contribution guidelines

For AI assistants: Read this file before implementing functions or helpers. Understand the patterns and conventions first. When adding new functionality, extract helpers appropriately and follow the naming conventions.
