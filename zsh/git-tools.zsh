gstart() {
  local type="$1"
  local name="$2"
  if [ -z "$type" ] || [ -z "$name" ]; then
    echo 'Usage: gstart feat short-desc'
    return 2
  fi
  git switch master
  git pull --ff-only
  git switch -c "${type}/${name}"
}


gfinish() {
  # Keep strict error handling local to this function. A global `set -e` can
  # otherwise remain enabled and unexpectedly terminate the interactive shell.
  emulate -L zsh
  setopt err_return pipe_fail

  local base="${1:-master}" # branche finale master si null
  [ $# -gt 0 ] && shift     # safeguard si oubli d'arg
  local title="$1"
  [ $# -gt 0 ] && shift     # safeguard si oubli d'arg
  local body="${1:-}"
  [ $# -gt 0 ] && shift     # safeguard si oubli d'arg
  local merge_type="${1:-squash}"

  if ! command -v gh >/dev/null 2>&1; then
    echo "Error: gh not found. On NixOS: nix shell nixpkgs#gh"
    return 127
  fi

  local branch
  branch="$(git rev-parse --abbrev-ref HEAD)"

  if [ "$branch" = "$base" ]; then
    echo "Error: you are not allowed to directly edit $base."
    return 2
  fi

  if ! git diff --quiet || ! git diff --cached --quiet; then
    git add -A # si vous voulez un autre add c'est ici, mais jsuis un bourrin moi
    if [ -z "$title" ]; then
      echo 'Usage: gfinish [base] "type: title" ["body"]'
      echo 'Example: gfinish master "feat: add parser"'
      return 2
    fi
    git commit -m "$title"
  else
    echo "No local changes to commit."
  fi

  if ! git push -u origin "$branch"; then
    echo "Push failed (maybe non-fast-forward). Try:"
    echo "  git pull --rebase"
    echo "  git push"
    echo "then rerun gfinish."
    return 1
  fi

  local pr_url
  if gh pr view "$branch" --json url -q .url >/dev/null 2>&1; then
    pr_url="$(gh pr view "$branch" --json url -q .url)"
    echo "PR already exists: $pr_url"

    local pr_state
    pr_state="$(gh pr view "$branch" --json state -q .state)"
    if [ "$pr_state" = "CLOSED" ]; then
      echo "PR is CLOSED; creating a new PR."
      gh pr create --base "$base" --head "$branch" --title "$title" --body "$body"
      pr_url="$(gh pr view "$branch" --json url -q .url)"
      echo "Created PR: $pr_url"
    fi
  else
    if [ -z "$title" ]; then
      echo 'Error: PR title required when creating PR.'
      return 2
    fi

    gh pr create --base "$base" --head "$branch" --title "$title" --body "$body"
    pr_url="$(gh pr view "$branch" --json url -q .url)"
    echo "Created PR: $pr_url"
  fi

  gh pr merge "$branch" --"$merge_type" --auto --delete-branch

  git switch "$base"
  git pull --ff-only

  git branch -d "$branch" || true

  echo "Done ^^"
}

rm-auto()
{
    echo "Deleting autotools trashfiles"
    rm -r aclocal.m4 ar-lib compile configure configure~ depcomp install-sh missing autom4te.cache config.log config.status
    find . -name Makefile.in -delete
    find . -name Makefile -delete
    echo "Done ^^"
}
