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

Clone or pull into `~/.config`, then:

```sh
cp ~/.config/zsh/home.zshrc ~/.zshrc
cp ~/.config/zsh/private_local.zsh.example ~/.config/zsh/private_local.zsh
cp ~/.config/hypr/local/hyprland.conf.example ~/.config/hypr/local/hyprland.conf
```

The copied `local/hyprland.conf` sources the public default monitor
preset. For a custom desk layout:

```sh
cp ~/.config/hypr/local/monitors.conf.example ~/.config/hypr/local/monitors.conf
# edit monitors.conf, then source it from local/hyprland.conf instead of default.conf
```

Drop `wallpaper.jpg` and `lockscreen.jpg` into [`hypr/images/`](hypr/images/).
That folder is gitignored except its README.

VS Code / Codium: copy [`vscode/settings.json`](vscode/settings.json) into
`Code/User/settings.json` (or the equivalent Codium/Cursor user folder).
Those editor data directories are not versioned.

Clang helpers: [`clang/README.md`](clang/README.md).
Zsh modules: [`zsh/README.md`](zsh/README.md).
