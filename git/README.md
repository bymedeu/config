# Shared Git quality hooks

One maintained source in `${XDG_CONFIG_HOME:-$HOME/.config}/git`. These hooks
apply to **all repositories by default** after explicit activation. Git's local
`core.hooksPath` wins as usual. No repository is silently opted into commit-title
or branch policy. Existing executable hooks under the common Git directory's
`hooks/` are chained first, with original arguments and pre-push input. All
standard Git hook names forward to them; recursive links fail explicitly.

## Setup and rollback

Use Python 3.12+ and explicitly prepare cppcheck 2.22.0 from the official source
revision `a436ca35ed1887bee789765122b65ed2d7a7e045`. Then:

```sh
config=${XDG_CONFIG_HOME:-$HOME/.config}
python3 "$config/git/setup.py" --cppcheck /path/to/built/cppcheck
python3 "$config/git/setup.py" --activate
```

Setup installs pinned pre-commit, clang-format, Ruff and Lizard in
`${XDG_DATA_HOME:-$HOME/.local/share}/git-quality/venv`, and copies the verified
cppcheck binary and adjacent `cfg` to durable user data. It never installs system
packages. Activation refuses an existing conflicting global hooksPath. Roll back
with `git config --global --unset core.hooksPath`; retained native hooks become
Git's direct hooks again. Restore any former setting explicitly if appropriate.
No native hook files or repository indexes are changed during activation.

## Behavior and extension

`default.yaml` is ordinary [pre-commit configuration](https://pre-commit.com/):
C/C++ including headers use clang-format at commit, honoring repository styles
first and otherwise the live central `clang/.clang-format` via XDG/HOME discovery; Python uses Ruff format.
pre-commit preserves unstaged changes and fails when a formatter modifies files;
review and re-stage deliberately. Nothing automatically stages whole files.
Push checks **every nondeleted outgoing tip**, from an isolated tracked snapshot,
with cppcheck, Lizard physical function length <=40 / CCN <=10 and Ruff check.
No-language repositories no-op; missing selected tools fail. No full compilation,
tidy or sanitizers run from the generic hooks. Existing Python Ruff settings apply.
No semantic `--fix` is enabled. Gitlinks are not recursively acquired/analyzed;
each submodule uses hooks when operated on as its own repository.

Cppcheck uses a compilation database only when it covers the selected units and
references files within the snapshot. Otherwise it logs a portable file fallback,
without imposing any project's standard, defines or dependency paths. For project
flags, use an explicit profile/adapter. No network access, package setup or central
style downloads occur in hooks. Only `repo: local`, `language: system` entries
are accepted. Native tools may have their own behavior; select trusted offline
commands. Formatters intentionally honor project style files.

Select a custom declarative profile through **local** Git configuration:

```sh
git config --local quality.config /path/to/profile.yaml
```

Copy `default.yaml` and extend `types`, `types_or`, `files`, `exclude`, `stages`
and `entry`. A tracked profile path can be relative to the repository root.
Optional JS/TS examples (not enabled or installed by setup):

```yaml
- id: prettier
  name: Prettier
  language: system
  entry: ./node_modules/.bin/prettier --write
  types_or: [javascript, jsx, ts, tsx, json, css]
  stages: [pre-commit]
- id: eslint
  name: ESLint
  language: system
  entry: ./node_modules/.bin/eslint
  types_or: [javascript, jsx, ts, tsx]
  stages: [pre-push]
```

Install project tools explicitly beforehand; avoid `npx` downloads. For pushes,
project tools must be provided outside the disposable snapshot, e.g. use an
absolute, locally configured entry pointing to an installed project tool. To
select installed Python tools, use the same `entry` mechanism. Keep machine paths
in an untracked local profile rather than publishing them.

An explicit `git config --local quality.adapter tools/quality/hooks.py` authorizes
that Python adapter for commit-msg and pre-push policy. Cloned `.githooks` files
are never executed merely because they exist. MSC uses this opt-in plus its own
tracked profile. A local hooksPath override selects a wholly independent hook
setup; remove that local setting to inherit the shared default again.

Run `python -m unittest discover -s git -p 'test_*.py'` from this repository after
setup. Tests use isolated Git configuration, real staging and fixture remotes.
