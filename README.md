# My Fish Shell Tools

A simple package of Fish shell utilities for JavaScript/TypeScript projects.

## Contents

- **r** - Quick runner for npm/yarn/pnpm/bun scripts with interactive selection

## Installation

### Option 1: Fisher (Recommended)
If you use [Fisher](https://github.com/jorgebucaran/fisher) to manage your Fish plugins:

```fish
fisher install ribeiroevandro/my-fish-tools
```

### Option 2: Oh My Fish
If you use [Oh My Fish](https://github.com/oh-my-fish/oh-my-fish) to manage your Fish plugins:

```fish
omf install https://github.com/ribeiroevandro/my-fish-tools
```

After installation, reload your Fish configuration:
```fish
source ~/.config/fish/config.fish
```

## Usage

### Runner (r command)
```fish
r                # Interactive menu of scripts
r dev           # Run specific script
r build         # Another script
run test        # Alias for r
```

## Requirements

- **gum** - For interactive script selection
- **jq** - For parsing package.json

Install:
```bash
brew install gum jq  # macOS
sudo apt install gum jq  # Ubuntu/Debian
```

## Features

- Auto-detects package manager (npm, yarn, pnpm, bun)
- Interactive script selection with gum
- TAB completion support
- Works in any JavaScript/TypeScript project

## Structure

This package uses a flat directory structure that mirrors `~/.config/fish/`:

```
my-fish-tools/
├── functions/      # Fish functions (install to ~/.config/fish/functions/)
├── completions/    # TAB completions (install to ~/.config/fish/completions/)
├── docs/           # Plugin documentation
│   └── PLUGINS.md  # Plugin guide and how to add new ones
├── README.md       # This file
└── CONTRIBUTING.md # Contributing guidelines
```

## Plugin Documentation

For detailed information about plugins in my-fish-tools:
- **Plugin Index**: [docs/plugins/index.md](docs/plugins/index.md) - List of all available plugins
- **Runner Plugin**: [docs/plugins/runner.md](docs/plugins/runner.md) - Complete runner plugin documentation
- **Development Guide**: [docs/PLUGINS.md](docs/PLUGINS.md) - How to create new plugins and best practices

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on adding new functions and plugins.

## License

[MIT License](./LICENSE)
