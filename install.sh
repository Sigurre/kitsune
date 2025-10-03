#!/usr/bin/env bash
# Kitsune Installer: installs IDE + trimmed dotfiles + backups

set -e
DOTFILES_DIR=$(cd "$(dirname "$0")" && pwd)
BACKUP_DIR="$HOME/kitsune-backup/$(date +%Y-%m-%d-%H%M)"

mkdir -p "$BACKUP_DIR"
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.kitsune-shell"

echo "Backing up existing files to $BACKUP_DIR ..."

FILES_TO_BACKUP=(~/.zshrc ~/.tmux.conf ~/.config/nvim/init.lua ~/.config/ranger/rc.conf)
for f in "${FILES_TO_BACKUP[@]}"; do
  if [ -e "$f" ]; then
    mkdir -p "$BACKUP_DIR$(dirname "$f")"
    cp -r "$f" "$BACKUP_DIR$f"
    echo "Backed up $f"
  fi
done

# Symlink shell configs
ln -sf "$DOTFILES_DIR/shell/zshrc" ~/.zshrc
ln -sf "$DOTFILES_DIR/shell/antigenrc" ~/.kitsune-shell/antigenrc
ln -sf "$DOTFILES_DIR/shell/aliases.sh" ~/.kitsune-shell/aliases.sh
ln -sf "$DOTFILES_DIR/shell/functions.sh" ~/.kitsune-shell/functions.sh

# Symlink nvim & ranger
mkdir -p ~/.config/nvim
ln -sf "$DOTFILES_DIR/nvim/init.lua" ~/.config/nvim/init.lua
mkdir -p ~/.config/ranger
ln -sf "$DOTFILES_DIR/ranger/rc.conf" ~/.config/ranger/rc.conf

# Symlink tmux
ln -sf "$DOTFILES_DIR/tmux/tmux.conf" ~/.tmux.conf

# Install kit launcher
ln -sf "$DOTFILES_DIR/bin/kit" ~/.local/bin/kit

echo "Installation complete! Old files are in $BACKUP_DIR."
echo "Run 'kit [directory]' to start Kitsune."
