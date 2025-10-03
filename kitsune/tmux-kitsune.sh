
#!/usr/bin/env bash
# Kitsune tmux IDE launcher
# Layout:
#  -------------------------------
# |           |                   |
# |  Ranger   |      Neovim       |
# |           |                   |
#  -------------------------------
# |           Terminal (bottom)   |
#  -------------------------------
# Hidden Claude pane (can swap with Ranger)

SESSION_NAME="kitsune"

# Check if tmux session exists
if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
    echo "Attaching to existing Kitsune session..."
    tmux attach -t "$SESSION_NAME"
    exit 0
fi

# Start new tmux session
tmux new-session -d -s "$SESSION_NAME" -n Terminal

# --- Bottom pane: terminal (current directory) ---
tmux send-keys -t "$SESSION_NAME":0 "cd $PWD" C-m

# --- Left pane: Ranger ---
tmux split-window -h -p 30 -t "$SESSION_NAME":0
tmux send-keys -t "$SESSION_NAME":0 "ranger" C-m
tmux select-pane -T "Ranger"

# --- Right pane: Neovim (majority of window) ---
tmux split-window -v -p 70 -t "$SESSION_NAME":0.1
tmux send-keys -t "$SESSION_NAME":0.1 "nvim" C-m
tmux select-pane -T "Neovim"

# --- Hidden Claude pane ---
tmux split-window -h -p 30 -t "$SESSION_NAME":0
tmux send-keys -t "$SESSION_NAME":0.2 "claude" C-m
tmux select-pane -T "Claude"
tmux swap-pane -s 0.0 -t 0.3   # Start hidden swap with Ranger
tmux select-pane -t 0.0         # Focus Ranger

# --- Status line configuration ---
tmux set-option -g status on
tmux set-option -g status-bg colour235
tmux set-option -g status-fg colour136
tmux set-option -g status-left "#[fg=green]Kitsune IDE #[fg=yellow]| #[fg=cyan]#S"
tmux set-option -g status-right "#[fg=cyan]%Y-%m-%d %H:%M #[fg=yellow]| #[fg=green]#(whoami)"

# --- Keybindings ---
tmux bind-key C swap-pane -s 0.0 -t 0.3    # Ctrl+C to swap Ranger ↔ Claude
tmux bind-key R source-file ~/.tmux.conf \; display "Reloaded Kitsune config"

tmux bind-key -n C-h select-pane -L
tmux bind-key -n C-j select-pane -D
tmux bind-key -n C-k select-pane -U
tmux bind-key -n C-l select-pane -R

# Start session attached
tmux attach -t "$SESSION_NAME"

