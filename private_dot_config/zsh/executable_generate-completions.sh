#!/bin/bash
# Completion files generator
# Run this script when you install new CLI tools or update existing ones
# Usage: ./generate-completions.sh

set -e

CACHE_DIR="${HOME}/.zfunc"
mkdir -p "$CACHE_DIR"

echo "Generating completion files to $CACHE_DIR ..."

# kubectl (最も時間がかかる: ~3秒)
if command -v kubectl &> /dev/null; then
  echo "  - kubectl"
  kubectl completion zsh > "$CACHE_DIR/_kubectl"
fi

# gh (GitHub CLI)
if command -v gh &> /dev/null; then
  echo "  - gh"
  gh completion -s zsh > "$CACHE_DIR/_gh"
fi

# skaffold
if command -v skaffold &> /dev/null; then
  echo "  - skaffold"
  skaffold completion zsh > "$CACHE_DIR/_skaffold"
fi

# op (1Password CLI)
if command -v op &> /dev/null; then
  echo "  - op"
  op completion zsh > "$CACHE_DIR/_op"
fi

echo "Done! Completions cached in $CACHE_DIR"
echo ""
echo "To apply changes, restart your shell or run:"
echo "  rm -f ~/.zcompdump && exec zsh"
