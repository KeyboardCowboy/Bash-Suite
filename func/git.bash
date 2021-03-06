#!/bin/sh
# Git specific functions

# Git Autocomplete
source ~/.bash_config/global/lib/.git-completion.bash

##
# Shortcut to push the current branch of a git repo.
#
function gp {
  BRANCH=$(git_get_current_branch)
  REMOTES=$@

  # If no remotes were passed in, push to origin.
  if [[ -z "$REMOTES" ]]; then
    REMOTES='origin'
  fi

  # If 'all', get list of remotes
  if [[ "$REMOTES" == 'all' ]]; then
    REM=`git remote`

    # Break the remotes into an array
    REMOTES=$(echo $REM | tr " " "\n")
  fi

  # Iterate through the array, pushing to each remote
  for R in $REMOTES; do
    echo -e "${GREEN}Pushing $BRANCH to $R...${RESET}"
    git push -u $R $BRANCH
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

##
# Get the project name from custom config keys.
##
function git_project_name {
  if [ -n "$(is_git)" ]; then
    local PROJ=`git config --get-all project.name`

    if [ -n "$PROJ" ]; then
      echo "$PROJ"
    else
      echo "No project name. (git config project.name 'Project Name')"
    fi
  fi
}

##
# Get the root directory of this GIT project.
##
function git_root_dir {
  if [ -n "$(is_git)" ]; then
    echo ""#$(git rev-parse --show-toplevel)
  fi
}
