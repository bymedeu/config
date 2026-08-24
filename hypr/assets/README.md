# Wallpapers

Drop local images here. Nothing in this folder is committed except this
README and `.gitkeep`.

Expected names (used by `hyprpaper.conf` and `hyprlock.conf`):

- `wallpaper.jpg` — desktop background
- `lockscreen.jpg` — lock screen background

If this machine already has files in `hypr/images/`, symlink them:

```sh
ln -sfn ../images/wallpaper.jpg wallpaper.jpg
ln -sfn ../images/lockscreen.jpg lockscreen.jpg
```
