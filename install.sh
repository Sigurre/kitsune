#!/usr/bin/env bash
# Kitsune Installer: fully automated setup for macOS

set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="$HOME/kitsune-backup/$(date +%Y-%m-%d-%H%M)"

echo "Backing up existing configs to $BACKUP_DIR..."
mkdir -p "$BACKUP_DIR"

FILES_TO_BACKUP=(~/.zshrc ~/.tmux.conf ~/.config/nvim/init.lua ~/.config/ranger/rc.conf)
for f in "${FILES_TO_BACKUP[@]}"; do
  if [ -e "$f" ]; then
    mkdir -p "$BACKUP_DIR$(dirname "$f")"
    cp -r "$f" "$BACKUP_DIR$f"
    echo "Backed up $f"
  fi
done

# Ensure ~/.local/bin exists
mkdir -p "$HOME/.local/bin"

# Symlink launcher and make it executable
ln -sf "$DOTFILES_DIR/bin/kit" "$HOME/.local/bin/kit"
chmod +x "$HOME/.local/bin/kit"

# Add ~/.local/bin to PATH if missing
if ! grep -q "$HOME/.local/bin" "$HOME/.zshrc"; then
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc"
  echo "Added ~/.local/bin to PATH in ~/.zshrc"
fi

# --- Install dependencies via Homebrew (macOS) ---
if ! command -v brew &>/dev/null; then
  echo "Homebrew not found. Installing..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

brew install neovim tmux ranger git curl

# --- Install Oh-My-Zsh if missing ---
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing Oh-My-Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# --- Install Antigen if missing ---
if [ ! -f "$HOME/.antigen/antigen.zsh" ]; then
  echo "Installing Antigen..."
  mkdir -p "$HOME/.antigen"
  curl -L git.io/antigen > "$HOME/.antigen/antigen.zsh"
fi

# --- Install Packer.nvim for Neovim ---
PACKER_DIR="$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim"
if [ ! -d "$PACKER_DIR" ]; then
  echo "Installing Packer.nvim..."
  git clone --depth 1 https://github.com/wbthomason/packer.nvim "$PACKER_DIR"
fi

# --- Setup dotfiles ---
mkdir -p ~/.kitsune-shell
mkdir -p ~/.config/nvim
mkdir -p ~/.config/ranger

ln -sf "$DOTFILES_DIR/shell/zshrc" ~/.zshrc
ln -sf "$DOTFILES_DIR/shell/antigenrc" ~/.kitsune-shell/antigenrc
ln -sf "$DOTFILES_DIR/shell/aliases.sh" ~/.kitsune-shell/aliases.sh
ln -sf "$DOTFILES_DIR/shell/functions.sh" ~/.kitsune-shell/functions.sh

ln -sf "$DOTFILES_DIR/nvim/init.lua" ~/.config/nvim/init.lua
ln -sf "$DOTFILES_DIR/ranger/rc.conf" ~/.config/ranger/rc.conf
ln -sf "$DOTFILES_DIR/tmux/tmux.conf" ~/.tmux.conf

echo
echo "======================================"
echo "Kitsune installation complete!"
echo "- Old files backed up at: $BACKUP_DIR"
echo "- 'kit' launcher installed at ~/.local/bin/kit"
echo "- Please restart your terminal or run 'source ~/.zshrc'"
echo "  to activate aliases, prompt, and plugins."
echo "Run 'kit [directory]' to launch Kitsune IDE."
echo "======================================"

