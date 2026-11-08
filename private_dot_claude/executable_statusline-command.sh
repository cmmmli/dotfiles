#!/bin/bash
# Read JSON input from stdin
input=$(cat)

# Forward the payload to Orca when it is installed. Orca wants statusLine for itself,
# but only one command can be registered, so this script stays registered and relays.
# Orca's script exits at once outside an Orca pane and prints nothing.
ORCA_STATUSLINE="$HOME/.orca/agent-hooks/claude-statusline.sh"
if [ -x "$ORCA_STATUSLINE" ]; then
    printf '%s' "$input" | /bin/sh "$ORCA_STATUSLINE" >/dev/null 2>&1
fi

CURRENT_DIR=$(echo "$input" | jq -r '.workspace.current_dir')
MODEL_DISPLAY=$(echo "$input" | jq -r '.model.display_name')
CONTEXT_SIZE=$(echo "$input" | jq -r '.context_window.context_window_size')
USAGE=$(echo "$input" | jq '.context_window.current_usage')

# Show git branch if in a git repo
GIT_BRANCH=""
if git rev-parse --git-dir > /dev/null 2>&1; then
    BRANCH=$(git branch --show-current 2>/dev/null)
    if [ -n "$BRANCH" ]; then
        GIT_BRANCH=" | 🌿 $BRANCH"
    fi
fi

if [ "$USAGE" != "null" ]; then
    # Calculate current context from current_usage fields
    CURRENT_TOKENS=$(echo "$USAGE" | jq '.input_tokens + .cache_creation_input_tokens + .cache_read_input_tokens')
    PERCENT_USED=$((CURRENT_TOKENS * 100 / CONTEXT_SIZE))

    echo "[$MODEL_DISPLAY] 📁 ${CURRENT_DIR##*/}$GIT_BRANCH | 💾 Context: ${PERCENT_USED}%"
else
    echo "[$MODEL_DISPLAY] 📁 ${CURRENT_DIR##*/}$GIT_BRANCH | 💾 Context: 0%"
fi

