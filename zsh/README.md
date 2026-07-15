# Zsh configuration

`~/.zshrc` is a minimal compatibility loader for `~/.config/zsh/.zshrc`.
The main file loads public modules from `rc.d/` in numeric order, followed by
optional `private_*.zsh` files.

Install the loader with:

```zsh
cp ~/.config/zsh/home.zshrc ~/.zshrc
```

Use `private_local.zsh.example` as a template. Files matching
`private_*.zsh` are ignored by Git and are appropriate for secrets,
machine-specific paths, and work-only settings.

To reload the configuration in the current shell:

```zsh
exec zsh
```
