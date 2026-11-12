#!/bin/sh
# Git specific functions

##
# Push the current branch and set upstream.
#   gp                  push to origin
#   gp origin upstream  push to each named remote
#   gp all              push to every configured remote
#
# Uses arrays so each remote stays a separate word in both bash and zsh
# (zsh does not word-split unquoted variables).
#
function gp {
  local branch r
  local -a remotes
  branch=$(git branch --show-current) || return
  if [[ -z "$branch" ]]; then
    echo "Not on a branch (detached HEAD)." >&2
    return 1
  fi

  if [[ $# -eq 0 ]]; then
    remotes=(origin)
  elif [[ "$1" == all ]]; then
    while IFS= read -r r; do remotes+=("$r"); done < <(git remote)
  else
    remotes=("$@")
  fi

  for r in "${remotes[@]}"; do
    echo -e "${GREEN}Pushing ${branch} to ${r}...${RESET}"
    git push -u "$r" "$branch"
  done
}

##
# Are we in a git project?
##
function is_git { git rev-parse --git-dir 2>/dev/null; }         # prints .git path, or nothing

##
# Get the current GIT branch (nothing if detached or not in a repo)
##
function gcb { git branch --show-current 2>/dev/null; }
function git_get_current_branch { gcb; }
