# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a macOS dotfiles repository managed by [chezmoi](https://www.chezmoi.io/). The repository uses chezmoi's templating system to handle machine-specific configurations.

## Common Commands

```bash
# Apply changes to home directory
chezmoi apply

# Preview changes before applying
chezmoi diff

# Edit a managed file (opens in $EDITOR)
chezmoi edit ~/.zshrc

# Go to source directory
chezmoi cd

# Regenerate completion cache manually
~/.config/zsh/generate-completions.sh
rm -f ~/.zcompdump && exec zsh
```

## Repository Structure

### Chezmoi Naming Conventions

- `dot_` prefix → `.` (e.g., `dot_zshrc.tmpl` → `~/.zshrc`)
- `private_dot_config/` → `~/.config/`
- `executable_` prefix → file gets execute permission
- `.tmpl` suffix → processed as Go template with chezmoi data

### Template Variables

Defined in `.chezmoi.toml.tmpl` and prompted on first run:
- `{{ .email }}` - User email
- `{{ .name }}` - Full name
- `{{ .isWork }}` - Boolean for work machine
- `{{ .chezmoi.homeDir }}` - Home directory path

### Automatic Scripts (`.chezmoiscripts/`)

- `run_onchange_brew-bundle.sh.tmpl` - Runs `brew bundle` when `dot_Brewfile` changes (uses hash in comment)
- `run_after_generate-completions.sh.tmpl` - Generates zsh completion cache after each apply

## Key Configuration Files

| Source | Target | Purpose |
|--------|--------|---------|
| `dot_zshrc.tmpl` | `~/.zshrc` | Main shell config with PATH, aliases, lazy-loading |
| `dot_Brewfile` | `~/.Brewfile` | Homebrew packages, casks, VSCode extensions |
| `private_dot_config/sheldon/plugins.toml` | `~/.config/sheldon/plugins.toml` | zsh plugin manager |
| `private_dot_config/starship.toml` | `~/.config/starship.toml` | Prompt theme |
| `private_dot_config/aqua.yaml` | `~/.config/aqua.yaml` | CLI tool versions |

## Version Managers

- **Volta** - Node.js (`~/.volta`)
- **pyenv** - Python (`~/.pyenv`)
- **rbenv** - Ruby
- **aqua** - CLI tools (`~/.config/aqua.yaml`)
- **mise** - Multi-language runtime manager
