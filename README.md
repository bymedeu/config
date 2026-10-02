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

Clone or pull into `~/.config`, then restore the public links and your private
settings in this order:

```sh
python3 ~/.config/install.py
git clone git@github.com:bymedeu/config-private.git ~/config-private
python3 ~/config-private/install.py
```

If `~/config-private` is already cloned, use that checkout instead of cloning
again. The private installer restores your monitor layout, local paths and
wallpaper/lockscreen images. Do not copy example overlays over those files.

If you intentionally have no private repository, create the example overlays
instead:

```sh
cp ~/.config/zsh/private_local.zsh.example ~/.config/zsh/private_local.zsh
cp ~/.config/hypr/local/hyprland.lua.example ~/.config/hypr/local/hyprland.lua
```

That alternative uses the public default monitor preset. Add your own images
under `hypr/images/` and adapt monitor settings for the new machine.

VS Code / Codium: copy [`vscode/settings.json`](vscode/settings.json) into
`Code/User/settings.json` (or the equivalent Codium/Cursor user folder).
Those editor data directories are not versioned.

Clang helpers: [`clang/README.md`](clang/README.md).
Zsh modules: [`zsh/README.md`](zsh/README.md).

## Consolidated desktop files

Albert, its Waybar theme and web searches, GTK/COSMIC appearance, Vim, and the command helpers are now stored here. Files imported from the earlier desktop retain their existing contents and author comments. The original source was https://forge.oblic-parallels.fr/guillm/dotfiles, with local customisations.

`python3 ~/.config/install.py` links the home Zsh/Vim entry points, Albert's theme under ~/.local/share, and the portable command helpers under ~/.local/bin. It checks all targets first, accepts absent or identical regular files, and refuses conflicting content or unrelated links. Running it again is safe. No helper is executed during installation. Older system patch helpers are preserved, not recommended as installation steps.

Install your own private overlays after the public configuration:

```sh
git clone git@github.com:bymedeu/config-private.git ~/config-private
python3 ~/config-private/install.py
```

That restores monitor settings, private paths, desktop image assets and hardware-specific helpers. The old ~/dotfiles is no longer required by the consolidated files; it has been left in place for rollback. Downloaded programs such as agy, Claude, Codex, Conan and Mermaid CLI must be reinstalled separately.

Application dependencies are not installed by these scripts: keep Albert, Kitty, GTK's adw-gtk3-dark theme, Adwaita icons, VolantesCursors, Hyprland/Hyprlock/Hyprpaper, the existing fonts and your usual Vim/Neovim plugin managers. Existing keyboard, lock, screenshot, Neovim and Zsh behaviour is unchanged.
