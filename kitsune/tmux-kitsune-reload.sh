#!/usr/bin/env bash
# Reload IDE panes and restart apps

SESSION="kitsune"

# Kill existing panes if they exist
tmux kill-pane -t $SESSION:0.ranger 2>/dev/null
tmux kill-pane -t $SESSION:0.nvim 2>/dev/null
tmux kill-pane -t $SESSION:0.shell 2>/dev/null
tmux kill-pane -t $SESSION:0.Claude 2>/dev/null

# Relaunch Ranger
tmux respawn-pane -t $SESSION:0.ranger -k 'ranger'
# Relaunch Neovim
tmux respawn-pane -t $SESSION:0.nvim -k 'nvim'
# Relaunch Shell
tmux respawn-pane -t $SESSION:0.shell -k $SHELL
# Relaunch Claude
tmux respawn-pane -t $SESSION:0.Claude -k 'claude'
