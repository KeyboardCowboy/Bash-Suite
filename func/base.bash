#!/bin/bash
#
# base.cfg
# SYSTEM LEVEL FUNCTIONS

##
# Set the bash prompt lines
##
function set_prompt {
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
  PS1="\n${UCyan}\h $(ps1_separator)"

  # Drush alias setting.
  PS1+="${UBlue}\$(get_drush_site)"

  # Git Info
  PS1+="${SEPARATOR}${GREEN_UL}\$(get_git_ps1)"

  # Location
  PS1+="${SEPARATOR}${UYellow} \w"

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
function get_drush_site {
  local ME=`whoami`
  local FILE="$TMPDIR/drush-env-$ME/drush-drupal-site-"

  # First, make sure there is at least one file that matches the pattern.
  if ls $FILE 1> /dev/null 2>&1; then
    # Get the most recent file
    CURRENT=`ls -t $FILE | head -1`
    SITE=`cat $CURRENT`
    echo " $SITE $(ps1_separator)"
  fi

  # @todo If there is not a site set, try to determine what site alias scope we
  # are inside, if any.
}

##
# Get the git PS1 string
##
function get_git_ps1 {
  local GIT=$(gcb) || ''
  local GPN=$(git_project_name) || ''

  if [ -n "$GIT" ]; then
    echo " $GPN ${CHAR_QUAD_DIAMOND} $GIT $(ps1_separator)"
  fi
}

function ps1_separator {
  UWhite='\033[4;37m'       # White
  echo -e "${UWhite}${CHAR_DOUBLE_BACKSLASH}"
}

# Tree climber
#function .. {
#  [[ -n $1 ]] && DEPTH=$1 || DEPTH=1

#  COUNTER=0
#  while [ $COUNTER -lt $DEPTH ]; do
#    cd ..
#    let COUNTER=COUNTER+1
#  done
#}

# Add the project name to the console title
function set_title {
  title $(git_project_name) || ''
}

# Edit a configuration file or open the bash profile
function bp() {
  DIR=$1
  FILE=$2

  if [ "$DIR" == "vars" ]; then
    e ~/.bash_config/vars.inc
  elif [ "$DIR" == "l" ]; then
    if [ -n "$FILE" ]; then
      e ~/.bash_config/local/$FILE.cfg
    else
      # If no filename was passed, go to the directory
      cd ~/.bash_config/local
    fi
  elif [ "$DIR" == "g" ]; then
    if [ -n "$FILE" ]; then
      e ~/.bash_config/global/$FILE.cfg
    else
      cd ~/.bash_config/global
    fi
  else
    # If the first paramater is not "l" or "g", open the bash_profile
    e ~/.bash_profile
  fi
}

# Reprogram the EDIT function
function edit() {
  FILE=$1

  if [ -n "$FILE" ]; then
    case $(uname) in
      'Darwin')
        open -a "$TEXT_EDITOR" $FILE;;

      *)
        vi $FILE;;
    esac
  else
    _edit
  fi
}

# Helper function to select a file to edit from a list of the directory
function _edit() {
  echo "------------------------"
  pwd

  i=1
  for file in *; do
    files[i]=$file
    echo "$i. $file"
    ((i++))
  done

  files["e"]="EXIT"
  echo "E. EXIT"

  read -p 'Select a file number: ' NUM

  if [ -f ${files[$NUM]} ]; then
    edit ${files[$NUM]}
  fi
}

# Explode a string into an array, like PHP
function explode() {
  DEL=$1
  STR=$2
  ARR=$(echo $STR | tr "$DEL" "\n")
  echo $ARR
}

# Delete a set of files
function fd() {
  read -p "Delete all instances of '$1' in this tree? (y/n) " X
  if [ $X == "y" ]; then
    find . -name '$1' -exec "rm {}" \;
  else
    echo 'Cancelled.'
  fi
}

# Shortcut to edit specific common files
function fedit() {
  case $1 in
    "apache")
      edit $APACHE_CONFIG_FILE;;
    "hosts")
      edit $HOSTS_FILE
  esac
}

# Find files below the current directory
function ff() {
  sudo find . -name "$1" -print
}

# Find files anywhere on the server
function ffall() {
  sudo find / -name "$1" -print
}

# Relative environment display
function ll() {
  local SVN=$(svn_project_name)
  local GIT=$(git_project_name)

  local OUT;
  OUT="PWD: "$(color CYAN)`pwd`$(color RESET)

  if [ -n "$SVN" ]; then
    OUT="$OUT\nSVN: $(color YELLOW)$SVN$(color RESET)"
  fi
  if [ -n "$GIT" ]; then
    OUT="$OUT\nGIT: $(color GREEN)$GIT$(color RESET)"
  fi

  decho
  echo -e $OUT
  decho
}

# Development Env Status
function denv {
  decho
  echo "You are:" $(whoami)
  echo "PWD:" $(pwd)
  echo "Git Repo:" $(git config project.name)
  decho
}

# Set the console title
function title() {
  if [ -n "$1" ]; then
    echo -en "\033]1;$STITLE: $1\007"
  else
    echo -en "\033]1;$TITLE\007"
  fi
}
