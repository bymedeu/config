# Shared Clang configuration

This directory is the source of truth for reusable Clang configuration.
Projects opt in with relative symbolic links:

```sh
ln -s ../../.config/clang/.clang-format /path/to/project/.clang-format
```

The relative target depends on the project's location. A `.clang-tidy` or
`.clangd` file can be added here later when there are shared rules to preserve.
