# 🐟 My Fish Tools

A collection of Fish shell plugins for everyday developer workflows.

| Plugin | Command | Description |
|--------|---------|-------------|
| [Runner](#-runner) | `r` / `run` | Run npm/yarn/pnpm/bun scripts with interactive selection |
| [Clone](#-clone) | `clone` | Interactive git clone with editor opening |

## Installation

### Fisher (Recommended)

```fish
fisher install ribeiroevandro/my-fish-tools
```

### Oh My Fish

```fish
omf install https://github.com/ribeiroevandro/my-fish-tools
```

## Dependencies

| Tool | Required by | Install |
|------|-------------|---------|
| [gum](https://github.com/charmbracelet/gum) | Runner (interactive mode), Clone | `brew install gum` |
| [jq](https://jqlang.github.io/jq/) | Runner | `brew install jq` |

> On Linux, replace `brew` with your system package manager (`apt`, `dnf`, `pacman`, etc).

---

## 🏃 Runner

Quick executor for project scripts. Auto-detects your package manager from the lockfile.

### Usage

```fish
r                     # Interactive: pick a script with gum
r dev                 # Direct: run "dev" script
r test -- --watch     # Forward arguments to the script
run build             # "run" is an alias for "r"
```

### How it works

1. Detects the package manager by checking for lockfiles (`pnpm-lock.yaml` → pnpm, `yarn.lock` → yarn, `bun.lockb` → bun, `package-lock.json` → npm)
2. Reads scripts from `package.json` via `jq`
3. Without arguments, shows an interactive menu via `gum choose`
4. With arguments, runs the script directly — forwards extra args with `--` separator (except yarn)

### TAB completion

Scripts from `package.json` are available via TAB completion:

```fish
r de<TAB>    # → r dev
```

📖 [Full documentation](docs/plugins/runner.md)

---

## 📋 Clone

Interactive git clone with dynamic editor detection and optional directory navigation.

### Usage

```fish
clone <url> [folder] [editor] [--enter|-C]
```

```fish
clone https://github.com/user/repo               # Interactive prompts
clone git@github.com:user/repo.git my-folder      # Custom folder name
clone https://github.com/user/repo code           # Open in VS Code
clone git@github.com:user/repo.git -C cursor      # Clone, cd in, open in Cursor
```

### How it works

1. Validates the URL (`git@` or `https://`)
2. If no editor specified → shows installed editors via `gum choose`
3. If editor specified but not installed → shows error and offers alternatives
4. If directory already exists → offers `git pull` instead
5. Asks to `cd` into the directory (or use `-C` to auto-enter)

### Editor detection

Automatically discovers installed editors by scanning:

- **macOS**: `/Applications/*.app`
- **Linux**: `/usr/share/applications/*.desktop`
- **Cross-platform**: CLI tools in `$PATH`

Currently recognized: VS Code, Cursor, Sublime Text, Zed, Fleet, Nova, IntelliJ IDEA, Vim, Neovim, Emacs, Nano, Atom.

### TAB completion

Installed editors and flags are available via TAB completion:

```fish
clone https://github.com/user/repo co<TAB>    # → code, cursor
```

📖 [Full documentation](docs/plugins/clone.md)

---

## Project Structure

```
my-fish-tools/
├── functions/          # One file per function (Fish autoload)
│   ├── r.fish
│   ├── run.fish
│   ├── clone.fish
│   ├── __runner_*.fish # Runner helpers
│   └── __clone_*.fish  # Clone helpers
├── completions/        # TAB completions
│   ├── r.fish
│   └── clone.fish
└── docs/               # Documentation
    ├── PLUGINS.md      # Plugin development guide
    └── plugins/        # Per-plugin docs
```

## Documentation

- [Plugin Index](docs/plugins/index.md) — All available plugins
- [Runner Plugin](docs/plugins/runner.md) — Detailed runner documentation
- [Clone Plugin](docs/plugins/clone.md) — Detailed clone documentation
- [Development Guide](docs/PLUGINS.md) — How to create new plugins

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

[MIT](LICENSE)
