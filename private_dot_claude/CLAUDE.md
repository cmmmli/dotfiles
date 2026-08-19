When executing commands, never prepend comments (e.g., `# doing something`) before the command. Execute commands directly without any inline or preceding comments.

# Development Environment from ~/.zshrc

## Tool Management
- Homebrew (`~/.Brewfile`): casks, compiled tools (git, zsh, neovim, php, postgresql), general-purpose CLIs
- mise (`~/.config/mise/config.toml`): language runtimes (node, python, go, bun, pnpm) and version-pinned CLIs (terraform, kubectl, helm, k9s, ...)
- aqua: binary only, for work repositories that ship their own `aqua.yaml`

## Environment Settings
- Locale: ja_JP.UTF-8
- Default editor: vim
- pnpm with dedicated PATH: `~/Library/pnpm`

# Git Configuration Highlights from ~/.gitconfig

- Default branch: main
- Pull with rebase by default
- Auto-setup remote when pushing
- Better diff algorithm (histogram)
- Auto-squash and auto-stash for rebase
- Conflict style: zdiff3 (shows 3-way merge conflicts clearly)

# GitHub PR Rules
- PR titles should be written in English according to conventional commits.
- PR body should be written in Japanese.

# Communication Language Settings
- **Internal thinking and processing**: Use English for efficient reasoning and problem-solving
- **User communication**: Always respond in Japanese
  - All responses, questions, confirmations, and explanations should be in Japanese
  - Use natural and polite Japanese language
  - Explain technical content clearly in Japanese
  - Technical terms and code-related terminology can remain in English when appropriate (e.g., function names, API endpoints, error messages)

