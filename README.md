# My Fish Shell Tools

A simple package of Fish shell utilities for JavaScript/TypeScript projects.

## Contents

- **r** - Quick runner for npm/yarn/pnpm/bun scripts with interactive selection

## Installation

### Option 1: Copy (Simplest)
```bash
git clone https://github.com/ribeiroevandro/my-fish-tools.git
cp my-fish-tools/functions/* ~/.config/fish/functions/
cp my-fish-tools/completions/* ~/.config/fish/completions/
```

### Option 2: Symlink (Live updates from repo)
```bash
git clone https://github.com/ribeiroevandro/my-fish-tools.git
ln -s $(pwd)/my-fish-tools/functions/r.fish ~/.config/fish/functions/r.fish
ln -s $(pwd)/my-fish-tools/functions/run.fish ~/.config/fish/functions/run.fish
ln -s $(pwd)/my-fish-tools/completions/r.fish ~/.config/fish/completions/r.fish
```

### Option 3: Fisher
```bash
fisher install ribeiroevandro/my-fish-tools
```

## Usage

After installation, restart Fish or source config:
```fish
source ~/.config/fish/config.fish
```

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
├── conf.d/         # Optional config files (install to ~/.config/fish/conf.d/)
├── README.md       # This file
└── CONTRIBUTING.md # Contributing guidelines
```

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on adding new functions and plugins.

## License

MIT
