#!/usr/bin/env python3
"""Restore reviewed links, refusing to overwrite different files."""
import argparse
import json
import os
from pathlib import Path
REPOSITORY = Path(__file__).resolve().parent

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--home-dir', type=Path, default=Path.home())
    parser.add_argument('--config-dir', type=Path)
    parser.add_argument('--data-dir', type=Path)
    args = parser.parse_args()
    home = args.home_dir.expanduser().absolute()
    use_environment = home == Path.home()
    config = args.config_dir or Path(os.environ.get('XDG_CONFIG_HOME') or home / '.config') if use_environment else args.config_dir or home / '.config'
    data = args.data_dir or Path(os.environ.get('XDG_DATA_HOME') or home / '.local/share') if use_environment else args.data_dir or home / '.local/share'
    roots = {'home': home, 'config': config.expanduser().absolute(), 'data': data.expanduser().absolute()}
    for root in roots.values():
        if root.is_symlink() or (root.exists() and not root.is_dir()):
            parser.error(f'Restore root must be a real directory: {root}')
    pending = []
    for source_name, root_name, target_name in json.loads((REPOSITORY / 'links.json').read_text()):
        source = REPOSITORY / source_name
        target = roots[root_name] / target_name
        if not source.is_file():
            parser.error(f'Missing source: {source}')
        if target.is_symlink():
            if target.resolve() == source.resolve():
                continue
            parser.error(f'Refusing to replace another symlink: {target}')
        if target.exists() and (not target.is_file() or target.read_bytes() != source.read_bytes()):
            parser.error(f'Refusing to overwrite different content: {target}')
        for parent in target.parents:
            if parent == roots[root_name]:
                break
            if parent.is_symlink():
                parser.error(f'Refusing to write through a symlinked parent: {parent}')
            if parent.exists() and not parent.is_dir():
                parser.error(f'Not a directory: {parent}')
        temporary = target.with_name(target.name + '.config-restore-link')
        if temporary.exists() or temporary.is_symlink():
            parser.error(f'Restore temporary path already exists: {temporary}')
        pending.append((source, target))
    for source, target in pending:
        target.parent.mkdir(parents=True, exist_ok=True)
        temporary = target.with_name(target.name + '.config-restore-link')
        try:
            temporary.symlink_to(source)
            temporary.replace(target)
        except BaseException:
            if temporary.is_symlink() and temporary.resolve() == source.resolve():
                temporary.unlink()
            raise
        print(f'Linked {target}')
    print('Configuration links are connected.')

if __name__ == '__main__':
    main()
