# Kitsune Terminal IDE

**Launcher:** `kit [directory]`

---

## Layout

- Left pane: Ranger (file browser)
- Top-right: Neovim
- Bottom: Shell
- Hidden pane: Claude (swap with Ranger)

---

## Tmux Keybindings

- `prefix + C` → Toggle Ranger ↔ Claude
- `prefix + R` → Reload Kitsune panes
- `prefix + %` → Split vertical
- `prefix + "` → Split horizontal
- `prefix + arrow` → Move between panes
- `prefix + z` → Zoom pane
- `prefix + x` → Kill pane
- `prefix + d` → Detach

---

## Ranger

- `<Enter>` → Open file in Neovim
- `sv` → Open in vertical split in Neovim
- `sh` → Open in horizontal split in Neovim

---

## Neovim

- `:RangerReveal` → Sync Ranger to current file
- `<leader>fr` → Shortcut for RangerReveal

---

## Shell

- Aliases: `ll`, `la`, `gs`, `gd`, `gl`
- Functions: `mkcd`, `extract`
- Spaceship prompt configured

---

## Backup

Original files overwritten by the installer are saved in `~/kitsune-backup/YYYY-MM-DD-HHMM/`.
