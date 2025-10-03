#!/bin/bash

# Define dotfiles directory
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Ensure kit is executable
chmod +x "$HOME/.local/bin/kit"

# Install missing dependencies
if ! command -v brew &>/dev/null; then
  echo "Homebrew not found. Installing..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

brew install antigen neovim tmux ranger

# Install Packer.nvim for Neovim
if [ ! -d "$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim" ]; then
  echo "Installing Packer.nvim..."
  git clone --depth 1 https://github.com/wbthomason/packer.nvim \
    "$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim"
fi

# Install Antigen
if [ ! -f "$HOME/.antigen/antigen.zsh" ]; then
  echo "Installing Antigen..."
  curl -L git.io/antigen > "$HOME/.antigen/antigen.zsh"
fi

# Backup existing dotfiles
mkdir -p "$HOME/legacy"
for file in .zshrc .vimrc .tmux.conf .config/nvim/init.vim; do
  if [ -e "$HOME/$file" ]; then
    mv "$HOME/$file" "$HOME/legacy/"
  fi
done

# Create symlinks for new dotfiles
ln -sf "$DOTFILES_DIR/shell/.zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES_DIR/nvim/init.lua" "$HOME/.config/nvim/init.lua"
ln -sf "$DOTFILES_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"

# Add ~/.local/bin to PATH if not already present
if ! grep -q "$HOME/.local/bin" "$HOME/.zshrc"; then
  echo "export PATH=\"$HOME/.local/bin:\$PATH\"" >> "$HOME/.zshrc"
fi

echo "Installation complete. Please restart your terminal or run 'source ~/.zshrc'."

