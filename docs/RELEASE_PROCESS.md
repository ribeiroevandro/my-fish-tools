# Release Process for my-fish-tools

This document describes how to create and publish releases for the my-fish-tools project.

## Overview

We use **Semantic Versioning** with the following approach:

- **Git tags**: Annotated tags in the format `v1.0.0`
- **CHANGELOG**: [Keep a Changelog](https://keepachangelog.com) format
- **GitHub Releases**: Release notes on GitHub
- **Commit convention**: [Conventional Commits](https://www.conventionalcommits.org)

---

## Version Bumping Strategy

Based on [Semantic Versioning](https://semver.org):

- **MAJOR** (v2.0.0): Breaking changes, incompatible API changes
  - When: `BREAKING CHANGE:` in commit footer
  - Example: Restructure helper naming convention

- **MINOR** (v1.1.0): New features, backwards compatible
  - When: `feat:` commits are made
  - Example: Add new plugin

- **PATCH** (v1.0.1): Bug fixes, backwards compatible
  - When: `fix:` commits are made
  - Example: Fix bug in existing plugin

---

## Release Checklist

### Pre-Release (1-2 days before)

- [ ] Review all merged PRs since last release
- [ ] Check that all issues are resolved or documented
- [ ] Ensure documentation is up to date
- [ ] Verify tests pass (if applicable)
- [ ] Decide on version number using semver

### Creating a Release

#### Step 1: Update CHANGELOG.md

1. Create new section for the version at the top:

   ```markdown
   ## [1.0.1] - 2026-04-20

   ### Added

   - New feature description

   ### Fixed

   - Bug fix description

   ### Changed

   - Change description
   ```

2. Update the `[Unreleased]` section to mark it as released

3. Ensure all changes are documented in the appropriate section (Added, Fixed, Changed, etc.)

**Commit format**:

```bash
git add CHANGELOG.md
git commit -m "chore(release): prepare v1.0.1 changelog"
```

#### Step 2: Create Git Tag

```bash
git tag -a v1.0.1 -m "Release v1.0.1: Bug fixes and documentation improvements"
```

**Tag message format**:

```
Release v1.0.1: [Brief description of release highlights]

Highlights:
- Feature 1
- Feature 2
- Bug fix 1
```

**Verify the tag**:

```bash
git tag -l -n1 v1.0.1
```

#### Step 3: Push Tag to Remote

```bash
git push origin v1.0.1
```

**Verify on GitHub**:

```bash
git ls-remote --tags origin | grep v1.0.1
```

#### Step 4: Create GitHub Release

**Option A: Using GitHub CLI**

```bash
gh release create v1.0.1 \
  --title "Release v1.0.1" \
  --notes-file CHANGELOG_SECTION.md
```

**Option B: Manual (GitHub Web Interface)**

1. Go to https://github.com/ribeiroevandro/my-fish-tools/releases
2. Click "Draft a new release"
3. Select tag: v1.0.1
4. Title: "Release v1.0.1"
5. Description: Copy relevant section from CHANGELOG.md
6. Click "Publish release"

### Post-Release

- [ ] Verify release appears on GitHub
- [ ] Test installation from GitHub (not required, just optional verification)
- [ ] Close any related issues
- [ ] Announce release (if applicable)

---

## Example Release Workflow

### Scenario: Release v1.1.0 with new plugin

```bash
# 1. Ensure main is up to date
git checkout main
git pull origin main

# 2. Update CHANGELOG.md
# Edit CHANGELOG.md and add v1.1.0 section
# ...edit file...

# 3. Commit changelog
git add CHANGELOG.md
git commit -m "chore(release): prepare v1.1.0 changelog"

# 4. Create annotated tag
git tag -a v1.1.0 -m "Release v1.1.0: Add new utility plugin"

# 5. Push tag
git push origin v1.1.0

# 6. Create GitHub Release (using gh CLI)
gh release create v1.1.0 --title "Release v1.1.0: New utility plugin" \
  --notes "- Add new utility plugin with helpers\n- Improve documentation\n- Bug fixes"

# 7. Verify
git tag -l -n1 v1.1.0
gh release view v1.1.0
```

---

## CHANGELOG Format Guide

### Section Types

Use these sections in CHANGELOG.md:

- **Added**: New features
- **Changed**: Changes to existing features
- **Deprecated**: Soon-to-be removed features
- **Removed**: Removed features
- **Fixed**: Bug fixes
- **Security**: Security fixes

### Example Entry

```markdown
## [1.1.0] - 2026-05-01

### Added

- New plugin: Database utilities (`db` command)
- Helper functions for common DB operations
- TAB completion for DB commands

### Changed

- Improved error messages in Runner plugin
- Updated documentation structure

### Fixed

- Fix Clone plugin crash on invalid URLs
- Fix Runner plugin timeout on large scripts

### Security

- None reported
```

---

## Automated Versioning (Optional)

For future automation, consider:

1. **Git hooks**: Pre-commit hook to validate CHANGELOG format
2. **CI/CD**: GitHub Actions to validate tags match releases
3. **Scripts**: Shell script to automate changelog generation from git log

Example automated workflow:

```bash
# Generate changelog from conventional commits
git log v1.0.0..HEAD --oneline --grep="feat\|fix\|BREAKING" > /tmp/changelog_entries.txt

# Parse and format into CHANGELOG.md
# (requires custom script)
```

---

## Troubleshooting

### Problem: Accidentally created lightweight tag instead of annotated

```bash
# Delete lightweight tag
git tag -d v1.0.1

# Create annotated tag properly
git tag -a v1.0.1 -m "Release v1.0.1"
```

### Problem: Tag push failed

```bash
# Verify tag exists locally
git tag -l v1.0.1

# Force push if necessary (use with caution)
git push origin v1.0.1 --force
```

### Problem: Need to update tag message after creation

```bash
# Delete and recreate tag (only if not pushed yet)
git tag -d v1.0.1
git tag -a v1.0.1 -m "Updated message"

# Or create new tag and delete old one
git tag -a v1.0.1-new -m "New message"
git tag -d v1.0.1
git tag -m v1.0.1-new v1.0.1
git push origin :refs/tags/v1.0.1  # Delete remote
git push origin v1.0.1
```

---

## Best Practices

✅ **DO**

- Use annotated tags (not lightweight)
- Update CHANGELOG.md in the same commit as the tag
- Use Conventional Commits in your PRs
- Create one release per version
- Tag only on main branch after merging PRs
- Write clear release notes

❌ **DON'T**

- Create tags for every commit
- Use tags with inconsistent formats
- Skip CHANGELOG updates
- Tag directly from feature branches
- Create releases without documentation
- Delete tags once pushed to remote (unless absolutely necessary)

---

## Version History

| Version | Date       | Major Changes                                 |
| ------- | ---------- | --------------------------------------------- |
| 1.0.0   | 2026-04-19 | Initial release with Runner and Clone plugins |

---

## Questions?

For more information:

- See [CONTRIBUTING.md](../CONTRIBUTING.md) for contribution guidelines
- See [CHANGELOG.md](../CHANGELOG.md) for version history
- See [README.md](../README.md) for installation and usage
