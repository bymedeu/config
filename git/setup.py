#!/usr/bin/env python3
"""Explicit tool setup and opt-in global activation; never called from hooks."""

import argparse
import os
import shutil
import subprocess
import venv
from pathlib import Path

SOURCE = Path(__file__).resolve().parent
DATA = (
    Path(os.environ.get("XDG_DATA_HOME", Path.home() / ".local/share")) / "git-quality"
)


def run(*args, **kwargs):
    return subprocess.run([str(arg) for arg in args], check=True, **kwargs)


def install(cppcheck):
    output = run(cppcheck, "--version", capture_output=True, text=True).stdout.strip()
    if output != "Cppcheck 2.22.0":
        raise RuntimeError(f"Expected Cppcheck 2.22.0; got {output}")
    venv.create(DATA / "venv", with_pip=True)
    run(
        DATA / "venv/bin/python",
        "-m",
        "pip",
        "install",
        "-r",
        SOURCE / "requirements.txt",
    )
    target = DATA / "bin"
    target.mkdir(parents=True, exist_ok=True)
    shutil.copy2(cppcheck, target / "cppcheck")
    cfg = cppcheck.parent / "cfg"
    if cfg.is_dir():
        shutil.copytree(cfg, target / "cfg", dirs_exist_ok=True)
    print(f"Tools installed in {DATA}; no Git configuration changed")


def activate():
    hooks = SOURCE / "hooks"
    if not (DATA / "venv/bin/pre-commit").is_file():
        raise RuntimeError("Run explicit setup before activation")
    previous = subprocess.run(
        ["git", "config", "--global", "--get-all", "core.hooksPath"],
        capture_output=True,
        text=True,
        check=False,
    ).stdout.splitlines()
    if previous and previous != [str(hooks)]:
        raise RuntimeError(
            "Existing global core.hooksPath preserved; resolve conflict explicitly"
        )
    run("git", "config", "--global", "core.hooksPath", hooks)
    print(
        f"Global hooks active: {hooks}. Local core.hooksPath overrides are preserved."
    )


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--cppcheck", type=Path, help="verified locally built 2.22.0 binary"
    )
    parser.add_argument("--activate", action="store_true")
    args = parser.parse_args()
    if args.cppcheck:
        install(args.cppcheck.resolve())
    if args.activate:
        activate()
    if not args.cppcheck and not args.activate:
        parser.error("Choose --cppcheck PATH and/or --activate")


if __name__ == "__main__":
    main()
