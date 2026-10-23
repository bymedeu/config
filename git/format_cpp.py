#!/usr/bin/env python3
"""Honor repository Clang styles, otherwise use the live central style offline."""

import os
import subprocess
import sys
from pathlib import Path


def style(file):
    root = Path.cwd().absolute()
    directory = Path(file).absolute().parent
    while directory.is_relative_to(root):
        for name in (".clang-format", "_clang-format"):
            candidate = directory / name
            if candidate.exists() or candidate.is_symlink():
                return "file"
        if directory == root:
            break
        directory = directory.parent
    central = Path(os.environ.get("XDG_CONFIG_HOME", Path.home() / ".config"))
    fallback = central / "clang/.clang-format"
    if not fallback.is_file():
        raise RuntimeError("MISSING central clang/.clang-format; run explicit setup")
    return f"file:{fallback}"


def main():
    for file in sys.argv[1:]:
        subprocess.run(
            ["clang-format", "-i", "--Werror", f"--style={style(file)}", file],
            check=True,
        )


if __name__ == "__main__":
    main()
