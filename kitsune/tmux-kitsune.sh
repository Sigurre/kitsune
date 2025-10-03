#!/usr/bin/env bash
# Launch or attach to a tmux Kitsune session with Ranger, Neovim, Shell, and Claude (hidden)

SESSION="kitsune"
DIR="${1:-$HOME}"

tmux has-session -t $SESSION 2>/dev/null
if [ $? != 0 ]; then
  # Create session
  tmux new-session -d -s $SESSION -c "$DIR" -n editor

  # --- Right side: Neovim pane (main editor) ---
  tmux split-window -h -p 70 -t $SESSION:0 -c "$DIR"
  tmux send-keys -t $SESSION:0.1 'nvim' C-m
  tmux select-pane -T "nvim"

  # --- Bottom: Shell pane ---
  tmux split-window -v -p 25 -t $SESSION:0.1 -c "$DIR"
  tmux select-pane -T "shell"

  # --- Left side: Ranger pane ---
  tmux select-pane -t $SESSION:0.0
  tmux send-keys -t $SESSION:0.0 'ranger' C-m
  tmux select-pane -T "ranger"

  # --- Create Claude pane (same size as Ranger) ---
  tmux split-window -h -p 30 -t $SESSION:0 -c "$DIR"
  tmux send-keys -t $SESSION:0.3 'claude' C-m
  tmux select-pane -T "Claude"

  # --- Swap Ranger and Claude so Claude is hidden ---
  tmux swap-pane -s $SESSION:0.0 -t $SESSION:0.3

  # Focus Neovim at startup
  tmux select-pane -t $SESSION:0.1
fi

# Attach to session
tmux attach -t $SESSION
