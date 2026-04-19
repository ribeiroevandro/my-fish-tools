# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Planned
- Additional plugin templates and examples
- Enhanced error handling in helpers
- CI/CD workflow optimization

---

## [1.0.0] - 2026-04-19

### Added
- **Runner plugin** (`r`/`run`): Quick executor for npm/yarn/pnpm/bun scripts
  - Auto-detects package manager from lockfiles (pnpm-lock.yaml, yarn.lock, bun.lockb)
  - Interactive mode with `gum` for script selection
  - Direct execution mode for scripting and CI/CD
  - TAB completion support
  - Proper argument forwarding to scripts (handles yarn's no `--` requirement)
  - Comprehensive exit codes and error handling

- **Clone plugin** (`clone`): Interactive git clone with editor opening
  - Dynamic editor detection (macOS, Linux, and cross-platform)
  - Auto-extract repository name from URL
  - Existing directory handling with git pull option
  - Optional auto-cd into cloned directory
  - Support for custom folder names
  - TAB completion for editors and flags
  - Handles git@ and https:// URLs

- **Project structure**:
  - Helper functions with double-underscore + plugin prefix convention
  - Each helper in its own autoload file for Fish shell
  - TAB completion files for both plugins
  - Comprehensive plugin documentation

- **Installation methods**:
  - Fisher (recommended)
  - Oh My Fish
  - Manual installation

- **Documentation**:
  - Complete README with quick start and examples
  - Per-plugin detailed documentation
  - Plugin development guide (docs/PLUGINS.md)
  - Plugin template for new contributions (docs/PLUGIN_TEMPLATE.md)
  - Contributing guidelines
  - Copilot instructions for AI-assisted development

- **Project standards**:
  - Conventional Commits conventions
  - Git squash-merge workflow
  - MIT License
  - Development contribution guidelines

### Changed
- Initial release - no prior versions

### Fixed
- Initial release - no prior versions

### Removed
- Initial release - no prior versions

### Deprecated
- None

### Security
- None reported

---

## Version History Context

### Pre-1.0.0 Development (Prior Versions)
- Initial repository setup with README and license
- Runner plugin implementation with helpers and completion
- Plugin documentation structure and standards
- Clone plugin with editor detection and git integration
- Documentation improvements and corrections
- Release process and versioning implementation

---

## Release Information

### Version: 1.0.0
- **Release Date**: 2026-04-19
- **Status**: Stable
- **Stability**: Production-ready
- **Plugins**: 2 (Runner, Clone)

### Compatibility
- **Fish Shell**: 3.1.0+
- **Platforms**: macOS, Linux
- **Dependencies**:
  - Runner: `jq` (required), `gum` (optional for interactive mode)
  - Clone: `gum` (required)

### Installation
```fish
fisher install ribeiroevandro/my-fish-tools
```

### Known Limitations
- None identified in this release

### Future Planning
- v1.1.0: Additional utility plugins
- v2.0.0: Plugin system enhancements
- Future: Performance optimizations and expanded platform support

---

## Contributing

To contribute to this project, please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

Release process documentation is available in [docs/RELEASE_PROCESS.md](docs/RELEASE_PROCESS.md).

---

## Links

- [Repository](https://github.com/ribeiroevandro/my-fish-tools)
- [Runner Plugin Documentation](docs/plugins/runner.md)
- [Clone Plugin Documentation](docs/plugins/clone.md)
- [Release Process](docs/RELEASE_PROCESS.md)
