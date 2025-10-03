#!/usr/bin/env bash
# tmux-kitsune.sh: Kitsune IDE Layout

SESSION_NAME="kitsune"
CLAUDE_CMD="claude"  # Command for Claude instance

# Kill existing session if it exists
tmux has-session -t $SESSION_NAME 2>/dev/null && tmux kill-session -t $SESSION_NAME

# Start new session with a single pane
tmux new-session -d -s $SESSION_NAME -n IDE

# ----------------------
# Step 1: Left pane (Ranger)
# ----------------------
tmux split-window -h -p 30  # Left pane = 30% width
tmux select-pane -t 0
tmux send-keys "ranger" C-m

# ----------------------
# Step 2: Right vertical split for Neovim / Terminal
# ----------------------
tmux select-pane -t 1
tmux split-window -v -p 70  # Top-right pane = 70% of right height
tmux select-pane -t 1
tmux send-keys "nvim" C-m

tmux select-pane -t 2
# Bottom-right pane = Terminal (no command, plain shell)

# ----------------------
# Step 3: Claude hidden pane
# ----------------------
tmux select-pane -t 0
tmux split-window -v -p 50  # Create additional pane (Claude) same size as left
tmux select-pane -t 3
tmux send-keys "$CLAUDE_CMD" C-m
tmux swap-pane -s 0 -t 3  # Swap with left pane
tmux kill-pane -t 3         # Hide Claude initially

# ----------------------
# Step 4: Final setup
# ----------------------
tmux select-pane -t 1  # Default focus on Neovim
tmux attach -t $SESSION_NAME

