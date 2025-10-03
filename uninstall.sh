#!/usr/bin/env bash
# Kitsune Uninstaller
# Removes all Kitsune files, symlinks, and optionally restores from backup

set -e

# Default options
CLEAN=false
BACKUP_DIR="$HOME/kitsune-backup/latest"

# Parse arguments
for arg in "$@"; do
    case $arg in
        --clean)
            CLEAN=true
            shift
            ;;
        *)
            echo "Usage: $0 [--clean]"
            exit 1
            ;;
    esac
done

echo "=== Kitsune Uninstaller ==="

# 1️⃣ Remove symlinks
echo "Removing symlinks..."
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
    if [ -L "$f" ]; then
        rm "$f"
        echo "Removed symlink: $f"
    fi
done

# 2️⃣ Remove Kitsune repo folder
KITSUNE_DIR="$HOME/Kitsune"
if [ -d "$KITSUNE_DIR" ]; then
    if [ "$CLEAN" = true ]; then
        echo "Removing Kitsune repo folder..."
        rm -rf "$KITSUNE_DIR"
    else
        echo "Preserving Kitsune repo at $KITSUNE_DIR"
    fi
fi

# 3️⃣ Restore backups if not clean
if [ "$CLEAN" = false ]; then
    if [ -d "$BACKUP_DIR" ]; then
        echo "Restoring backup files from $BACKUP_DIR..."
        cp -r "$BACKUP_DIR/." "$HOME/"
    else
        echo "No backup found at $BACKUP_DIR"
    fi
else
    echo "Clean uninstall selected: no backup restored."
fi

# 4️⃣ Optional: remove shell folder
if [ "$CLEAN" = true ]; then
    if [ -d "$HOME/.kitsune-shell" ]; then
        rm -rf "$HOME/.kitsune-shell"
        echo "Removed ~/.kitsune-shell"
    fi
fi

# 5️⃣ Optional: remove Packer and Antigen
if [ "$CLEAN" = true ]; then
    if [ -d "$HOME/.local/share/nvim/site/pack/packer" ]; then
        rm -rf "$HOME/.local/share/nvim/site/pack/packer"
        echo "Removed Packer.nvim"
    fi
    if [ -d "$HOME/.antigen" ]; then
        rm -rf "$HOME/.antigen"
        echo "Removed Antigen"
    fi
fi

echo "=== Kitsune uninstall complete! ==="
echo "If not using --clean, your previous dotfiles should have been restored."
