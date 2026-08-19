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

All scripts are `after_` scripts (run once every file has been applied) and execute in numeric-prefix order:

- `run_onchange_after_00-brew-bundle.sh.tmpl` - Trusts the taps listed in the Brewfile (`brew trust --tap`, required by Homebrew 6+) and runs `brew bundle` when `dot_Brewfile` changes (uses hash in comment)
- `run_onchange_after_10-mise-install.sh.tmpl` - Runs `mise install` when `private_dot_config/mise/config.toml` changes (same hash trick)
- `run_after_20-generate-completions.sh.tmpl` - Generates zsh completion cache after each apply

Note: chezmoi applies entries in alphabetical order of target path, and `.chezmoiscripts/...` sorts before `.config/...`, so plain `run_onchange_` scripts would run before their config files are written. Keep them `after_`.

## Key Configuration Files

| Source | Target | Purpose |
|--------|--------|---------|
| `dot_zprofile` | `~/.zprofile` | Login-shell config: Homebrew shellenv + mise shims (so non-interactive shells / IDEs see mise tools) |
| `dot_zshrc.tmpl` | `~/.zshrc` | Main shell config with PATH, aliases, lazy-loading |
| `dot_Brewfile` | `~/.Brewfile` | Homebrew: casks, compiled tools, general-purpose CLIs |
| `private_dot_config/mise/config.toml` | `~/.config/mise/config.toml` | mise: language runtimes and version-pinned CLIs (node, python, go, terraform, kubectl, ...) |
| `private_dot_config/sheldon/plugins.toml` | `~/.config/sheldon/plugins.toml` | zsh plugin manager |
| `private_dot_config/starship.toml` | `~/.config/starship.toml` | Prompt theme |

## Tool Management Policy

- **Homebrew** (`dot_Brewfile`) - casks, compiled tools (git, zsh, neovim, php, postgresql), general-purpose CLIs that can always be latest (bat, fd, jq, gh, ...)
- **mise** (`private_dot_config/mise/config.toml`) - language runtimes (node, python, go, bun, pnpm) and CLIs whose version matters per project (terraform, kubectl, helm, k9s, ...). Project-level `mise.toml` / `.mise.toml` overrides the global config.
- **aqua** - binary only, for work repositories that ship their own `aqua.yaml`. No global aqua config.
- Volta / pyenv / rbenv are no longer used.

## Bypass Guard

`private_dot_config/zsh/chezmoi-guard.zsh` wraps `brew` and `mise` so that operations
which bypass the chezmoi flow ask for confirmation first:

| Command | Canonical route |
|---------|-----------------|
| `brew install` / `uninstall` / `remove` / `rm` / `tap` / `untap` | `chezmoi edit ~/.Brewfile` → `chezmoi apply` |
| `mise use -g` / `mise use --global` / `mise global` | `chezmoi edit ~/.config/mise/config.toml` → `chezmoi apply` |

Two constraints keep the guard from doing damage:

- It **passes through silently in non-interactive shells** (`[[ -t 0 ]]`). Without a tty
  `read` hits EOF and returns "no", which would turn the confirmation into a silent
  failure for scripts, CI, and the `run_onchange_after_00-brew-bundle.sh` script itself.
- It must be sourced **after** `eval "$(mise activate zsh)"` — mise's activate output
  starts with `unset -f mise`, so any earlier wrapper is destroyed. The guard copies
  mise's own function to `__chezmoi_guard_mise_orig` and delegates to it.

Claude Code's Bash tool is non-interactive, so it never sees the prompt. It is covered
separately by `permissions.ask` in `~/.claude/settings.json` (not chezmoi-managed).
