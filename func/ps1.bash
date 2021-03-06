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
  PS1+="$(ps1_separator 'und')${UYellow}\w"

  # New Line
  PS1+="${RESET}\n"

  # Cursor
  PS1+="${CYAN}\u: $(color CYAN BRIGHT)"$CHAR_X"${RESET}"

  # Set the console title to the git project.
  PS1+="$(ps1_title)"

  echo "$PS1 "
}

##
# Get the current drush site if set.
##
function ps1_drush {
  # Make sure we can find drush.
  local OUT=""
  local DRUSH=`which drush`
  local COLOR=$1

  if [ -n "$DRUSH" ]; then
    local ME=`whoami`
    local FILE="$TMPDIR/drush-env-$ME/drush-drupal-site-$$"

    # Get the drush version.
    VER=$(drush_version)
    OUT="$(ps1_separator 'und')${COLOR}$VER"

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
    echo "$(ps1_separator 'und')${COLOR}$GPN ${CHAR_QUAD_DIAMOND} $GIT"
  fi
}

##
# Set the tab title.
##
function ps1_title {
  if [ -n "$(is_git)" ]; then
    title "$(git_project_name)"
  else
    title
  fi
}

##
# Character to separate components in the PS1 environment line.
##
function ps1_separator {
  local UWhite='\033[4;37m'
  local White='\e[0;37m'

  if [[ "$1" == "und" ]]; then
    echo -e "${UWhite} ${CHAR_DOUBLE_BACKSLASH} "
  else
    echo -e "${White} ${CHAR_DOUBLE_BACKSLASH} "
  fi
}
