# XDG configuration

This repository lives at `~/.config`. It tracks only settings that are
worth restoring on another machine: bindings, theme, plugins, layout, and
workflow. App dumps, caches, and credentials stay untracked.

GitHub CLI auth (`gh/`) is not in this repo. On a new machine, run
`gh auth login`.

## Layers

1. **Shared theme** — [`colors/`](colors/) used by Waybar, SwayNC, Kitty, and Hyprland.
2. **Public app configs** — portable files under each allowlisted directory.
3. **Machine overlay** — gitignored `hypr/local/` and `zsh/private_*.zsh`.
4. **Secrets and junk** — never tracked.

`.gitignore` denies everything by default, then allowlists those trees.

## New machine

Clone this repository into `~/.config` and install its links:

```sh
git clone https://github.com/bymedeu/config.git ~/.config
python3 ~/.config/install.py
```

If it is already cloned, run the installer from that checkout. An existing
nonempty `~/.config` must be backed up or reconciled before cloning.

Optional machine settings can be created from the examples. Copy only files
that do not already exist, so existing local settings are preserved:

```sh
cp -n ~/.config/zsh/private_local.zsh.example ~/.config/zsh/private_local.zsh
cp -n ~/.config/hypr/local/hyprland.lua.example ~/.config/hypr/local/hyprland.lua
```

The default monitor preset works without an overlay. Add your own images under
`hypr/images/` and adapt local monitor settings for the machine. Local overlays
are optional, gitignored files that you manage independently.

VS Code / Codium: copy [`vscode/settings.json`](vscode/settings.json) into
`Code/User/settings.json` (or the equivalent Codium/Cursor user folder).
Those editor data directories are not versioned.

Clang helpers: [`clang/README.md`](clang/README.md).
Zsh modules: [`zsh/README.md`](zsh/README.md).

## Consolidated desktop files

Albert, its Waybar theme and web searches, GTK/COSMIC appearance, Vim, and the command helpers are now stored here. Files imported from the earlier desktop retain their existing contents and author comments. The original source was https://forge.oblic-parallels.fr/guillm/dotfiles, with local customisations.

`python3 ~/.config/install.py` links the home Zsh/Vim entry points, Albert's theme under ~/.local/share, and the portable command helpers under ~/.local/bin. It checks all targets first, accepts absent or identical regular files, and refuses conflicting content or unrelated links. Running it again is safe. No helper is executed during installation. Older system patch helpers are preserved, not recommended as installation steps.

Downloaded programs such as agy, Claude, Codex, Conan and Mermaid CLI must be reinstalled separately.

Application dependencies are not installed by these scripts: keep Albert, Kitty, GTK's adw-gtk3-dark theme, Adwaita icons, VolantesCursors, Hyprland/Hyprlock/Hyprpaper, the existing fonts and your usual Vim/Neovim plugin managers. Existing keyboard, lock, screenshot, Neovim and Zsh behaviour is unchanged.
