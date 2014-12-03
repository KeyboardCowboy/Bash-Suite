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
# Remote Git Exporter
##
function gex {
  read -p "REPO: " REPO
  read -p "TAG: " TAG

  git archive --format=tar $TAG --remote=$REPO | gzip > $TAG.tar.gz

  #git archive --format=tar --remote=ssh://remote_server/remote_repository master | tar -xf -
}
