#!/usr/bin/env python3
"""Global hooks: native pre-commit profiles, immutable pushes, existing hooks."""

import os
import subprocess
import sys
import tarfile
import tempfile
from pathlib import Path

import yaml

SOURCE = Path(__file__).resolve().parent
DATA = (
    Path(os.environ.get("XDG_DATA_HOME", Path.home() / ".local/share")) / "git-quality"
)
os.environ["PATH"] = os.pathsep.join(
    [str(DATA / "venv/bin"), str(DATA / "bin"), str(SOURCE), os.environ.get("PATH", "")]
)


def run(*args, **kwargs):
    return subprocess.run([str(arg) for arg in args], check=True, **kwargs)


def git(*args):
    return run("git", *args, capture_output=True, text=True).stdout.strip()


def setting(name):
    result = subprocess.run(
        ["git", "config", "--local", "--get", name],
        capture_output=True,
        text=True,
        check=False,
    )
    return result.stdout.strip()


def clean_env():
    names = git("rev-parse", "--local-env-vars").splitlines()
    return {key: value for key, value in os.environ.items() if key not in names}


def profile():
    path = Path(setting("quality.config") or SOURCE / "default.yaml").resolve()
    config = yaml.safe_load(path.read_text())
    for repo in config["repos"]:
        if repo["repo"] != "local":
            raise RuntimeError("Offline profiles require repo: local")
        for hook in repo["hooks"]:
            if hook["language"] != "system" or hook.get("additional_dependencies"):
                raise RuntimeError("Offline profiles require preinstalled system tools")
    return path


def framework(config, stage, cwd=None, env=None):
    args = [
        sys.executable,
        "-m",
        "pre_commit",
        "run",
        "--config",
        config,
        "--hook-stage",
        stage,
    ]
    if stage == "pre-push":
        args.append("--all-files")
    # SKIP is not a policy override for these hooks.
    active = dict(env or os.environ)
    active.pop("SKIP", None)
    run(*args, cwd=cwd, env=active)


def snapshot(sha, directory):
    archive = directory / "tree.tar"
    with archive.open("wb") as output:
        run("git", "archive", "--format=tar", f"{sha}^{{tree}}", stdout=output)
    tree = directory / "tree"
    tree.mkdir()
    with tarfile.open(archive) as source:
        source.extractall(tree, filter="data")
    env = clean_env()
    run("git", "init", "-q", tree, env=env)
    run("git", "-C", tree, "add", "--force", ".", env=env)
    return tree, env


def push(config, data):
    updates = [line.split() for line in data.splitlines() if line.strip()]
    if any(len(update) != 4 for update in updates):
        raise RuntimeError("Malformed pre-push input")
    tips = dict.fromkeys(update[1] for update in updates if set(update[1]) != {"0"})
    for sha in tips:
        with tempfile.TemporaryDirectory(prefix="git-quality-push-") as directory:
            tree, env = snapshot(sha, Path(directory))
            framework(config, "pre-push", cwd=tree, env=env)


def existing(event, args, data):
    # --git-common-dir handles linked worktrees and submodules; hooksPath would
    # make --git-path hooks point back here and recurse.
    hook = Path(git("rev-parse", "--git-common-dir")).resolve() / "hooks" / event
    if hook.is_file() and os.access(hook, os.X_OK):
        if hook.resolve().is_relative_to(SOURCE):
            raise RuntimeError(f"Recursive existing hook: {hook}")
        run(hook, *args, input=data if event == "pre-push" else None, text=True)


def main():
    event, *args = sys.argv[1:]
    data = sys.stdin.read() if event == "pre-push" else ""
    existing(event, args, data)
    adapter = setting("quality.adapter")
    if adapter and event in {"pre-push", "commit-msg"}:
        run(
            sys.executable,
            Path(adapter).resolve(),
            event,
            *args,
            input=data if event == "pre-push" else None,
            text=True,
        )
    if event == "pre-commit":
        framework(profile(), event)
    elif event == "pre-push":
        push(profile(), data)


if __name__ == "__main__":
    try:
        main()
    except (OSError, RuntimeError, subprocess.CalledProcessError) as error:
        print(f"git-quality: {error}", file=sys.stderr)
        sys.exit(1)
