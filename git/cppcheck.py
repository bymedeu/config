#!/usr/bin/env python3
"""Use a complete, snapshot-local compilation database, else portable defaults."""

import json
import subprocess
import sys
from pathlib import Path


def database(files):
    root = Path.cwd().resolve()
    for path in (Path("compile_commands.json"), Path("build/compile_commands.json")):
        if not path.is_file():
            continue
        entries = json.loads(path.read_text())
        units = {(Path(item["directory"]) / item["file"]).resolve() for item in entries}
        requested = {
            Path(name).resolve()
            for name in files
            if Path(name).suffix not in {".h", ".hh", ".hpp", ".hxx"}
        }
        if units and requested <= units and all(p.is_relative_to(root) for p in units):
            return path
    return None


def main():
    files = sys.argv[1:]
    project = database(files)
    args = [
        "cppcheck",
        "--enable=warning,style,performance,portability",
        "--error-exitcode=1",
    ]
    if project:
        args.append(f"--project={project}")
        files = [
            name for name in files if Path(name).suffix in {".h", ".hh", ".hpp", ".hxx"}
        ]
    else:
        print("cppcheck: portable file fallback (no suitable snapshot-local database)")
    return subprocess.call([*args, *files])


if __name__ == "__main__":
    sys.exit(main())
