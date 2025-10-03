#!/usr/bin/env bash
# Kitsune Installer: fully automated setup for macOS (curl-friendly)
set -e

REPO_URL="https://github.com/Sigurre/kitsune.git"
INSTALL_DIR="$HOME/Kitsune"
BACKUP_DIR="$HOME/kitsune-backup/$(date +%Y-%m-%d-%H%M)"

# --- Pre-clean environment ---
echo "Running pre-clean uninstall..."
if [ -f "$HOME/Kitsune/uninstall.sh" ]; then
    bash "$HOME/Kitsune/uninstall.sh" --clean
else
    echo "No existing uninstall.sh found, attempting temporary uninstall..."
    TEMP_UNINSTALL="$HOME/.kitsune-temp-uninstall.sh"
    cat <<'EOF' > "$TEMP_UNINSTALL"
#!/usr/bin/env bash
set -e
SYMLINKS=(
    "$HOME/.zshrc"
    "$HOME/.tmux.conf"
    "$HOME/.config/nvim/init.lua"
    "$HOME/.config/ranger/rc.conf"
    "$HOME/.kitsune-shell/antigenrc"
    "$HOME/.kitsune-shell/aliases.sh"
    "$HOME/.kitsune-shell/functions.sh"
    "$HOME/.local/bin/kit"
)
for f in "${SYMLINKS[@]}"; do
    [ -L "$f" ] && rm "$f"
done
rm -rf "$HOME/Kitsune" "$HOME/.kitsune-shell" "$HOME/.antigen" "$HOME/.local/share/nvim/site/pack/packer"
EOF
    chmod +x "$TEMP_UNINSTALL"
    bash "$TEMP_UNINSTALL"
    rm "$TEMP_UNINSTALL"
fi

# --- Backup existing configs ---
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

# --- Clone repo if not present ---
if [ ! -d "$INSTALL_DIR" ]; then
    echo "Cloning Kitsune repo into $INSTALL_DIR..."
    git clone "$REPO_URL" "$INSTALL_DIR"
fi
DOTFILES_DIR="$INSTALL_DIR"

# --- Install dependencies via Homebrew ---
if ! command -v brew &>/dev/null; then
    echo "Homebrew not found. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
brew install neovim tmux ranger git curl

# --- Install Oh-My-Zsh ---
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh-My-Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# --- Install Antigen ---
if [ ! -f "$HOME/.antigen/antigen.zsh" ]; then
    echo "Installing Antigen..."
    mkdir -p "$HOME/.antigen"
    curl -L git.io/antigen > "$HOME/.antigen/antigen.zsh"
fi

# --- Install Packer.nvim ---
PACKER_DIR="$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim"
if [ ! -d "$PACKER_DIR" ]; then
    echo "Installing Packer.nvim..."
    git clone --depth 1 https://github.com/wbthomason/packer.nvim "$PACKER_DIR"
fi

# --- Setup dotfiles ---
mkdir -p ~/.kitsune-shell ~/.config/nvim ~/.config/ranger ~/.local/bin

ln -sf "$DOTFILES_DIR/shell/zshrc" ~/.zshrc
ln -sf "$DOTFILES_DIR/shell/antigenrc" ~/.kitsune-shell/antigenrc
ln -sf "$DOTFILES_DIR/shell/aliases.sh" ~/.kitsune-shell/aliases.sh
ln -sf "$DOTFILES_DIR/shell/functions.sh" ~/.kitsune-shell/functions.sh

ln -sf "$DOTFILES_DIR/nvim/init.lua" ~/.config/nvim/init.lua
ln -sf "$DOTFILES_DIR/ranger/rc.conf" ~/.config/ranger/rc.conf
ln -sf "$DOTFILES_DIR/tmux/tmux.conf" ~/.tmux.conf

# Kit launcher
if [ ! -f "$DOTFILES_DIR/bin/kit" ]; then
    echo "Error: kit launcher not found in repo"
    exit 1
fi
ln -sf "$DOTFILES_DIR/bin/kit" ~/.local/bin/kit
chmod +x "$DOTFILES_DIR/kitsune/tmux-kitsune.sh"  # ensure tmux script is executable
chmod +x ~/.local/bin/kit

# Add ~/.local/bin to PATH if missing
if ! grep -q "$HOME/.local/bin" "$HOME/.zshrc"; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc"
    echo "Added ~/.local/bin to PATH in ~/.zshrc"
fi

echo "======================================"
echo "Kitsune installation complete!"
echo "- Old files backed up at: $BACKUP_DIR"
echo "- 'kit' launcher installed at ~/.local/bin/kit"
echo "- Please restart terminal or run 'source ~/.zshrc'"
echo "======================================"
