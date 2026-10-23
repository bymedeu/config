"""Real Git fixtures: staging preservation, selection, chaining and snapshots."""

import os
import subprocess
import tempfile
import unittest
from pathlib import Path

SOURCE = Path(__file__).resolve().parent
DATA = (
    Path(os.environ.get("XDG_DATA_HOME", Path.home() / ".local/share")) / "git-quality"
)


class HooksTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix="shared-hooks-test-")
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name) / "repo"
        self.root.mkdir()
        self.env = dict(
            os.environ,
            GIT_CONFIG_GLOBAL=str(Path(self.temp.name) / "global"),
            GIT_CONFIG_NOSYSTEM="1",
            PRE_COMMIT_HOME=str(Path(self.temp.name) / "cache"),
        )
        for key in ("GIT_DIR", "GIT_WORK_TREE", "GIT_INDEX_FILE"):
            self.env.pop(key, None)
        self.git("init", "-q")
        self.git("config", "user.name", "Fixture")
        self.git("config", "user.email", "fixture@example.test")
        self.git("config", "core.hooksPath", SOURCE / "hooks")
        self.git("commit", "--allow-empty", "-qm", "initial")

    def git(self, *args, success=True, cwd=None):
        result = subprocess.run(
            ["git", *map(str, args)],
            cwd=cwd or self.root,
            env=self.env,
            text=True,
            capture_output=True,
            check=False,
        )
        if success:
            self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        return result

    def hook(self, event, data="", *args):
        return subprocess.run(
            [SOURCE / "hooks" / event, *args],
            cwd=self.root,
            env=self.env,
            input=data,
            text=True,
            capture_output=True,
            check=False,
        )

    def write(self, name, text):
        path = self.root / name
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(text)
        return path

    def test_real_partial_staging_preserves_index_and_unstaged_hunks(self):
        baseline = "def one():\n    return 1\n\n\ndef two():\n    return 2\n"
        path = self.write("space name.py", baseline)
        self.git("add", ".")
        self.git("commit", "-qm", "baseline")
        path.write_text(baseline.replace("return 1", "return   3"))
        self.git("add", path.name)
        staged = self.git("show", ":" + path.name).stdout
        path.write_text(path.read_text().replace("return 2", "return 9"))
        result = self.git("commit", "-qm", "format", success=False)
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("files were modified", (result.stdout + result.stderr).lower())
        self.assertEqual(self.git("show", ":" + path.name).stdout, staged)
        self.assertIn("return 9", path.read_text())
        self.assertIn("return 3", path.read_text())
        self.assertEqual(
            self.git("log", "-1", "--format=%s").stdout.strip(), "baseline"
        )

    def test_cpp_header_python_selection_rename_and_deletion(self):
        self.write(".clang-format", "BasedOnStyle: LLVM\n")
        self.write("include/space header.hpp", "int  one( ){return 1;}\n")
        self.write("space.py", "x=  1\n")
        self.git("add", ".")
        result = self.git("commit", "-qm", "format", success=False)
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("clang-format", result.stdout + result.stderr)
        self.assertIn("Ruff format", result.stdout + result.stderr)
        self.assertEqual((self.root / "space.py").read_text(), "x = 1\n")
        self.git("add", ".")
        self.git("commit", "-qm", "formatted")
        self.git("mv", "space.py", "renamed space.py")
        self.git("rm", "include/space header.hpp")
        self.git("commit", "-qm", "rename and delete")

    def test_central_fallback_and_repository_style_precedence(self):
        config = Path(self.temp.name) / "config"
        (config / "clang").mkdir(parents=True)
        (config / "clang/.clang-format").write_text(
            "BasedOnStyle: LLVM\nIndentWidth: 8\nAllowShortFunctionsOnASingleLine: None\n"
        )
        self.env["XDG_CONFIG_HOME"] = str(config)
        path = self.write("test.cc", "int f() {\nreturn 1;\n}\n")
        self.git("add", ".")
        self.git("commit", "-qm", "central format", success=False)
        self.assertIn("\n        return 1;", path.read_text())
        self.write(
            ".clang-format",
            "BasedOnStyle: LLVM\nIndentWidth: 2\nAllowShortFunctionsOnASingleLine: None\n",
        )
        self.git("add", ".")
        self.git("commit", "-qm", "repository format", success=False)
        self.assertIn("\n  return 1;", path.read_text())
        self.assertNotIn("\n        return 1;", path.read_text())

    def test_formatter_failure_blocks_commit(self):
        self.write(".clang-format", "UnknownOption: true\n")
        self.write("test.cc", "int one() { return 1; }\n")
        self.git("add", ".")
        result = self.git("commit", "-qm", "invalid style", success=False)
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("UnknownOption", result.stdout + result.stderr)

    def test_no_language_noop_and_untrusted_hooks_not_executed(self):
        self.write("README.md", "text\n")
        self.write(".githooks/pre-commit", "#!/bin/sh\nexit 99\n").chmod(0o755)
        self.git("add", ".")
        self.git("commit", "-qm", "unconventional title is allowed")
        sha = self.git("rev-parse", "HEAD").stdout.strip()
        result = self.hook("pre-push", f"HEAD {sha} refs/heads/main {'0' * 40}\n")
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)

    def test_existing_hooks_receive_arguments_and_identical_push_input(self):
        self.write(
            ".git/hooks/pre-push",
            '#!/bin/sh\nprintf "%s\\n" "$@" > args\ncat > input\n',
        ).chmod(0o755)
        data = "delete " + "0" * 40 + " refs/heads/topic " + "1" * 40 + "\n"
        result = self.hook("pre-push", data, "origin", "fixture")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual((self.root / "input").read_text(), data)
        self.assertEqual((self.root / "args").read_text(), "origin\nfixture\n")
        self.write(".git/hooks/pre-commit", "#!/bin/sh\nexit 42\n").chmod(0o755)
        self.assertEqual(self.hook("pre-commit").returncode, 1)
        self.write("custom/pre-commit", "#!/bin/sh\necho local > local-ran\n").chmod(
            0o755
        )
        self.git("config", "core.hooksPath", "custom")
        self.git("commit", "--allow-empty", "-qm", "local override")
        self.assertTrue((self.root / "local-ran").exists())

    def test_missing_selected_tool_fails(self):
        config = self.write(
            "profile.yaml",
            """repos:
- repo: local
  hooks:
  - id: missing
    name: missing
    language: system
    entry: git-quality-tool-that-does-not-exist
    types: [python]
    stages: [pre-commit]
""",
        )
        self.git("config", "quality.config", config)
        self.write("test.py", "x = 1\n")
        self.git("add", ".")
        result = self.git("commit", "-qm", "missing", success=False)
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("not found", result.stdout + result.stderr)

    def test_push_uses_all_outgoing_tips_not_dirty_checkout(self):
        path = self.write("test.py", "answer = unknown\n")
        self.git("add", ".")
        self.git("commit", "-qm", "bad outgoing tree")
        bad = self.git("rev-parse", "HEAD").stdout.strip()
        path.write_text("answer = 42\n")
        self.git("add", ".")
        self.git("commit", "-qm", "good current tree")
        good = self.git("rev-parse", "HEAD").stdout.strip()
        path.write_text("answer = 99\n")
        data = f"HEAD {good} refs/heads/ok {'0' * 40}\n"
        data += f"older {bad} refs/heads/bad {'0' * 40}\n"
        result = self.hook("pre-push", data)
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("F821", result.stdout + result.stderr)
        self.assertEqual(path.read_text(), "answer = 99\n")

    def test_cppcheck_push_checks_headers_and_project_ruff_settings(self):
        self.write(".clang-format", "BasedOnStyle: LLVM\n")
        self.write("defect.hpp", "inline int divide(int n) { return n / 0; }\n")
        self.write("ruff.toml", '[lint]\nignore = ["F821"]\n')
        self.write("test.py", "answer = unknown\n")
        self.git("add", ".")
        self.git("commit", "-qm", "fixture")
        sha = self.git("rev-parse", "HEAD").stdout.strip()
        result = self.hook("pre-push", f"HEAD {sha} refs/heads/topic {'0' * 40}\n")
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("zerodiv", result.stdout)
        self.assertIn("Ruff check", result.stdout)
        self.assertNotIn("F821", result.stdout)

    def test_recursive_native_hook_fails_explicitly(self):
        native = self.root / ".git/hooks/pre-commit"
        native.symlink_to(SOURCE / "hooks/pre-commit")
        result = self.hook("pre-commit")
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("Recursive", result.stderr)

    def test_real_push_to_fixture_remote_and_delete(self):
        remote = Path(self.temp.name) / "remote.git"
        self.git("init", "--bare", "-q", remote)
        self.git("remote", "add", "origin", remote)
        self.git("push", "origin", "HEAD:refs/heads/topic")
        self.git("push", "origin", ":refs/heads/topic")

    def test_linked_worktree_and_submodule_native_hook_chaining(self):
        self.write(
            ".git/hooks/post-checkout", "#!/bin/sh\necho chained > chained\n"
        ).chmod(0o755)
        worktree = Path(self.temp.name) / "linked"
        self.git("worktree", "add", "-qb", "linked", worktree)
        self.git("checkout", "linked", cwd=worktree)
        self.assertTrue((worktree / "chained").exists())
        module = self.root / "module"
        self.git(
            "-c",
            "protocol.file.allow=always",
            "submodule",
            "add",
            str(worktree),
            "module",
        )
        common = self.git("rev-parse", "--git-common-dir", cwd=module).stdout.strip()
        native = (module / common).resolve() / "hooks" / "pre-commit"
        native.parent.mkdir(exist_ok=True)
        native.write_text("#!/bin/sh\necho module > module-ran\n")
        native.chmod(0o755)
        self.git("config", "core.hooksPath", SOURCE / "hooks", cwd=module)
        self.git(
            "-c",
            "user.name=Fixture",
            "-c",
            "user.email=fixture@example.test",
            "commit",
            "--allow-empty",
            "-qm",
            "module",
            cwd=module,
        )
        self.assertTrue((module / "module-ran").exists())


if __name__ == "__main__":
    unittest.main()
