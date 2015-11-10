#!/usr/bin/env bash

##
# Set the bash prompt lines
##
function set_prompt {
  # Build colors.
  local BG_CYAN="\[$(color CYAN BRIGHT BG)\]"
  local BG_GREEN="\[$(color GREEN BRIGHT BG)\]"
  local BG_GREEN_DULL="\[$(color GREEN DULL BG)\]"
  local BG_PURPLE="\[$(color VIOLET BRIGHT BG)\]"
  local RESET="\[$(color RESET)\]"

  UPurple='\e[4;35m'      # Purple
  UCyan='\e[4;36m'        # Cyan
  UGreen='\e[1;32m'       # Green
  UBlue='\e[4;34m'        # Blue
  UYellow='\e[4;33m'      # Yellow

  # Hostname
  PS1="\n${UCyan}\h"

  # Drush.
  PS1+="\$(ps1_drush '${UBlue}')"

  # Git Info
  PS1+="\$(ps1_git '${GREEN_UL}')"

  # Location
  PS1+="$(ps1_separator)${UYellow}\w"

  # New Line
  PS1+="${RESET}\n"

  # Cursor
  PS1+="${CYAN}\u: $(color CYAN BRIGHT)"$CHAR_X"${RESET}"

  # Set the console title to the git project.
  set_title

  echo "$PS1 "
}

##
# Get the current drush site if set.
#
# Drush was hacked to remove the posix_getppid() tail of the filename so that
# the alias would remain consistent across sessions.
#
# @see drush_sitealias_get_envar_filename()
##
function ps1_drush {
  # Make sure we can find drush.
  local OUT=""
  local DRUSH=`which drush`
  local COLOR=$1

  if [ -n "$DRUSH" ]; then
    local ME=`whoami`
    local FILE="$TMPDIR/drush-env-$ME/drush-drupal-site-"

    # Get the drush version.
    VER=`drush --version --pipe`
    OUT="$(ps1_separator)${COLOR}$VER"

    # First, make sure there is at least one file that matches the pattern.
    if ls $FILE 1> /dev/null 2>&1; then
      # Get the most recent file
      CURRENT=`ls -t $FILE | head -1`
      SITE=`cat $CURRENT`
      OUT+=" ${CHAR_QUAD_DIAMOND} $SITE"
    fi

    # @todo If there is not a site set, try to determine what site alias scope we
    # are inside, if any.
  fi

  echo $OUT
}

##
# Get the git PS1 string
##
function ps1_git {
  local COLOR=$1
  local GIT=$(gcb) || ''
  local GPN=$(git_project_name) || ''

  if [ -n "$GIT" ]; then
    echo "$(ps1_separator)${COLOR}$GPN ${CHAR_QUAD_DIAMOND} $GIT"
  fi
}

function ps1_separator {
  UWhite='\033[4;37m'       # White
  echo -e "${UWhite} ${CHAR_DOUBLE_BACKSLASH} "
}
