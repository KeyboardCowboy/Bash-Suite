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
function is_git {
  echo `git rev-parse --git-dir 2> /dev/null;`
}

##
# Get the current GIT branch
##
function git_get_current_branch {
  echo $(gcb)
}
function gcb {
  if [ -n "$(is_git)" ]; then
    local branch_name="$(git symbolic-ref HEAD 2>/dev/null)"

    if [ -n "$branch_name" ]; then
      echo ${branch_name##refs/heads/}
    fi
  fi
}
