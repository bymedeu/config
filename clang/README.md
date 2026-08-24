# Shared Clang configuration

This directory is the source of truth for reusable Clang configuration:

- `.clang-format` controls source formatting.
- `.clang-tidy` requires directly including the headers that provide used
  symbols and reports unused includes.
- `.clangd` makes the language server parse Doxygen commands and render
  parameter and return documentation in completion and hover results.

Link all three files into one or more repositories with:

```sh
~/.config/clang/link-project ~/projects/first-repository \
    ~/projects/second-repository
```

The helper calculates relative symlink targets and refuses to overwrite a
regular configuration file. Run it again after moving a repository.

Clang-Tidy needs an accurate compilation database. For CMake projects, enable
it with:

```sh
cmake -S . -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
```

These symlinks are intended as local opt-ins. Avoid committing them to a
repository used by other people because their filesystem layout may differ.
Commit a real copy of the configuration when a project's contributors should
all use the same rules.
