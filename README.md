# 🐟 My Fish Tools

[![CI](https://github.com/ribeiroevandro/my-fish-tools/actions/workflows/ci.yml/badge.svg)](https://github.com/ribeiroevandro/my-fish-tools/actions/workflows/ci.yml)

A collection of Fish shell plugins for everyday developer workflows.

| Plugin | Command     | Description                                              | Docs                                 |
| ------ | ----------- | -------------------------------------------------------- | ------------------------------------ |
| Runner | `r` / `run` | Run npm/yarn/pnpm/bun scripts with interactive selection | [📖 Details](docs/plugins/runner.md) |
| Clone  | `clone`     | Interactive git clone with editor opening                | [📖 Details](docs/plugins/clone.md)  |

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

| Tool                                        | Required by                      | Install            |
| ------------------------------------------- | -------------------------------- | ------------------ |
| [gum](https://github.com/charmbracelet/gum) | Runner (interactive mode), Clone | `brew install gum` |
| [jq](https://jqlang.github.io/jq/)          | Runner                           | `brew install jq`  |

> On Linux, replace `brew` with your system package manager (`apt`, `dnf`, `pacman`, etc).

---

## 🏃 Runner

Quick executor for project scripts. Auto-detects your package manager from the lockfile.

```fish
r                     # Interactive: pick a script with gum
r dev                 # Direct: run "dev" script
r test -- --watch     # Forward arguments to the script
run build             # "run" is an alias for "r"
```

📖 [Full documentation](docs/plugins/runner.md) — How it works, TAB completion, exit codes, and more.

---

## 📋 Clone

Interactive git clone with dynamic editor detection and optional directory navigation.

```fish
clone https://github.com/user/repo               # Interactive prompts
clone git@github.com:user/repo.git my-folder      # Custom folder name
clone https://github.com/user/repo code           # Open in VS Code
clone git@github.com:user/repo.git -C cursor      # Clone, cd in, open in Cursor
```

📖 [Full documentation](docs/plugins/clone.md) — Editor detection, configuration, exit codes, and more.

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
- [Development Guide](docs/PLUGINS.md) — How to create new plugins
- [Release Process](docs/RELEASE_PROCESS.md) — How to create releases
- [Changelog](CHANGELOG.md) — Version history and release notes

## Versioning

This project uses [Semantic Versioning](https://semver.org/).

Current version: **v1.0.0** ([Release Notes](https://github.com/ribeiroevandro/my-fish-tools/releases/tag/v1.0.0))

For a complete version history, see the [CHANGELOG](CHANGELOG.md).

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

[MIT](LICENSE)
